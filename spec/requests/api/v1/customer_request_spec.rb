require 'rails_helper'

describe 'Customers API' do
  it 'sends a list of customers' do
    create_list(:customer, 3)
    
    get '/api/v1/customers'
    
    expect(response).to be_successful
    
    customers = JSON.parse(response.body)
    expect(customers.count).to eq(3)
  end
  
  it 'can get a single customer by its id' do
    customer = create(:customer)
    
    get "/api/v1/customers/#{customer.id}"
    
    returned_customer = JSON.parse(response.body)
    
    expect(response).to be_successful
    expect(returned_customer["id"]).to eq(customer.id)
  end
  
  it 'can find a single customer based on its id' do
    customer = create(:customer)
    
    get "/api/v1/customers/find?#{customer.id}"
    
    returned_customer = JSON.parse(response.body)
    
    expect(response).to be_successful
    expect(returned_customer["id"]).to eq(customer.id)
  end
end