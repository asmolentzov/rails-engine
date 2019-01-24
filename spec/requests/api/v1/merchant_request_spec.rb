
describe 'Merchants API' do
  it 'sends a list of merchants' do
    create_list(:merchant, 3)
    
    get '/api/v1/merchants'
    
    expect(response).to be_successful
    
    merchants = JSON.parse(response.body)
    expect(merchants.count).to eq(3)
  end   
  
  it 'returns the total revenue for a specified merchant across successful transactions' do
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
    expect(total["data"]["attributes"]["revenue"]).to eq(merchant.total_revenue / 100.0)
  end
  
  it 'returns the top x merchants ranked by revenue' do
    merchant_1 = create(:merchant)
    item_m1_1 = create(:item, merchant: merchant_1)
    invoice_m1_1 = create(:invoice, merchant: merchant_1)
    invoice_item = create(:invoice_item, invoice: invoice_m1_1, item: item_m1_1, unit_price: 1, quantity: 1)
    create(:transaction, invoice: invoice_m1_1, result: "success")
    
    merchant_2 = create(:merchant)
    item_m2_2 = create(:item, merchant: merchant_2)
    invoice_m2_2 = create(:invoice, merchant: merchant_2)
    invoice_item = create(:invoice_item, invoice: invoice_m2_2, item: item_m2_2, unit_price: 15, quantity: 2)
    create(:transaction, invoice: invoice_m2_2, result: "success")
    
    merchant_3 = create(:merchant)
    item_m3_3 = create(:item, merchant: merchant_3)
    invoice_m3_3 = create(:invoice, merchant: merchant_3)
    invoice_item = create(:invoice_item, invoice: invoice_m3_3, item: item_m3_3, unit_price: 100, quantity: 3)
    create(:transaction, invoice: invoice_m3_3, result: "failed")
    
    merchant_4 = create(:merchant)
    item_m4_4 = create(:item, merchant: merchant_4)
    invoice_m4_4 = create(:invoice, merchant: merchant_4)
    invoice_item = create(:invoice_item, invoice: invoice_m4_4, item: item_m4_4, unit_price: 4, quantity: 10)
    create(:transaction, invoice: invoice_m4_4, result: "success")
    
    merchant_5 = create(:merchant)
    item_m5_5 = create(:item, merchant: merchant_5)
    invoice_m5_5 = create(:invoice, merchant: merchant_5)
    invoice_item = create(:invoice_item, invoice: invoice_m5_5, item: item_m5_5, unit_price: 5, quantity: 5)
    create(:transaction, invoice: invoice_m5_5, result: "success")
    
    get "/api/v1/merchants/most_revenue?quantity=2"
    
    merchants = Merchant.merchants_by_revenue(2)
    returned_merchants = JSON.parse(response.body)
    expect(response).to be_successful
    expect(returned_merchants["data"].count).to eq(2)
    expect(returned_merchants["data"].first["id"]).to eq(merchants.first.id.to_s)
    expect(returned_merchants["data"].last["id"]).to eq(merchants.last.id.to_s)
    
    get "/api/v1/merchants/most_revenue?quantity=3"
    
    merchants = Merchant.merchants_by_revenue(3)
    returned_merchants = JSON.parse(response.body)
    expect(response).to be_successful
    expect(returned_merchants["data"].count).to eq(3)
    expect(returned_merchants["data"].first["id"]).to eq(merchants.first.id.to_s)
    expect(returned_merchants["data"].second["id"]).to eq(merchants.second.id.to_s)
    expect(returned_merchants["data"].last["id"]).to eq(merchants.last.id.to_s)
  end
  
  it 'returns the top x merchants ranked by total number of items sold' do
    merchant_1 = create(:merchant)
    item_m1_1 = create(:item, merchant: merchant_1)
    invoice_m1_1 = create(:invoice, merchant: merchant_1)
    invoice_item = create(:invoice_item, invoice: invoice_m1_1, item: item_m1_1, unit_price: 1, quantity: 1)
    create(:transaction, invoice: invoice_m1_1, result: "success")
    
    merchant_2 = create(:merchant)
    item_m2_1 = create(:item, merchant: merchant_2)
    item_m2_2 = create(:item, merchant: merchant_2)
    item_m2_3 = create(:item, merchant: merchant_2)
    invoice_m2_1 = create(:invoice, merchant: merchant_2)
    invoice_item = create(:invoice_item, invoice: invoice_m2_1, item: item_m2_1, unit_price: 15, quantity: 2)
    invoice_item = create(:invoice_item, invoice: invoice_m2_1, item: item_m2_2, unit_price: 1, quantity: 1)
    invoice_item = create(:invoice_item, invoice: invoice_m2_1, item: item_m2_3, unit_price: 1, quantity: 10)
    create(:transaction, invoice: invoice_m2_1, result: "success")
    
    merchant_3 = create(:merchant)
    item_m3_1 = create(:item, merchant: merchant_3)
    item_m3_2 = create(:item, merchant: merchant_3)
    item_m3_3 = create(:item, merchant: merchant_3)
    invoice_m3_1 = create(:invoice, merchant: merchant_3)
    invoice_item = create(:invoice_item, invoice: invoice_m3_1, item: item_m3_1, unit_price: 15, quantity: 2)
    invoice_item = create(:invoice_item, invoice: invoice_m3_1, item: item_m3_2, unit_price: 1, quantity: 5)
    create(:transaction, invoice: invoice_m3_1, result: "success")
    
    merchant_4 = create(:merchant)
    item_m4_1 = create(:item, merchant: merchant_4)
    item_m4_2 = create(:item, merchant: merchant_4)
    item_m4_3 = create(:item, merchant: merchant_4)
    invoice_m4_1 = create(:invoice, merchant: merchant_4)
    invoice_m4_2 = create(:invoice, merchant: merchant_4)
    create(:invoice_item, invoice: invoice_m4_1, item: item_m4_1, unit_price: 15, quantity: 2)
    create(:invoice_item, invoice: invoice_m4_1, item: item_m4_2, unit_price: 1, quantity: 1)
    create(:invoice_item, invoice: invoice_m4_1, item: item_m4_3, unit_price: 1, quantity: 10)
    create(:invoice_item, invoice: invoice_m4_2, item: item_m4_1, unit_price: 1, quantity: 100)
    create(:transaction, invoice: invoice_m4_1, result: "failed")
    create(:transaction, invoice: invoice_m4_2, result: "failed")
    
    get "/api/v1/merchants/most_items?quantity=2"
    
    expect(response).to be_successful
    
    merchants = Merchant.merchants_by_items(2)
    returned_merchants = JSON.parse(response.body)
    expect(returned_merchants["data"].count).to eq(2)
    expect(returned_merchants["data"].first["id"]).to eq(merchants.first.id.to_s)
    expect(returned_merchants["data"].last["id"]).to eq(merchants.last.id.to_s)
  end
end