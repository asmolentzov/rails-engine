class Api::V1::Transactions::RandomController < ApplicationController
  
  def show
    render json: TransactionSerializer.new(Transaction.limit(1).order(Arel.sql("RANDOM()")).first)
  end
end