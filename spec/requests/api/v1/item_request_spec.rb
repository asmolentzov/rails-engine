require 'rails_helper' 

describe 'Item API' do
  describe 'For a collection of items' do
    before(:each) do
      create_list(:item, 3)
    end
    
    it 'returns all items' do
      get '/api/v1/items'
      
      expect(response).to be_successful
      
      returned_items = JSON.parse(response.body)["data"]
      expect(returned_items.count).to eq(3)
      expect(returned_items.first["type"]).to eq("item")
    end
  end
  
  describe 'For a single item' do
    before(:each) do
      @item = create(:item)
    end
    it 'can return a single item' do
      get "/api/v1/items/#{@item.id}"
      
      expect(response).to be_successful
      returned_item = JSON.parse(response.body)
      
      expect(returned_item.count).to eq(1)
      expect(returned_item["data"]["attributes"]["id"]).to eq(@item.id)
    end
  end
end