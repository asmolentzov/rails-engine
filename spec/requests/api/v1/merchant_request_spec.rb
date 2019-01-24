
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
    item = create(:item, merchant: merchant)
    invoice = create(:invoice, merchant: merchant)
    invoice_2 = create(:invoice, merchant: merchant)
    
    create(:invoice_item, item: item, invoice: invoice, unit_price: 10, quantity: 2)
    create(:invoice_item, item: item, invoice: invoice_2, unit_price: 2, quantity: 5)
    
    create(:transaction, invoice: invoice, result: "success")
    create(:transaction, invoice: invoice_2, result: "success")
    
    get "/api/v1/merchants/#{merchant.id}/revenue"
    
    expect(response).to be_successful
    total = JSON.parse(response.body)
    expect(total["data"]["attributes"]["revenue"]).to eq(merchant.total_revenue)
  end
end