class Api::V1::Customers::SearchController < ApplicationController
  
  def show
    if params[:id]
      customer = Customer.find(params[:id])
    elsif params[:first_name]
      customer = Customer.find_by(first_name: params[:first_name])
    elsif params[:last_name]
      customer = Customer.find_by(last_name: params[:last_name])
    elsif params[:created_at]
      customer = Customer.find_by(created_at: params[:created_at])
    elsif params[:updated_at]
      customer = Customer.find_by(updated_at: params[:updated_at])
    end
    render json: customer
  end
  
end