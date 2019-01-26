class Api::V1::Merchants::SearchController < ApplicationController
  
  def show
    render json: MerchantSerializer.new(find_merchants(params).first)
  end
  
  def index
    render json: MerchantSerializer.new(find_merchants(params))
  end
  
  private
  
  def find_merchants(params)
    if params[:id]
      Merchant.where(id: params[:id])
    elsif params[:name]
      Merchant.where("name ILIKE ?", params[:name])
    elsif params[:created_at]
      Merchant.where(created_at: params[:created_at])
    elsif params [:updated_at]
      Merchant.where(updated_at: params[:updated_at])
    end
  end
end