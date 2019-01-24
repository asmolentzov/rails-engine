class Api::V1::Merchants::MostRevenueController < ApplicationController
  
  def index
    merchants = Merchant.merchants_by_revenue(params[:quantity])
    render json: MerchantSerializer.new(merchants)
  end
  
end