class Api::V1::Customers::SearchController < ApplicationController
  
  def show
    if params[:id]
      customer = Customer.find(params[:id])
    elsif params[:first_name]
      customer = Customer.find_by(first_name: params[:first_name])
    end
    render json: customer
  end
  
end