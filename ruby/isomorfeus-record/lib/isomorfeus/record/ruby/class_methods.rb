module Isomorfeus
  module Record
    module Ruby
      module ClassMethods
        def isomorfeus_orm_driver
          @orm_driver ||= Isomorfeus::Model::Driver::ActiveRecord.new(self)
        end

        def isomorfeus_orm_driver=(driver)
          @orm_driver = driver.new(self)
        end
      end
    end
  end
end
