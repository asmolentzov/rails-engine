class TotalRevenue
  
  attr_reader :id, :total_revenue
  
  def initialize(total_revenue)
    @total_revenue = (total_revenue / 100.0).to_s
  end
  
end