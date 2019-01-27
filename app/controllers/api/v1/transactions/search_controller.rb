class Api::V1::Transactions::SearchController < ApplicationController
  
  def show
    render json: TransactionSerializer.new(Transaction.where(search_params).first)
  end
  
  private
  
  def search_params
    params.permit(:id, :invoice_id, :credit_card_number, :result, :created_at, :updated_at)
  end
end