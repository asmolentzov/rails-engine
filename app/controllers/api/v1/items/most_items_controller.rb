class Api::V1::Items::MostItemsController < ApplicationController
  
  def index
    render json: ItemSerializer.new(Item.top_items_by_number_sold(params[:quantity]))
  end
end