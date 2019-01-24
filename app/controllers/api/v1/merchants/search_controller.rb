class Api::V1::Merchants::SearchController < ApplicationController
  
  def show
    if params[:id]
      merchant = Merchant.find(params[:id])
    elsif params[:name]
      merchant = Merchant.find_by(name: params[:name])
    end
    render json: MerchantSerializer.new(merchant)
  end
end