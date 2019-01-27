class Api::V1::Items::RandomController < ApplicationController
  
  def show
    render json: ItemSerializer.new(Item.limit(1).order(Arel.sql("RANDOM()")).first)
  end
end