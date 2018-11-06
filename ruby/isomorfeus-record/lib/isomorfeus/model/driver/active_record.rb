module Isomorfeus
  module Model
    module Driver
      class ActiveRecord < ::Isomorfeus::Model::Driver::Generic
        if RUBY_ENGINE != 'opal'
          def find(id)
            begin
              @model.find(id)
            rescue ActiveRecord::RecordNotFound
              nil
            end
          end

          def add_to_relation(left_record, right_record, sym_relation_name)
            relation_type = @model.reflect_on_association(sym_relation_name)&.macro
            if %i[belongs_to has_one].include?(relation_type)
              record.send("#{sym_relation_name}=", right_record)
              record.save
            else
              record.send(sym_relation_name) << right_record
            end
          end

          def has_relation?(sym_relation_name)
            !!@model.reflect_on_association(sym_relation_name)&.macro
          end

          def remove_from_relation(left_record, right_record, sym_relation_name)
            record.send(sym_relation_name).delete(right_record)
            relation_type = @model.reflect_on_association(sym_relation_name)&.macro
            if %i[belongs_to has_one].include?(relation_type)
              record.send("#{sym_relation_name}=", nil)
              record.save
            else
              record.send(sym_relation_name).delete(right_record)
            end
          end
        end
      end
    end
  end
end