require 'rails_helper'

describe 'Item Business Intelligence API' do
  it 'returns the top x items by total revenue generated' do
    item_1 = create(:item)
    item_2 = create(:item)
    item_3 = create(:item)
    item_4 = create(:item)
    item_5 = create(:item)
    
    invoice_1 = create(:invoice)
    ii_1 = create(:invoice_item, invoice: invoice_1, item: item_1, quantity: 1, unit_price: 1)
    
    invoice_2 = create(:invoice)
    ii_2 = create(:invoice_item, invoice: invoice_2, item: item_2, quantity: 5, unit_price: 10)
    
    invoice_3 = create(:invoice)
    ii_3 = create(:invoice_item, invoice: invoice_3, item: item_3, quantity: 2, unit_price: 10)
    invoice_4 = create(:invoice)
    ii_4 = create(:invoice_item, invoice: invoice_4, item: item_3, quantity: 2, unit_price: 10)
    invoice_5 = create(:invoice)
    ii_5 = create(:invoice_item, invoice: invoice_5, item: item_3, quantity: 2, unit_price: 10)
    
    invoice_6 = create(:invoice)
    ii_6 = create(:invoice_item, invoice: invoice_6, item: item_4, quantity: 200, unit_price: 1000)
    
    invoice_7 = create(:invoice)
    ii_7 = create(:invoice_item, invoice: invoice_7, item: item_5, quantity: 2, unit_price: 1000)
    
    create(:transaction, invoice: invoice_1, result: 'success')
    create(:transaction, invoice: invoice_2, result: 'success')
    create(:transaction, invoice: invoice_3, result: 'success')
    create(:transaction, invoice: invoice_4, result: 'success')
    create(:transaction, invoice: invoice_5, result: 'success')
    create(:transaction, invoice: invoice_6, result: 'failed')
    create(:transaction, invoice: invoice_7, result: 'success')
    
    get '/api/v1/items/most_revenue?quantity=2'
    
    expect(response).to be_successful
    
    returned_items = JSON.parse(response.body)["data"]
    
    expect(returned_items.count).to eq(2)
    expect(returned_items.first["attributes"]["id"]).to eq(Item.top_items_by_revenue(2).first.id)
  end
  
  it 'returns the top x items by total number sold' do
    item_1 = create(:item)
    item_2 = create(:item)
    item_3 = create(:item)
    item_4 = create(:item)
    item_5 = create(:item)
    
    invoice_1 = create(:invoice)
    ii_1 = create(:invoice_item, invoice: invoice_1, item: item_1, quantity: 1, unit_price: 1)
    
    invoice_2 = create(:invoice)
    ii_2 = create(:invoice_item, invoice: invoice_2, item: item_2, quantity: 5, unit_price: 10)
    
    invoice_3 = create(:invoice)
    ii_3 = create(:invoice_item, invoice: invoice_3, item: item_3, quantity: 2, unit_price: 10)
    invoice_4 = create(:invoice)
    ii_4 = create(:invoice_item, invoice: invoice_4, item: item_3, quantity: 2, unit_price: 10)
    invoice_5 = create(:invoice)
    ii_5 = create(:invoice_item, invoice: invoice_5, item: item_3, quantity: 2, unit_price: 10000)
    
    invoice_6 = create(:invoice)
    ii_6 = create(:invoice_item, invoice: invoice_6, item: item_4, quantity: 200, unit_price: 1000)
    
    invoice_7 = create(:invoice)
    ii_7 = create(:invoice_item, invoice: invoice_7, item: item_5, quantity: 1000, unit_price: 10)
    
    create(:transaction, invoice: invoice_1, result: 'success')
    create(:transaction, invoice: invoice_2, result: 'success')
    create(:transaction, invoice: invoice_3, result: 'success')
    create(:transaction, invoice: invoice_4, result: 'success')
    create(:transaction, invoice: invoice_5, result: 'success')
    create(:transaction, invoice: invoice_6, result: 'failed')
    create(:transaction, invoice: invoice_7, result: 'success')
    
    get '/api/v1/items/most_items?quantity=2'
    
    expect(response).to be_successful
    
    returned_items = JSON.parse(response.body)["data"]
    
    expect(returned_items.count).to eq(2)
    expect(returned_items.first["attributes"]["id"]).to eq(Item.top_items_by_number_sold(2).first.id)
  end
  
  it 'returns the date with the mmost sales for a given item' do
    item = create(:item)
    
    invoice_1 = create(:invoice, created_at: "2012-03-12 03:54:10 UTC")
    create(:invoice_item, item: item, invoice: invoice_1, unit_price: 5, quantity: 1)
    create(:transaction, invoice: invoice_1, result: 'success')
    
    invoice_2 = create(:invoice, created_at: "2012-03-17 03:54:10 UTC")
    create(:invoice_item, item: item, invoice: invoice_2, unit_price: 5, quantity: 10)
    create(:transaction, invoice: invoice_2, result: 'success')
    
    invoice_3 = create(:invoice, created_at: "2012-03-17 03:44:10 UTC")
    create(:invoice_item, item: item, invoice: invoice_3, unit_price: 5, quantity: 100)
    create(:transaction, invoice: invoice_3, result: 'success')
    
    invoice_4 = create(:invoice, created_at: "2012-03-15 03:54:10 UTC")
    create(:invoice_item, item: item, invoice: invoice_4, unit_price: 50, quantity: 100)
    create(:transaction, invoice: invoice_4, result: "failed")
    
    invoice_5 = create(:invoice, created_at: "2012-03-14 03:54:10 UTC")
    create(:invoice_item, item: item, invoice: invoice_5, unit_price: 5, quantity: 100)
    create(:transaction, invoice: invoice_5, result: 'success')
    
    get "/api/v1/items/#{item.id}/best_day"
    
    expect(response).to be_successful
    date = JSON.parse(response.body)["data"]
    expect(date["attributes"]["best_day"]).to eq("2012-03-17T03:54:10.000Z")
    
    invoice_6 = create(:invoice, created_at: "2012-03-13 03:54:10 UTC")
    create(:invoice_item, item: item, invoice: invoice_6, unit_price: 1, quantity: 550)
    create(:transaction, invoice: invoice_6, result: 'success')
    
    get "/api/v1/items/#{item.id}/best_day"
    
    expect(response).to be_successful
    date = JSON.parse(response.body)["data"]
    expect(date["attributes"]["best_day"]).to eq("2012-03-17T03:54:10.000Z")
  end
end