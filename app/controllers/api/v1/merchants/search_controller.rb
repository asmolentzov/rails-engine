class Api::V1::Merchants::SearchController < ApplicationController
  
  def show
    if params[:id]
      merchant = Merchant.find(params[:id])
    elsif params[:name]
      merchant = Merchant.find_by(name: params[:name])
    elsif params[:created_at]
      merchant = Merchant.find_by(created_at: params[:created_at])
    elsif params[:updated_at]
      merchant = Merchant.find_by(updated_at: params[:updated_at])
    end
    render json: MerchantSerializer.new(merchant)
  end
end