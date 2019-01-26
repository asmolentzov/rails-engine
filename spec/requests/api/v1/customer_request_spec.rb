require 'rails_helper'

describe 'Customers API' do
  describe 'for a collection of customers' do
    before(:each) do
      @customer_list = create_list(:customer, 3)
    end
    it 'sends a list of customers' do
      get '/api/v1/customers'
      
      expect(response).to be_successful
      
      customers = JSON.parse(response.body)
      expect(customers["data"].count).to eq(3)
    end   
    
    it 'can find all customers by id' do
      customer = @customer_list.first
      get "/api/v1/customers/find_all?id=#{customer.id}"
      
      expect(response).to be_successful
      
      customers = JSON.parse(response.body)
      expect(customers["data"].count).to eq(1)
      expect(customers["data"].first["id"]).to eq(customer.id.to_s)
      expect(customers["data"].first["attributes"]["first_name"]).to eq(customer.first_name)
    end
    
    it 'can find all customers by first_name' do
      customer_1 = create(:customer)
      customer_2 = create(:customer, first_name: "Joe")
      customer_3 = create(:customer, first_name: "Joe")
      
      get "/api/v1/customers/find_all?first_name=#{customer_2.first_name}"
      customers = JSON.parse(response.body)
      
      expect(response).to be_successful
      expect(customers["data"].count).to eq(2)
      expect(customers["data"].first["id"]).to eq(customer_2.id.to_s)
      expect(customers["data"].last["id"]).to eq(customer_3.id.to_s)
      
      # Case insensitive
      get "/api/v1/customers/find_all?first_name=#{customer_2.first_name.upcase}"
      customers = JSON.parse(response.body)
      
      expect(response).to be_successful
      expect(customers["data"].count).to eq(2)
      expect(customers["data"].first["id"]).to eq(customer_2.id.to_s)
      expect(customers["data"].last["id"]).to eq(customer_3.id.to_s)
    end
    
    it 'can find all customers by last_name' do
      customer_1 = create(:customer)
      customer_2 = create(:customer, last_name: "Bob")
      customer_3 = create(:customer, last_name: "Bob")
      
      get "/api/v1/customers/find_all?last_name=#{customer_2.last_name}"
      customers = JSON.parse(response.body)
      
      expect(response).to be_successful
      expect(customers["data"].count).to eq(2)
      expect(customers["data"].first["id"]).to eq(customer_2.id.to_s)
      expect(customers["data"].last["id"]).to eq(customer_3.id.to_s)
      
      # Case insensitive
      get "/api/v1/customers/find_all?last_name=#{customer_2.last_name.upcase}"
      customers = JSON.parse(response.body)
      
      expect(response).to be_successful
      expect(customers["data"].count).to eq(2)
      expect(customers["data"].first["id"]).to eq(customer_2.id.to_s)
      expect(customers["data"].last["id"]).to eq(customer_3.id.to_s)
    end
    
    it 'can find all customers by created_at' do
      customer = create(:customer, created_at: "2012-03-27 14:54:09 UTC")
      create(:customer, created_at: "2012-03-27 14:54:09 UTC")
      
      get "/api/v1/customers/find_all?created_at=#{customer.created_at}"
      
      customers = JSON.parse(response.body)
      
      expect(response).to be_successful
      expect(customers["data"].count).to eq(2)
      expect(customers["data"].first["id"]).to eq(customer.id.to_s)
    end
    
    it 'can find all customers by updated_at' do
      customer = create(:customer, updated_at: "2012-03-27 14:54:12 UTC")
      create(:customer, updated_at: "2012-03-27 14:54:12 UTC")
      
      get "/api/v1/customers/find_all?updated_at=#{customer.updated_at}"
      
      customers = JSON.parse(response.body)
      
      expect(response).to be_successful
      expect(customers["data"].count).to eq(2)
      expect(customers["data"].first["id"]).to eq(customer.id.to_s)
    end
  end
  
  describe 'for a single customer' do
    before(:each) do
      @customer = create(:customer, created_at: "2012-03-27 14:54:09 UTC", updated_at: "2012-03-27 14:54:12 UTC")
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
    
    it 'can find a single customer based on case-insensitive first_name' do
      get "/api/v1/customers/find?first_name=#{@customer.first_name.upcase}"
    end
    
    it 'can find a single customer based on its last name' do
      get "/api/v1/customers/find?last_name=#{@customer.last_name}"
    end
    
    it 'can find a single customer based on case-insensitive last_name' do
      get "/api/v1/customers/find?last_name=#{@customer.last_name.upcase}"
    end
    
    it 'can find a single customer based on created_at' do
      get "/api/v1/customers/find?created_at=#{@customer.created_at}"
    end
    
    it 'can find a single customer based on updated_at' do
      get "/api/v1/customers/find?updated_at=#{@customer.updated_at}"
    end
    
    after(:each) do
      returned_customer = JSON.parse(response.body)
    
      expect(response).to be_successful
      expect(returned_customer["data"]["id"]).to eq(@customer.id.to_s)
      expect(returned_customer["data"]["type"]).to eq("customer")
      expect(returned_customer["data"]["attributes"]["first_name"]).to eq(@customer.first_name)
    end
  end
  
  it 'can find a random customer' do
    create_list(:customer, 3)
    
    get "/api/v1/customers/random"
    
    customer = JSON.parse(response.body)
    expect(response).to be_successful
    expect(customer.count).to eq(1)
    expect(customer["data"]["type"]).to eq("customer")
  end
end