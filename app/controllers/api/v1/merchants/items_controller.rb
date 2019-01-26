class Api::V1::Merchants::ItemsController < ApplicationController
  
  def index
    merchant = Merchant.find(params[:merchant_id])
    render json: MerchantItemsSerializer.new(merchant.items)
  end
end