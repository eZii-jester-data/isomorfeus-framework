class LucidExample < LucidComponent::Base
  render do
    H2 { 'Electric Cars (Lucid version)' }
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
