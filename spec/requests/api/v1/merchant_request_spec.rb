
describe 'Merchants API' do
  it 'sends a list of merchants' do
    create_list(:merchant, 3)
    
    get '/api/v1/merchants'
    
    expect(response).to be_successful
    
    merchants = JSON.parse(response.body)
    expect(merchants.count).to eq(3)
  end   
  
  it ' returns the total revenue for a specified merchant across successful transactions' do
    merchant = create(:merchant)
    item = create(:item, merchant: merchant, unit_price: 10)
    invoice = create(:invoice, merchant: merchant)
    ii = create(:invoice_item, item: item, invoice: invoice, unit_price: 10, quantity: 2)
    transaction = create(:transaction, invoice: invoice, result: "success")
    transaction_2 = create(:transaction, invoice: invoice, result: "fail")
    
    
    get "/api/v1/merchants/#{merchant.id}/revenue"
    
    expect(response).to be_successful
    total = JSON.parse(response.body)
    # More Testing Here!
    
  end
end