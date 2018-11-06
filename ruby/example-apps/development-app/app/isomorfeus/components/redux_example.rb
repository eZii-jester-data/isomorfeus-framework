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
        ElectricCar.all.each do |car|
          TR do
            TD { car.brand }
            TD { car.model }
          end
        end
      end
    end
  end
end
