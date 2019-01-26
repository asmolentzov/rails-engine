require 'rails_helper' 

describe 'Invoice API' do
  describe 'for a collection of invoices' do
    it 'can return all the invoices' do
      create_list(:invoice, 3)
      
      get '/api/v1/invoices' 
      
      expect(response).to be_successful
      
      returned_invoices = JSON.parse(response.body)["data"]
      expect(returned_invoices.count).to eq(3)
      expect(returned_invoices.first["type"]).to eq("invoice")
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