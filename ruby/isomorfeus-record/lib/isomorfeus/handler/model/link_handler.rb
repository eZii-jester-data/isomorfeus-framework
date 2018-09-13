module Isomorfeus
  module Handler
    module Model
      class LinkHandler
        include Isomorfeus::Model::SecurityGuards

        def process_request(session_id, current_user, request)
          result = {}

          request.keys.each do |model_name|

            model = guarded_record_class(model_name) # security guard

            request[model_name]['instances'].keys.each do |id|

              # authorize Model.find
              if Isomorfeus.authorization_driver
                authorization_result = Isomorfeus.authorization_driver.authorize(current_user, model.to_s, :find, { id => request[model_name]['instances'][id] })
                if authorization_result.has_key?(:denied)
                  result.deep_merge!(model_name => { instances: { id => { errors:  { 'Link failed!' => authorization_result[:denied] }}}})
                  next # authorization guard
                end
              end

              record = model.isomorfeus_orm_driver.find(id)
              return result.deep_merge!(model_name => { instances: {errors: { id => { 'Record not found!' => ''}}}}) if record.nil?


              request[model_name]['instances'][id]['relations'].keys.each do |relation_name|

                sym_relation_name = relation_name.to_sym

                if model.isomorfeus_orm_driver.has_relation?(sym_relation_name) # security guard

                  request[model_name]['instances'][id]['relations'][relation_name].keys.each do |right_model_name|

                    right_model = guarded_record_class(right_model_name) # security guard

                    request[model_name]['instances'][id]['relations'][relation_name][right_model_name].keys.each do |right_id|

                      # authorize Model.find
                      if Isomorfeus.authorization_driver
                        authorization_result = Isomorfeus.authorization_driver.authorize(current_user, right_model.to_s, :find, { right_id => request[model_name]['instances'][id]['relations'][relation_name][right_model_name]['instances'][right_id] })
                        if authorization_result.has_key?(:denied)
                          result.deep_merge!(model_name => { instances: { id => { errors:  { 'Link failed!' => authorization_result[:denied] }}}})
                          next # authorization guard
                        end
                      end

                      right_record = model.isomorfeus_orm_driver.find(id)

                      # TODO put error not found in response if right_record.nil?
                      if right_record

                        # authorize record unlink relation
                        if Isomorfeus.authorization_driver
                          authorization_result = Isomorfeus.authorization_driver.authorize(current_user, model.to_s, "#{relation_name}_link", [record, right_record])
                          if authorization_result.has_key?(:denied)
                            result.deep_merge!(model_name => { instances: { id => { errors:  { 'Link failed!' => authorization_result[:denied] }}}})
                            next # authorization guard
                          end
                        end

                        model.isomorfeus_orm_driver.link(record, right_record, sym_relation_name)

                        model.isomorfeus_orm_driver.touch(record)
                        right_model.isomorfeus_orm_driver.touch(right_record)

                        # if Isomorfeus.model_use_pubsub
                        #   Isomorfeus::Model::PubSub.pub_sub_relation(session_id, collection, record, relation_name, right_record)
                        #   Isomorfeus::Model::PubSub.pub_sub_record(session_id, right_record)
                        #   Isomorfeus::Model::PubSub.pub_sub_record(session_id, record)
                        # end

                        result.deep_merge!(record.to_transport_hash)
                        result.deep_merge!(right_record.to_transport_hash)
                      end
                    end
                  end
                end
              end
            end
          end

          result
        end
      end
    end
  end
end
