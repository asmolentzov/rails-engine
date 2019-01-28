class Api::V1::InvoiceItems::SearchController < ApplicationController
  
  def index
    if params[:unit_price]
      price = (params[:unit_price].to_f * 100).to_i
      render json: InvoiceItemSerializer.new(InvoiceItem.where(unit_price: price))
    else
      render json: InvoiceItemSerializer.new(InvoiceItem.where(search_params))
    end
  end
  
  def show
    if params[:unit_price]
      price = (params[:unit_price].to_f * 100).to_i
      render json: InvoiceItemSerializer.new(InvoiceItem.where(unit_price: price).first)
    else
      render json: InvoiceItemSerializer.new(InvoiceItem.where(search_params).first)
    end
  end
  
  private
  
  def search_params
    params.permit(:id, :item_id, :invoice_id, :quantity, :unit_price, :created_at, :updated_at)
  end
end