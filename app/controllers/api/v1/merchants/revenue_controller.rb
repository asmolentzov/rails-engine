class Api::V1::Merchants::RevenueController < ApplicationController
  
  def index
    merchant = Merchant.find(params[:merchant_id])
    if params[:date]
      render json: RevenueDateSerializer.new(merchant, {params: {date: params[:date]}})
    else
      render json: RevenueSerializer.new(merchant) 
    end
  end
  
end