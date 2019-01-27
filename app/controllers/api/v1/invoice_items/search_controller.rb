class Api::V1::InvoiceItems::SearchController < ApplicationController
  
  def show
    render json: InvoiceItemSerializer.new(InvoiceItem.where(search_params).first)
  end
  
  private
  
  def search_params
    params.permit(:id, :item_id, :invoice_id, :quantity, :unit_price, :created_at, :updated_at)
  end
end