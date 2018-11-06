module Isomorfeus
  module Handler
    module Model
      class CreateHandler
        include Isomorfeus::Model::SecurityGuards

        def process_request(session_id, current_user, request)
          result = {}

          request.keys.each do |model_name|
            model = guarded_record_class(model_name)

            request[model_name]['instances'].keys.each do |some_id|

              # authorize record create
              if Isomorfeus.authorization_driver
                authorization_result = Isomorfeus.authorization_driver.authorize(current_user, model.to_s, :create, request[model_name]['instances'][id])
                if authorization_result.has_key?(:denied)
                  result.deep_merge!(model_name => { instances: { id => { errors:  { 'Record could not be created!' => authorization_result[:denied] }}}})
                  next # authorization guard
                end
              end

              if model.isomorfeus_orm_driver.create(request[model_name]['instances'][id]['properties'])
                # if Isomorfeus.model_use_pubsub
                #   if record_is_new
                #     Isomorfeus::Model::PubSub.subscribe_record(session_id, record)
                #   else
                #     Isomorfeus::Model::PubSub.pub_sub_record(session_id, record)
                #   end
                #   Isomorfeus::Model::PubSub.publish_scope(model, :all)
                # end

                result.deep_merge!(record.to_transport_hash)
              else
                result.deep_merge!(model_name => { instances: { record.id.to_s => { errors: { 'Record could not be creaed!' => '' }}}})
              end
            end

          end
          result
        end
      end
    end
  end
end