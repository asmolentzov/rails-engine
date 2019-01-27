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
    it 'can find all items by id' do
      item = create(:item)
      
      get "/api/v1/items/find_all?id=#{item.id}"
      
      expect(response).to be_successful
      
      returned_items = JSON.parse(response.body)["data"]
      expect(returned_items.count).to eq(1)
      expect(returned_items.first["attributes"]["id"]).to eq(item.id)
    end
    it 'can find all items by name' do
      item = create(:item, name: 'Thing')
      item_2 = create(:item, name: 'Thing')
      
      get "/api/v1/items/find_all?name=#{item.name}"
      
      expect(response).to be_successful
      
      returned_items = JSON.parse(response.body)["data"]
      expect(returned_items.count).to eq(2)
      expect(returned_items.first["attributes"]["id"]).to eq(item.id)
      expect(returned_items.last["attributes"]["id"]).to eq(item_2.id)
    end
    it 'can find all items by description' do
      item = create(:item, description: 'Thing')
      item_2 = create(:item, description: 'Thing')
      
      get "/api/v1/items/find_all?description=#{item.description}"
      
      expect(response).to be_successful
      
      returned_items = JSON.parse(response.body)["data"]
      expect(returned_items.count).to eq(2)
      expect(returned_items.first["attributes"]["id"]).to eq(item.id)
      expect(returned_items.last["attributes"]["id"]).to eq(item_2.id)
    end
    it 'can find all items by unit_price' do
      item = create(:item, unit_price: 100)
      item_2 = create(:item, unit_price: 100)
      
      get "/api/v1/items/find_all?unit_price=#{item.unit_price}"
      
      expect(response).to be_successful
      
      returned_items = JSON.parse(response.body)["data"]
      expect(returned_items.count).to eq(2)
      expect(returned_items.first["attributes"]["id"]).to eq(item.id)
      expect(returned_items.last["attributes"]["id"]).to eq(item_2.id)
    end
    it 'can find all items by merchant_id' do
      merchant = create(:merchant)
      item = create(:item, merchant: merchant)
      item_2 = create(:item, merchant: merchant)
      
      get "/api/v1/items/find_all?merchant_id=#{item.merchant_id}"
      
      expect(response).to be_successful
      
      returned_items = JSON.parse(response.body)["data"]
      expect(returned_items.count).to eq(2)
      expect(returned_items.first["attributes"]["id"]).to eq(item.id)
      expect(returned_items.last["attributes"]["id"]).to eq(item_2.id)
    end
    it 'can find all items by created_at' do
      item = create(:item, created_at: "2012-03-27 14:53:59 UTC")
      item_2 = create(:item, created_at: "2012-03-27 14:53:59 UTC")
      
      get "/api/v1/items/find_all?created_at=#{item.created_at}"
      
      expect(response).to be_successful
      
      returned_items = JSON.parse(response.body)["data"]
      expect(returned_items.count).to eq(2)
      expect(returned_items.first["attributes"]["id"]).to eq(item.id)
      expect(returned_items.last["attributes"]["id"]).to eq(item_2.id)
    end
    it 'can find all items by updated_at' do
      item = create(:item, updated_at: "2012-03-27 14:53:59 UTC")
      item_2 = create(:item, updated_at: "2012-03-27 14:53:59 UTC")
      
      get "/api/v1/items/find_all?updated_at=#{item.updated_at}"
      
      expect(response).to be_successful
      
      returned_items = JSON.parse(response.body)["data"]
      expect(returned_items.count).to eq(2)
      expect(returned_items.first["attributes"]["id"]).to eq(item.id)
      expect(returned_items.last["attributes"]["id"]).to eq(item_2.id)
    end
  end
  
  describe 'For a single item' do
    before(:each) do
      @item = create(:item, created_at: "2012-03-27 14:53:59 UTC", updated_at: "2012-03-27 14:53:59 UTC")
    end
    it 'can return a single item' do
      get "/api/v1/items/#{@item.id}"
    end
    it 'can find a single item by its id' do
      get "/api/v1/items/find?id=#{@item.id}"
    end
    it 'can find a single item by its name' do
      get "/api/v1/items/find?name=#{@item.name}"
    end
    it 'can find a single item by its description' do
      get "/api/v1/items/find?description=#{@item.description}"
    end
    it 'can find a single item by its unit_price' do
      get "/api/v1/items/find?unit_price=#{@item.unit_price}"
    end
    it 'can find a single item by its merchant_id' do
      get "/api/v1/items/find?merchant_id=#{@item.merchant_id}"
    end
    it 'can find a single item by its created_at' do
      get "/api/v1/items/find?created_at=#{@item.created_at}"
    end
    it 'can find a single item by its updated_at' do
      get "/api/v1/items/find?updated_at=#{@item.updated_at}"
    end
    after(:each) do
      expect(response).to be_successful
      returned_item = JSON.parse(response.body)
      expect(returned_item.count).to eq(1)
      expect(returned_item["data"]["attributes"]["id"]).to eq(@item.id)
    end
  end
end