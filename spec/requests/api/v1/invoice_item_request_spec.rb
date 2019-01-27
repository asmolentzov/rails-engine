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
    
    after(:each) do
      expect(response).to be_successful
      returned_invoice_item = JSON.parse(response.body)
      expect(returned_invoice_item["data"]["id"]).to eq(@invoice_item.id.to_s)
    end
  end
end