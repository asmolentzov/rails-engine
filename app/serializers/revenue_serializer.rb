class RevenueSerializer
  include FastJsonapi::ObjectSerializer
  # attributes 
  
  attribute :revenue do |object|
    object.total_revenue
  end
end
