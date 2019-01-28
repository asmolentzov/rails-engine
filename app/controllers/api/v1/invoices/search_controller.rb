class Api::V1::Invoices::SearchController < ApplicationController
  
  def index
    render json: InvoiceSerializer.new(Invoice.where(search_params))
  end
  
  def show
    render json: InvoiceSerializer.new(Invoice.where(search_params).first)
  end
  
  private
  
  def search_params
    params.permit(:id, :customer_id, :merchant_id, :status, :updated_at, :created_at)
  end
end