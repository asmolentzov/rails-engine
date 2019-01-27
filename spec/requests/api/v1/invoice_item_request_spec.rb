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
  end
  
  describe 'for a single invoice item' do
    before(:each) do
      @invoice_item = create(:invoice_item)
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
      returned_invoice_item = JSON.parse(response.body)
      expect(returned_invoice_item["data"]["id"]).to eq(@invoice_item.id.to_s)
    end
  end
end