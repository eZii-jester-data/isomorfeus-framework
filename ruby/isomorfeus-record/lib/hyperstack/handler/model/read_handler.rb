module Isomorfeus
  module Handler
    module Model
      class ReadHandler
        include Isomorfeus::Model::SecurityGuards

        def process_request(session_id, current_user, request)
          result = {}

          request.keys.each do |model_name|
            model = guarded_record_class(model_name) # security guard

            if model.nil?
              result.merge!(model_name => { errors: { 'No such thing to read!' => '' }})
              next
            end

            result[model_name] = {}
            request[model_name].keys.each do |readables|
              method_name = "process_class_#{readables}".to_sym

              if respond_to?(method_name, true) # security guard
                send(method_name, session_id, current_user, request[model_name], result[model_name], model)
              else
                result.merge!(model_name => { errors: { readables => 'No such thing to read!' }})
              end
            end

          end

          result
        end

        private

        def process_instance_collection_queries(session_id, current_user, request_instance, result_instance, model, record)
          request_instance['collection_queries'].keys.each do |collection_method_name|
            sym_method_name = collection_method_name.to_sym

            if model.collection_queries.has_key?(sym_method_name) # security guard

              # authorize record.method
              if Isomorfeus.authorization_driver
                authorization_result = Isomorfeus.authorization_driver.authorize(current_user, model.to_s, sym_method_name, request_instance)
                if authorization_result.has_key?(:denied)
                  result_instance.merge!(errors: { collection_method_name => authorization_result[:denied] })
                  next # authorization guard
                end
              end

              method_result = model.isomorfeus_orm_driver.collection_query(record, sym_method_name)

              result_array = method_result.map do |result_record|
                               result_record.to_transport_hash
                             end

              # Isomorfeus::Model::PubSub.subscribe_relation(session_id, method_result) if Isomorfeus.model_use_pubsub

              result_instance.merge!(collection_query: { collection_method_name => result_array })
            else
              result_instance.merge!(errors: { collection_method_name => 'No such method!'})
            end
          end
        end

        def process_instance_remote_methods(session_id, current_user, request_instance, result_instance, model, record)
          request_instance['remote_methods'].keys.each do |method_name|
            sym_method_name = method_name.to_sym
            if model.remote_methods.has_key?(sym_method_name) # security guard
              request_instance['remote_methods'][method_name].keys.each do |args|

                # authorize record.method
                if Isomorfeus.authorization_driver
                  authorization_result = Isomorfeus.authorization_driver.authorize(current_user, model.to_s, sym_method_name, request_instance)
                  if authorization_result.has_key?(:denied)
                    result_instance.merge!(errors: { method_name => authorization_result[:denied] })
                    next # authorization guard
                  end
                end

                method_result = model.isomorfeus_orm_driver.remote_method(record, sym_method_name, *Oj.load(args, symbol_keys: true))

                # if Isomorfeus.model_use_pubsub
                #   Isomorfeus::Model::PubSub.subscribe_remote_method(session_id, record, "#{method_name}_#{args}")
                # end

                result_instance.merge!(remote_methods: { method_name => { args => method_result }})
              end
            else
              result_instance.merge!(errors: { method_name => 'No such method!'})
            end
          end
        end

        def process_instance_relations(session_id, current_user, request_instance, result_instance, model, record)
          request_instance['relations'].keys.each do |relation_name|
            sym_relation_name = relation_name.to_sym

            if model.isomorfeus_orm_driver.has_relation?(sym_relation_name)# security guard

              # authorize record.relation
              if Isomorfeus.authorization_driver
                authorization_result = Isomorfeus.authorization_driver.authorize(current_user, model.to_s, sym_relation_name, request_instance)
                if authorization_result.has_key?(:denied)
                  result_instance.deep_merge!(errors: { relation_name => authorization_result[:denied] })
                  next # authorization guard
                end
              end

              relation_result = model.isomorfeus_orm_driver.relation(record, sym_relation_name)

              result = if relation_result.is_a?(Enumerable)
                         relation_result.map do |relation_record|
                           relation_record.to_transport_hash
                         end
                       else
                         # its a belongs_to or has_one, relation_result is the record or nil
                         relation_result.to_transport_hash if relation_result
                       end

              # if Isomorfeus.model_use_pubsub
              #   Isomorfeus::Model::PubSub.subscribe_relation(session_id, relation_result, record, relation_name)
              # end
              result_instance.deep_merge!(relations: { relation_name => result })
            else
              result_instance.deep_merge!(errors: { relation_name => 'No such relation!'})
            end
          end
        end

        def process_class_find_by(session_id, current_user, request_model, result_model, model)
          request_model['find_by'].keys.each do |find_by_method|
            find_by_args = request_model['find_by'][find_by_method]

            if find_by_args.size == 1 && ((find_by_method == 'find_by' && find_by_args.first.class == Hash) || find_by_method.start_with?('find_by_')) # security guard
              sym_find_by_method  = find_by_method.to_sym

              # authorize Model.find
              if Isomorfeus.authorization_driver
                authorization_result = Isomorfeus.authorization_driver.authorize(current_user, model.to_s, :find, request_model['find_by'])
                if authorization_result.has_key?(:denied)
                  result_model.deep_merge!(find_by: { errors: { find_by_method => authorization_result[:denied] }})
                  next # authorization guard
                end
              end

              record = model.isomorfeus_orm_driver.find_by(sym_find_by_method, *find_by_args)
              return result_model.deep_merge!(find_by: { find_by_method => nil }) if record.nil?

              result_model.deep_merge!(find_by: { find_by_method => record.to_transport_hash })
              # Isomorfeus::Model::PubSub.subscribe_record(session_id, record) if Isomorfeus.model_use_pubsub
            else
              result_model.deep_merge!(find_by: { errors: { find_by_method => 'Not possible!' }})
            end
          end
        end

        def process_class_instances(session_id, current_user, request_model, result_model, model)
          result_model[:instances] = {} unless result_model.has_key?(:instances)
          request_model['instances'].keys.each do |id|

            # authorize Model.find
            if Isomorfeus.authorization_driver
              authorization_result = Isomorfeus.authorization_driver.authorize(current_user, model.to_s, :find, { id => request_model['instances'][id] })
              if authorization_result.has_key?(:denied)
                result_model.deep_merge!(instances: { id => { errors:  { 'Fetch failed!' => authorization_result[:denied] }}})
                next # authorization guard
              end
            end

            record = model.isomorfeus_orm_driver.find(id)
            return result_model[:instances][id] = { errors: { 'Record not found!' => {} }} if record.nil?

            model_name = model.to_s.underscore
            result_model.deep_merge!(record.to_transport_hash[model_name])

            request_model['instances'][id].keys.each do |readables|
              method_name = "process_instance_#{readables}".to_sym
              if respond_to?(method_name, true)
                send(method_name, session_id, current_user, request_model['instances'][id], result_model[:instances][id], model, record)
              else
                result_model[:instances][id].deep_merge!(errors: { readables => 'No such thing to read' })
              end
            end
            # Isomorfeus::Model::PubSub.subscribe_record(session_id, record) if Isomorfeus.model_use_pubsub

          end
        end

        def process_class_remote_methods(session_id, current_user, request_model, result_model, model)
          request_model['remote_methods'].keys.each do |method_name|
            sym_method_name = method_name.to_sym
            if model.rest_class_methods.has_key?(sym_method_name) # security guard
              request_model['remote_methods'][method_name].keys.each do |args|

                # authorize Model.method
                if Isomorfeus.authorization_driver
                  authorization_result = Isomorfeus.authorization_driver.authorize(current_user, model.to_s, sym_method_name, request_model)
                  if authorization_result.has_key?(:denied)
                    result_model.merge!(errors: { method_name => authorization_result[:denied] })
                    next # authorization guard
                  end
                end

                result = model.isomorfeus_orm_driver.class_remote_method(sym_method_name, *Oj.load(args, symbol_keys: true))
                result_model.merge!(remote_methods: { method_name => { args => result }})

                # if Isomorfeus.model_use_pubsub
                #   Isomorfeus::Model::PubSub.subscribe_rest_class_method(session_id, model, "#{method_name}_#{args}")
                # end
              end
            else
              result_model.merge!(errors: { method_name => 'No such method!'})
            end
          end
        end

        def process_class_scopes(session_id, current_user, request_model, result_model, model)
          request_model['scopes'].keys.each do |scope_name|
            sym_scope_name = scope_name.to_sym

            if scope_name == 'all' || model.model_scopes.include?(sym_scope_name) # security guard
              request_model['scopes'][scope_name].keys.each do |args|

                # authorize Model.scope
                if Isomorfeus.authorization_driver
                  authorization_result = Isomorfeus.authorization_driver.authorize(current_user, model.to_s, sym_scope_name, request_model)
                  if authorization_result.has_key?(:denied)
                    result_model.merge!(errors: { scope_name => authorization_result[:denied] })
                    next # authorization guard
                  end
                end

                scope_result = model.isomorfeus_orm_driver.scope(sym_scope_name, *Oj.load(args, symbol_keys: true))

                result_array = scope_result.map do |scope_record|
                                 scope_record.to_transport_hash
                               end
                # if Isomorfeus.model_use_pubsub
                #   Isomorfeus::Model::PubSub.subscribe_scope(session_id, scope_result, model, "#{scope_name}_#{args}")
                # end
                result_model.merge!(scopes: { scope_name => { args => result_array }})
              end
            else
              result_model.merge!(errors: { scope_name => 'No such scope!'})
            end
          end
        end

        def process_class_where(session_id, current_user, request_model, result_model, model)
          request_model['where'].keys.each do |args|
            where_args = Oj.load(args, symbol_keys: true).first

            if where_args.class == Hash # security guard

              # authorize Model.find
              if Isomorfeus.authorization_driver
                authorization_result = Isomorfeus.authorization_driver.authorize(current_user, model.to_s, :find, request_model['where'])
                if authorization_result.has_key?(:denied)
                  result_model.deep_merge!(where: { errors: { authorization_result[:denied] => '' }})
                  next # authorization guard
                end
              end

              where_result = model.isomorfeus_orm_driver.where(where_args)

              result_array = where_result.map do |scope_record|
                               scope_record.to_transport_hash
                             end

              # if Isomorfeus.model_use_pubsub
              #   where_result.each do |record|
              #     Isomorfeus::Model::PubSub.subscribe_record(session_id, record)
              #   end
              # end

              result_model.deep_merge!(where: result_array)
            else
              result_model.deep_merge!(where: { errors: { 'Not possible!' => '' }})
            end
          end
        end
      end
    end
  end
end
