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
      expect(returned_invoices["attributes"]["id"]).to eq(invoice.id)
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
end