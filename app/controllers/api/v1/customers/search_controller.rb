class Api::V1::Customers::SearchController < ApplicationController
  
  def show
    customer = Customer.find(params[:id])
    render json: customer
  end
  
end