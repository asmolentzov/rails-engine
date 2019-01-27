class BestDaySerializer
  include FastJsonapi::ObjectSerializer
  attribute :best_day do |object|
    object.best_date
  end
end
