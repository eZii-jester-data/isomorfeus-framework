module Isomorfeus
  module Model
    module Driver
      class Neo4j < ::Isomorfeus::Model::Driver::Generic
        def linking_requires_relation?
          false
        end

        if RUBY_ENGINE == 'opal'
          # nothing for now
        else
          def add_to_relation(left_record, right_record, sym_relation_name)
            relation_type = model.reflections[sym_relation_name].association.type
            if %i[belongs_to has_one].include?(relation_type)
              record.send("#{sym_relation_name}=", right_record)
              record.save
            else
              record.send(sym_relation_name) << right_record
            end
          end

          def find(id)
            begin
              @model.find(id)
            rescue Neo4j::ActiveNode::Labels::RecordNotFound
              nil
            end
          end

          def find_by(sym_find_by_method, *args)
            return nil if sym_find_by_method.start_with?('find_by_')
            @model.send(sym_find_by_method, *args)
          end

          def has_relation?(sym_relation_name)
            !!@model.reflect_on_association(sym_relation_name)&.macro
          end

          def link(left_record, right_record, options)

          end

          def remove_from_relation(left_record, right_record, sym_relation_name)
            relation_type = record.class.reflect_on_association(sym_relation_name)&.macro
            if %i[belongs_to has_one].include?(relation_type)
              record.send("#{sym_relation_name}=", nil)
              record.save
            else
              record.send(sym_relation_name).delete(right_record)
            end
          end

          def unlink(left_record, right_record, options)

          end
        end
      end
    end
  end
end
