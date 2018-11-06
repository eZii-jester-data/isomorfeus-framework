module Isomorfeus
  module Record
    class Collection < Array

      # initialize new Isomorfeus::Record::Collection, used internally
      #
      # @param collection [Isomorfeus::Record::Collection] or [Array] of records or empty [Array]
      # @param record [Isomorfeus::Record] optional base record this collection belongs to
      # @param relation_name [String] optional base record relation name this collection represents
      def initialize(collection = [], record = nil, relation_name = nil)
        @record = record
        @relation_name = relation_name
        collection ? super(collection) : super
      end

      # add record to collection, record is saved to db, success assumed
      #
      # @param other_record [Isomorfeus::Record] record to add
      alias original_link <<

      def <<(other_record, call_promise = true)
        if @record && @relation_name
          Isomorfeus::DataAccess.register_used_store_path(:record, @record.class.model_name, :instances, @record.id, :relations, @relation_name)
        end
        _promise_link(other_record) if call_promise
        original_link(other_record)
      end

      # delete record from collection, saved to db, success assumed
      #
      # @param other_record [Isomorfeus::Record] record to delete from collection
      alias original_delete delete

      def delete(other_record)
        if @record && @relation_name
          Isomorfeus::DataAccess.register_used_store_path(:record, @record.class.model_name, :instances, @record.id, :relations, @relation_name)
        end
        _promise_unlink(other_record)
        original_delete(other_record)
      end

      def link(other_record)
        if @record && @relation_name
          Isomorfeus::DataAccess.register_used_store_path(:record, @record.class.model_name, :instances, @record.id, :relations, @relation_name)
        end
        self << (other_record)
      end

      def promise_link(other_record)
        original_link(other_record)
        _promise_link(other_record).then { self }
      end

      def promise_unlink(other_record)
        delete(other_record)
        _promise_unlink(other_record).then { self }
      end

      def unlink(other_record)
        if @record && @relation_name
          Isomorfeus::DataAccess.register_used_store_path(:record, @record.class.model_name, :instances, @record.id, :relations, @relation_name)
        end
        delete(other_record)
        self
      end

      private

      def _promise_link(other_record)
        if @record && @relation_name
          Isomorfeus.store.dispatch(type: 'RECORD_ADD_TO_RELATION', model: @record.class.model_name, id: @record.id, object_id: @record.object_id,
                                    relation: @relation_name, other_model: other_record.class.model_name, other_id: other_record.id,
                                    other_object_id: other_record.object_id)
          Isomorfeus::DataAccess.promise_fetch(:record, @record.class.model_name, :instances, @record.id, :add_to_relation,
                                       @relation_name, other_record.class.model_name, :instances, other_record.id)
        else
          Promise.new.resolve(self)
        end
      end

      def _promise_unlink(other_record)
        if @record && @relation_name
          Isomorfeus.store.dispatch(type: 'RECORD_REMOVE_FROM_RELATION', model: @record.class.model_name, id: @record.id, object_id: @record.object_id,
                                    relation: @relation_name, other_model: other_record.class.model_name, other_id: other_record.id,
                                    other_object_id: other_record.object_id)
          Isomorfeus::DataAccess.promise_fetch(:record, @record.class.model_name, :instances, @record.id, :remove_from_relation,
                                       @relation_name, other_record.class.model_name, :instances, other_record.id)
        else
          Promise.new.resolve(self)
        end
      end
    end
  end
end
