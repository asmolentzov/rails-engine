require 'rails_helper' 

describe 'Invoice API' do
  describe 'for a collection of invoices' do
    before(:each) do
      create_list(:invoice, 3)
    end
    it 'can return all the invoices' do
      get '/api/v1/invoices' 
      
      expect(response).to be_successful
      
      returned_invoices = JSON.parse(response.body)["data"]
      expect(returned_invoices.count).to eq(3)
      expect(returned_invoices.first["type"]).to eq("invoice")
    end
    
    it 'can find all invoices by id' do
      invoice = create(:invoice)
      
      get "/api/v1/invoices/find_all?id=#{invoice.id}"
      
      expect(response).to be_successful
      
      returned_invoices = JSON.parse(response.body)["data"]
      expect(returned_invoices.count).to eq(1)
      expect(returned_invoices.first["attributes"]["id"]).to eq(invoice.id)
    end
    
    it 'can find all invoices by customer_id' do
      customer = create(:customer)
      invoice = create(:invoice, customer: customer)
      invoice_2 = create(:invoice, customer: customer)
      
      get "/api/v1/invoices/find_all?customer_id=#{customer.id}"
      
      expect(response).to be_successful
      
      returned_invoices = JSON.parse(response.body)["data"]
      expect(returned_invoices.count).to eq(2)
      expect(returned_invoices.first["attributes"]["id"]).to eq(invoice.id)
      expect(returned_invoices.last["attributes"]["id"]).to eq(invoice_2.id)
    end
    
    it 'can find all invoices by merchant_id' do
      merchant = create(:merchant)
      invoice = create(:invoice, merchant: merchant)
      invoice_2 = create(:invoice, merchant: merchant)
      
      get "/api/v1/invoices/find_all?merchant_id=#{merchant.id}"
      
      expect(response).to be_successful
      
      returned_invoices = JSON.parse(response.body)["data"]
      expect(returned_invoices.count).to eq(2)
      expect(returned_invoices.first["attributes"]["id"]).to eq(invoice.id)
      expect(returned_invoices.last["attributes"]["id"]).to eq(invoice_2.id)
    end
    
    it 'can find all invoices by status' do
      invoice = create(:invoice, status: 'success')
      invoice_2 = create(:invoice, status: 'success')
      
      get "/api/v1/invoices/find_all?status=#{invoice.status}"
      
      expect(response).to be_successful
      
      returned_invoices = JSON.parse(response.body)["data"]
      expect(returned_invoices.count).to eq(2)
      expect(returned_invoices.first["attributes"]["id"]).to eq(invoice.id)
      expect(returned_invoices.last["attributes"]["id"]).to eq(invoice_2.id)
    end
    
    it 'can find all invoices by status case insensitive' do
      invoice = create(:invoice, status: 'success')
      invoice_2 = create(:invoice, status: 'success')
      
      get "/api/v1/invoices/find_all?status=#{invoice.status.upcase}"
      
      expect(response).to be_successful
      
      returned_invoices = JSON.parse(response.body)["data"]
      expect(returned_invoices.count).to eq(2)
      expect(returned_invoices.first["attributes"]["id"]).to eq(invoice.id)
      expect(returned_invoices.last["attributes"]["id"]).to eq(invoice_2.id)
    end
  end
  
  describe 'for a single invoice' do
    before(:each) do
      @invoice = create(:invoice)
    end
    
    it 'can return a specific invoice' do
      get "/api/v1/invoices/#{@invoice.id}"
    end
    it 'can find an invoice by id' do
      get "/api/v1/invoices/find?id=#{@invoice.id}"
    end
    it 'can find an invoice by customer id' do
      get "/api/v1/invoices/find?customer_id=#{@invoice.customer_id}"
    end
    it 'can find an invoice by merchant id' do
      get "/api/v1/invoices/find?merchant_id=#{@invoice.merchant_id}"
    end
    it 'can find an invoice by status' do
      get "/api/v1/invoices/find?status=#{@invoice.status}"
    end
    it 'can find an invoice by status case insensitive' do
      get "/api/v1/invoices/find?status=#{@invoice.status.upcase}"
    end
    
    after(:each) do
      expect(response).to be_successful
      
      returned_invoice = JSON.parse(response.body)["data"]
      expect(returned_invoice["attributes"]["id"]).to eq(@invoice.id)
    end
  end
  
  it 'can return a random invoice' do
    create_list(:invoice, 3)
    
    get '/api/v1/invoices/random' 
    
    expect(response).to be_successful
    
    returned_invoice = JSON.parse(response.body)
    expect(returned_invoice.count).to eq(1)
    expect(returned_invoice["data"]["type"]).to eq("invoice")
  end
  
  describe 'Relationship Endpoints' do
    it 'returns all the transactions associated with an invoice' do
      invoice = create(:invoice)
      transaction = create(:transaction, invoice: invoice)
      transaction_2 = create(:transaction, invoice: invoice)
      
      get "/api/v1/invoices/#{invoice.id}/transactions"
      
      expect(response).to be_successful
      
      returned_transactions = JSON.parse(response.body)["data"]
      expect(returned_transactions.count).to eq(2)
      expect(returned_transactions.first["id"]).to eq(transaction.id.to_s)
      expect(returned_transactions.last["id"]).to eq(transaction_2.id.to_s)
    end
    
    it 'returns all the invoice items associated with an invoice' do
      invoice = create(:invoice)
      
      ii_1 = create(:invoice_item, invoice: invoice)
      ii_2 = create(:invoice_item, invoice: invoice)
      
      get "/api/v1/invoices/#{invoice.id}/invoice_items"
      
      expect(response).to be_successful
      
      returned_invoice_items = JSON.parse(response.body)["data"]
      expect(returned_invoice_items.count).to eq(2)
      expect(returned_invoice_items.first["id"]).to eq(ii_1.id.to_s)
      expect(returned_invoice_items.last["id"]).to eq(ii_2.id.to_s)
    end
    
    it 'returns all the items associated with an invoice' do
      invoice = create(:invoice)
      item_1 = create(:item)
      item_2 = create(:item)
      
      ii_1 = create(:invoice_item, invoice: invoice, item: item_1)
      ii_2 = create(:invoice_item, invoice: invoice, item: item_2)
      
      get "/api/v1/invoices/#{invoice.id}/items"
      
      expect(response).to be_successful
      
      returned_items = JSON.parse(response.body)["data"]
      expect(returned_items.count).to eq(2)
      expect(returned_items.first["id"]).to eq(item_1.id.to_s)
      expect(returned_items.last["id"]).to eq(item_2.id.to_s)
    end
    
    it 'returns the customer associated with an invoice' do
      customer = create(:customer)
      invoice = create(:invoice, customer: customer)
      
      get "/api/v1/invoices/#{invoice.id}/customer"
      
      expect(response).to be_successful
      returned_customer = JSON.parse(response.body)
      expect(returned_customer.count).to eq(1)
      expect(returned_customer["data"]["id"]).to eq(customer.id.to_s)
    end
    
    it 'returns the merchant associated with an invoice' do
      merchant = create(:merchant)
      invoice = create(:invoice, merchant: merchant)
      
      get "/api/v1/invoices/#{invoice.id}/merchant"
      
      expect(response).to be_successful
      returned_merchant = JSON.parse(response.body)
      expect(returned_merchant.count).to eq(1)
      expect(returned_merchant["data"]["id"]).to eq(merchant.id.to_s)
    end
  end
end