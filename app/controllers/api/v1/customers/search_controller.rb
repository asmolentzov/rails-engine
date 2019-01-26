class Api::V1::Customers::SearchController < ApplicationController
  
  def index
    render json: CustomerSerializer.new(find_customers(params))
  end
  
  def show
    render json: CustomerSerializer.new(find_customers(params).first)
  end
  
  private
  
  def find_customers(params)
    if params[:id]
      Customer.where(id: params[:id])
    elsif params[:first_name]
      Customer.where("first_name ILIKE ?", params[:first_name])
    elsif params[:last_name]
      Customer.where("last_name ILIKE ?", params[:last_name])
    elsif params[:created_at]
      Customer.where(created_at: params[:created_at])
    elsif params[:updated_at]
      Customer.where(updated_at: params[:updated_at])
    end
  end
  
end