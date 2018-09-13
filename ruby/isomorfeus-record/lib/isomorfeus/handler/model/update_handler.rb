module Isomorfeus
  module Handler
    module Model
      class UpdateHandler
        include Isomorfeus::Model::SecurityGuards

        def process_request(session_id, current_user, request)
          result = {}

          request.keys.each do |model_name|
            model = guarded_record_class(model_name)

            request[model_name]['instances'].keys.each do |id|

              # authorize Model.find
              if Isomorfeus.authorization_driver
                authorization_result = Isomorfeus.authorization_driver.authorize(current_user, model.to_s, :find, { id => request[model_name]['instances'][id] })
                if authorization_result.has_key?(:denied)
                  result.deep_merge!(model_name => { instances: { id => { errors:  { 'Record could not be saved!' => authorization_result[:denied] }}}})
                  next # authorization guard
                end
              end

              record = model.isomorfeus_orm_driver.find(id)
              return result.deep_merge!(model_name => { instances: { errors: { id => { 'Record not found!' => ''}}}}) if record.nil?

              # authorize record.update
              if Isomorfeus.authorization_driver
                authorization_result = Isomorfeus.authorization_driver.authorize(current_user, model.to_s, :update, request[model_name]['instances'][id])

                if authorization_result.has_key?(:denied)
                  result.deep_merge!(model_name => { instances: { id => { errors:  { 'Record could not be saved!' => authorization_result[:denied] }}}})
                  next # authorization guard
                end
              end
              request[model_name]['instances'][id]['properties'].delete('id')

              if model.isomorfeus_orm_driver.update_attributes(record, request[model_name]['instances'][id]['properties'])
                # if Isomorfeus.model_use_pubsub
                #   Isomorfeus::Model::PubSub.pub_sub_record(session_id, record)
                #   Isomorfeus::Model::PubSub.publish_scope(model, :all)
                # end

                result.deep_merge!(record.to_transport_hash)
              else
                result.deep_merge!(model_name => { instances: { record.id.to_s => { errors: { 'Record could not be saved!' => '' }}}})
              end
            end

          end
          result
        end
      end
    end
  end
end