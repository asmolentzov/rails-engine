class Api::V1::Customers::SearchController < ApplicationController
  
  def index
    if params[:id]
      customers = Customer.where(id: params[:id])
    elsif params[:first_name]
      customers = Customer.where("first_name ILIKE ?", params[:first_name])
    elsif params[:last_name]
      customers = Customer.where("last_name ILIKE ?", params[:last_name])
    elsif params[:created_at]
      created_at = Time.parse(params[:created_at])
      customers = Customer.where("created_at BETWEEN ? AND ?", created_at, created_at + 0.1)
    elsif params[:updated_at]
      updated_at = Time.parse(params[:updated_at])
      customers = Customer.where("updated_at BETWEEN ? AND ?", updated_at, updated_at + 0.1)
    end
    render json: CustomerSerializer.new(customers)
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
      customer = Customer.find_by("created_at BETWEEN ? AND ?", created_at, created_at + 0.1)
    elsif params[:updated_at]
      updated_at = Time.parse(params[:updated_at])
      customer = Customer.find_by("updated_at BETWEEN ? AND ?", updated_at, updated_at + 0.1)
    end
    render json: CustomerSerializer.new(customer)
  end
  
end