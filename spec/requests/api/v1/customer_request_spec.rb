require 'rails_helper'

describe 'Customers API' do
  it 'sends a list of customers' do
    create_list(:customer, 3)
    
    get '/api/v1/customers'
    
    expect(response).to be_successful
    
    customers = JSON.parse(response.body)
    expect(customers["data"].count).to eq(3)
  end
  
  describe 'for a single customer' do
    before(:each) do
      @customer = create(:customer)
    end
    
    it 'can get a single customer by its id' do
      get "/api/v1/customers/#{@customer.id}"
    end
    
    it 'can find a single customer based on its id' do
      get "/api/v1/customers/find?id=#{@customer.id}"
    end
    
    it 'can find a single customer based on its first name' do
      get "/api/v1/customers/find?first_name=#{@customer.first_name}"
    end
    
    it 'can find a single customer based on its last name' do
      get "/api/v1/customers/find?last_name=#{@customer.last_name}"
    end
    
    # it 'can find a single customer based on created_at' do
    #   get "/api/v1/customers/find?created_at=#{@customer.created_at}"
    # end
    # 
    # it 'can find a single customer based on updated_at' do
    #   get "/api/v1/customers/find?updated_at=#{@customer.updated_at}"
    # end
    
    after(:each) do
      returned_customer = JSON.parse(response.body)
    
      expect(response).to be_successful
      expect(returned_customer["data"]["id"]).to eq(@customer.id.to_s)
      expect(returned_customer["data"]["type"]).to eq("customer")
      expect(returned_customer["data"]["attributes"]["first_name"]).to eq(@customer.first_name)
    end
  end
  
end