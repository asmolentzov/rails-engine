require 'rails_helper'

describe 'Merchants API' do
  describe 'for a collection of merchants' do
    before(:each) do
      @merchants = create_list(:merchant, 3)
    end
    it 'can find all merchants' do
      get '/api/v1/merchants' 
      
      returned_merchants = JSON.parse(response.body)
      expect(response).to be_successful
      expect(returned_merchants["data"].count).to eq(3)
    end
  end
  
  describe 'for a single merchant' do
    before(:each) do
      @merchant = create(:merchant, name: "Merchant1", created_at: '2012-03-27 14:53:59 UTC', updated_at: '2012-03-28 14:53:59 UTC')
      create(:merchant)
    end
    it 'can return a single merchant' do
      get "/api/v1/merchants/#{@merchant.id}"
    end
    it 'can find a single merchant by id' do
      get "/api/v1/merchants/find?id=#{@merchant.id}"
    end
    it 'can find a single merchant by name' do
      get "/api/v1/merchants/find?name=#{@merchant.name}"
    end
    it 'can find a single merchant by created_at' do
      get "/api/v1/merchants/find?created_at#{merchant.created_at}"
    end
    it 'can find a single merchant by updated_at' do
      get "/api/v1/merchants/find?updated_at#{merchant.updated_at}"
    end
    after(:each) do
      returned_merchant = JSON.parse(response.body)
      expect(response).to be_successful
      expect(returned_merchant["data"]["id"]).to eq(@merchant.id.to_s)
      expect(returned_merchant["data"]["attributes"]["name"]).to eq(@merchant.name)
    end
  end
end