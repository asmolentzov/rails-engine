require 'rails_helper'

describe 'Transaction API' do
  describe 'for a collection of transactions' do
    before(:each) do
      create_list(:transaction, 3)
    end
    
    it 'can return all transactions' do
      get '/api/v1/transactions'
      
      expect(response).to be_successful
      
      returned_transactions = JSON.parse(response.body)["data"]
      expect(returned_transactions.count).to eq(3)
      expect(returned_transactions.first["attributes"]["type"]).to eq("transaction")
    end
  end
  
  describe 'for a single transaction' do
    before(:each) do
      @transaction = create(:transaction, created_at: "2012-03-27 14:54:10 UTC", updated_at: "2012-03-27 14:54:10 UTC")
    end
    it 'can return a single transaction' do
      get "/api/v1/transactions/#{@transaction.id}"
    end
    
    after(:each) do
      expect(response).to be_successful
      
      returned_transaction = JSON.parse(response.body)
      expect(returned_transaction.count).to eq(1)
      expect(returned_transaction["attributes"]["id"]).to eq(@transaction.id)
    end
  end
end