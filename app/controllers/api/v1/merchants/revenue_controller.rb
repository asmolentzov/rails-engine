class Api::V1::Merchants::RevenueController < ApplicationController
  
  def index
    total_revenue = Merchant.all_total_revenue_by_date(params[:date])
    render json: TotalRevenueSerializer.new(TotalRevenue.new(total_revenue))
  end
  
  def show
    merchant = Merchant.find(params[:merchant_id])
    if params[:date]
      render json: RevenueDateSerializer.new(merchant, {params: {date: params[:date]}})
    else
      render json: RevenueSerializer.new(merchant) 
    end
  end
  
end