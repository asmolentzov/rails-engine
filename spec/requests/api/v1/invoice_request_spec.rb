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
    it 'can return a specific invoice' do
      invoice = create(:invoice)
      
      get "/api/v1/invoices/#{invoice.id}"
      
      expect(response).to be_successful
      
      returned_invoice = JSON.parse(response.body)["data"]
      expect(returned_invoice["attributes"]["id"]).to eq(invoice.id.to_s)
    end
  end
end