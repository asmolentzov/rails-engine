require 'rails_helper'

describe 'Invoice Items API' do
  describe 'for a collection of invoice items' do
    before(:each) do
      create_list(:invoice_item, 3)
    end
    
    it 'can return all the invoice items' do
      get '/api/v1/invoice_items' 
      
      expect(response).to be_successful
      
      returned_invoice_items = JSON.parse(response.body)["data"]
      expect(returned_invoice_items.count).to eq(3)
      expect(returned_invoice_items.first["type"]).to eq("invoice_item")
    end
    
    it 'can find all invoice items by id' do
      ii = create(:invoice_item)
      
      get "/api/v1/invoice_items/find_all?id=#{ii.id}"
      
      expect(response).to be_successful
      returned_invoice_items = JSON.parse(response.body)["data"]
      expect(returned_invoice_items.count).to eq(1)
      expect(returned_invoice_items.first["type"]).to eq("invoice_item")
      expect(returned_invoice_items.first["attributes"]["id"]).to eq(ii.id)
    end
    
    it 'can find all invoice items by item_id' do
      item = create(:item)
      ii = create(:invoice_item, item: item)
      ii_2 = create(:invoice_item, item: item)
      
      get "/api/v1/invoice_items/find_all?item_id=#{ii.item_id}"
      
      expect(response).to be_successful
      returned_invoice_items = JSON.parse(response.body)["data"]
      expect(returned_invoice_items.count).to eq(2)
      expect(returned_invoice_items.first["attributes"]["id"]).to eq(ii.id)
      expect(returned_invoice_items.last["attributes"]["id"]).to eq(ii_2.id)
    end
    
    it 'can find all invoice items by invoice_id' do
      invoice = create(:invoice)
      ii = create(:invoice_item, invoice: invoice)
      ii_2 = create(:invoice_item, invoice: invoice)
      
      get "/api/v1/invoice_items/find_all?invoice_id=#{ii.invoice_id}"
      
      expect(response).to be_successful
      returned_invoice_items = JSON.parse(response.body)["data"]
      expect(returned_invoice_items.count).to eq(2)
      expect(returned_invoice_items.first["attributes"]["id"]).to eq(ii.id)
      expect(returned_invoice_items.last["attributes"]["id"]).to eq(ii_2.id)
    end
    
    it 'can find all invoice items by quantity' do
      ii = create(:invoice_item, quantity: 100)
      ii_2 = create(:invoice_item, quantity: 100)
      
      get "/api/v1/invoice_items/find_all?quantity=#{ii.quantity}"
      
      expect(response).to be_successful
      returned_invoice_items = JSON.parse(response.body)["data"]
      expect(returned_invoice_items.count).to eq(2)
      expect(returned_invoice_items.first["attributes"]["id"]).to eq(ii.id)
      expect(returned_invoice_items.last["attributes"]["id"]).to eq(ii_2.id)
    end
    
    it 'can find all invoice items by unit_price' do
      ii = create(:invoice_item, unit_price: 1000)
      ii_2 = create(:invoice_item, unit_price: 1000)
      
      get "/api/v1/invoice_items/find_all?unit_price=#{ii.unit_price}"
      
      expect(response).to be_successful
      returned_invoice_items = JSON.parse(response.body)["data"]
      expect(returned_invoice_items.count).to eq(2)
      expect(returned_invoice_items.first["attributes"]["id"]).to eq(ii.id)
      expect(returned_invoice_items.last["attributes"]["id"]).to eq(ii_2.id)
    end
    
    it 'can find all invoice items by created_at' do
      ii = create(:invoice_item, created_at: "2012-03-27 14:54:09 UTC")
      ii_2 = create(:invoice_item, created_at: "2012-03-27 14:54:09 UTC")
      
      get "/api/v1/invoice_items/find_all?created_at=#{ii.created_at}"
      
      expect(response).to be_successful
      returned_invoice_items = JSON.parse(response.body)["data"]
      expect(returned_invoice_items.count).to eq(2)
      expect(returned_invoice_items.first["attributes"]["id"]).to eq(ii.id)
      expect(returned_invoice_items.last["attributes"]["id"]).to eq(ii_2.id)
    end
    
    it 'can find all invoice items by updated_at' do
      ii = create(:invoice_item, updated_at: "2012-03-27 14:54:09 UTC")
      ii_2 = create(:invoice_item, updated_at: "2012-03-27 14:54:09 UTC")
      
      get "/api/v1/invoice_items/find_all?updated_at=#{ii.updated_at}"
      
      expect(response).to be_successful
      returned_invoice_items = JSON.parse(response.body)["data"]
      expect(returned_invoice_items.count).to eq(2)
      expect(returned_invoice_items.first["attributes"]["id"]).to eq(ii.id)
      expect(returned_invoice_items.last["attributes"]["id"]).to eq(ii_2.id)
    end
  end
  
  describe 'for a single invoice item' do
    before(:each) do
      @invoice_item = create(:invoice_item, created_at: "2012-03-27 14:54:09 UTC", updated_at: "2012-03-27 14:54:09 UTC")
    end
    
    it 'can return a single invoice item' do
      get "/api/v1/invoice_items/#{@invoice_item.id}"
    end
    it 'can find an invoice item by id' do
      get "/api/v1/invoice_items/find?id=#{@invoice_item.id}"
    end
    it 'can find an invoice item by item_id' do
      get "/api/v1/invoice_items/find?item_id=#{@invoice_item.item_id}"
    end
    it 'can find an invoice item by invoice_id' do
      get "/api/v1/invoice_items/find?invoice_id=#{@invoice_item.invoice_id}"
    end
    it 'can find an invoice item by quantity' do
      get "/api/v1/invoice_items/find?quantity=#{@invoice_item.quantity}"
    end
    it 'can find an invoice item by unit_price' do
      get "/api/v1/invoice_items/find?unit_price=#{@invoice_item.unit_price}"
    end
    it 'can find an invoice item by created_at' do
      get "/api/v1/invoice_items/find?created_at=#{@invoice_item.created_at}"
    end
    it 'can find an invoice item by updated_at' do
      get "/api/v1/invoice_items/find?updated_at=#{@invoice_item.updated_at}"
    end
    
    after(:each) do
      expect(response).to be_successful
      returned_invoice_item = JSON.parse(response.body)["data"]
      expect(returned_invoice_item["attributes"]["id"]).to eq(@invoice_item.id)
    end
  end
end