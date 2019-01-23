class Api::V1::Customers::SearchController < ApplicationController
  
  def index
    customer = Customer.where(id: params[:id])
    render json: CustomerSerializer.new(customer)
  end
  
  def show
    if params[:id]
      customer = Customer.find(params[:id])
    elsif params[:first_name]
      customer = Customer.find_by("first_name ILIKE ?", params[:first_name])
    elsif params[:last_name]
      customer = Customer.find_by("last_name ILIKE ?", params[:last_name])
    elsif params[:created_at]
      created_at = Time.parse(params[:created_at])
      customer = Customer.find_by("created_at BETWEEN ? AND ?", created_at.beginning_of_minute, created_at.end_of_minute)
    elsif params[:updated_at]
      updated_at = Time.parse(params[:updated_at])
      customer = Customer.find_by("updated_at BETWEEN ? AND ?", updated_at.beginning_of_minute, updated_at.end_of_minute)
    end
    render json: CustomerSerializer.new(customer)
  end
  
end