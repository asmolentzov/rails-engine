class Api::V1::InvoiceItems::RandomController < ApplicationController
  
  def show
    render json: InvoiceItemSerializer.new(InvoiceItem.limit(1).order(Arel.sql("RANDOM()")).first)
  end
end