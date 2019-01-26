class RevenueDateSerializer
  include FastJsonapi::ObjectSerializer

  attribute :revenue do |object, params|
    (object.total_revenue_by_date(params[:date]) / 100.0).to_s
  end
end