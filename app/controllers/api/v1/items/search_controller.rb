class Api::V1::Items::SearchController < ApplicationController
  
  def show
    if params[:unit_price]
      price = (params[:unit_price].to_f * 100).round
      render json: ItemSerializer.new(Item.where(unit_price: price).first)
    else
      render json: ItemSerializer.new(Item.where(search_params).first)
    end
  end
  
  def index
    if params[:unit_price]
      price = (params[:unit_price].to_f * 100).to_i
      render json: ItemSerializer.new(Item.where(unit_price: price))
    else
      render json: ItemSerializer.new(Item.where(search_params))
    end
  end
  
  private
  
  def search_params
    params.permit(:id, :name, :description, :unit_price, :merchant_id, :created_at, :updated_at)
  end
end