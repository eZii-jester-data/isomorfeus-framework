module Isomorfeus
  module Store # allows us to easily turn off BasicObject for debug
    class BaseStoreClass < BasicObject
    end
  end
end