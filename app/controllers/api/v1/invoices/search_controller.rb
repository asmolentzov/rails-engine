class Api::V1::Invoices::SearchController < ApplicationController
  
  def index
    render json: InvoiceSerializer.new(get_invoices(params))
  end
  
  def show
    render json: InvoiceSerializer.new(get_invoices(params).first)
  end
  
  private
  
  def get_invoices(params)
    if params[:id]
      Invoice.where(id: params[:id])
    elsif params[:customer_id]
      Invoice.where(customer_id: params[:customer_id])
    elsif params[:merchant_id]  
      Invoice.where(merchant_id: params[:merchant_id])
    elsif params[:status]
      Invoice.where("status ILIKE ?", params[:status])
    end
  end
end