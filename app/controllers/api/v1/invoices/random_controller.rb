class Api::V1::Invoices::RandomController < ApplicationController

  def show
    render json: InvoiceSerializer.new(Invoice.limit(1).order(Arel.sql("RANDOM()")).first)
  end  
end
