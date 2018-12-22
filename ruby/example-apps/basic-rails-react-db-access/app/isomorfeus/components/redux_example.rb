class ReduxExample < React::ReduxComponent::Base
  render do
    H2 { 'Electric Cars (Redux version)' }
    TABLE do
      THEAD do
        TR do
          TH { 'Brand' }
          TH { 'Model' }
        end
      end
      TBODY do
        all_cars = ElectricCar.all
        all_cars.each do |car|
          TR do
            TD do
              car.brand
            end
            TD do
              car.model
            end
          end
        end
      end
    end
  end
end
