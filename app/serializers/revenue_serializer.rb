class RevenueSerializer
  include FastJsonapi::ObjectSerializer
  
  attribute :revenue do |object|
    object.total_revenue / 100.0
  end
end
