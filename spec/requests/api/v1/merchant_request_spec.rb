
describe 'Merchants API' do
  describe 'for a collection of merchants' do
    before(:each) do
      @merchants = create_list(:merchant, 3)
    end
    it 'can find all merchants' do
      get '/api/v1/merchants' 
      
      returned_merchants = JSON.parse(response.body)
      expect(response).to be_successful
      expect(returned_merchants["data"].count).to eq(3)
    end
    
    it 'can find all merchants by id' do
      get "/api/v1/merchants/find_all?id=#{@merchants.first.id}"
      
      returned_merchants = JSON.parse(response.body)
      expect(response).to be_successful
      expect(returned_merchants["data"].count).to eq(1)
      expect(returned_merchants["data"].first["attributes"]["id"]).to eq(@merchants.first.id)
    end
    
    it 'can find all merchants by name' do
      merchant = create(:merchant, name: "Bob")
      create(:merchant, name: "Bob")
      
      get "/api/v1/merchants/find_all?name=#{merchant.name}"
      
      returned_merchants = JSON.parse(response.body)["data"]
      expect(response).to be_successful
      expect(returned_merchants.count).to eq(2)
      expect(returned_merchants.first["attributes"]["name"]).to eq(merchant.name)
      expect(returned_merchants.last["attributes"]["name"]).to eq(merchant.name)
      
      get "/api/v1/merchants/find_all?name=#{merchant.name.upcase}"
      
      returned_merchants = JSON.parse(response.body)["data"]
      expect(response).to be_successful
      expect(returned_merchants.count).to eq(2)
      expect(returned_merchants.first["attributes"]["name"]).to eq(merchant.name)
      expect(returned_merchants.last["attributes"]["name"]).to eq(merchant.name)
    end
    
    it 'can find all merchants by created_at date' do
      merchant = create(:merchant, created_at: '2012-03-28 14:53:59 UTC')
      create(:merchant, created_at: '2012-03-28 14:53:59 UTC')
      create(:merchant, created_at: '2012-03-28 14:53:59 UTC')
      
      get "/api/v1/merchants/find_all?created_at=#{merchant.created_at}"
      
      returned_merchants = JSON.parse(response.body)["data"]
      expect(response).to be_successful
      expect(returned_merchants.count).to eq(3)
      expect(returned_merchants.first["attributes"]["id"]).to eq(merchant.id)
    end
    
    it 'can find all merchants by updated_at date' do
      merchant = create(:merchant, updated_at: '2012-03-28 14:53:59 UTC')
      create(:merchant, updated_at: '2012-03-28 14:53:59 UTC')
      create(:merchant, updated_at: '2012-03-28 14:53:59 UTC')
      
      get "/api/v1/merchants/find_all?updated_at=#{merchant.updated_at}"
      
      returned_merchants = JSON.parse(response.body)["data"]
      expect(response).to be_successful
      expect(returned_merchants.count).to eq(3)
      expect(returned_merchants.first["attributes"]["id"]).to eq(merchant.id)
    end
  end
  
  describe 'for a single merchant' do
    before(:each) do
      @merchant = create(:merchant, name: "Merchant1", created_at: '2012-03-27 14:53:59 UTC', updated_at: '2012-03-28 14:53:59 UTC')
      create(:merchant)
    end
    it 'can return a single merchant' do
      get "/api/v1/merchants/#{@merchant.id}"
    end
    it 'can find a single merchant by id' do
      get "/api/v1/merchants/find?id=#{@merchant.id}"
    end
    it 'can find a single merchant by name' do
      get "/api/v1/merchants/find?name=#{@merchant.name}"
    end
    it 'can find a single merchant by name case insensitive' do
      get "/api/v1/merchants/find?name=#{@merchant.name.upcase}"
    end
    it 'can find a single merchant by created_at' do
      get "/api/v1/merchants/find?created_at=#{@merchant.created_at}"
    end
    it 'can find a single merchant by updated_at' do
      get "/api/v1/merchants/find?updated_at=#{@merchant.updated_at}"
    end
    after(:each) do
      returned_merchant = JSON.parse(response.body)
      expect(response).to be_successful
      expect(returned_merchant["data"]["id"]).to eq(@merchant.id.to_s)
      expect(returned_merchant["data"]["attributes"]["name"]).to eq(@merchant.name)
    end
  end
  
  it 'can return a random merchant' do
    create_list(:merchant, 5)
    
    get "/api/v1/merchants/random"
    
    expect(response).to be_successful
    returned_merchant = JSON.parse(response.body)
    expect(returned_merchant["data"]["type"]).to eq("merchant")
    expect(returned_merchant.count).to eq(1)
  end
  
  describe 'Relationships' do
    it 'returns a collection of items associated with a merchant' do
      merchant = create(:merchant)
      item_1 = create(:item, merchant: merchant)
      item_2 = create(:item, merchant: merchant)
      item_3 = create(:item, merchant: merchant)
      item_4 = create(:item)
      
      get "/api/v1/merchants/#{merchant.id}/items"
      
      expect(response).to be_successful
      returned_items = JSON.parse(response.body)["data"]
      expect(returned_items.count).to eq(3)
      expect(returned_items.first["attributes"]["id"]).to eq(item_1.id)
      expect(returned_items.second["attributes"]["id"]).to eq(item_2.id)
      expect(returned_items.last["attributes"]["id"]).to eq(item_3.id)
    end
    
    it 'returns a collection of invoices associated with a merchant' do
      merchant = create(:merchant)
      invoice_1 = create(:invoice, merchant: merchant)
      invoice_2 = create(:invoice, merchant: merchant)
      invoice_3 = create(:invoice, merchant: merchant)
      invoice_4 = create(:invoice)
      
      get "/api/v1/merchants/#{merchant.id}/invoices"
      
      expect(response).to be_successful
      returned_invoices = JSON.parse(response.body)["data"]
      expect(returned_invoices.count).to eq(3)
      expect(returned_invoices.first["attributes"]["id"]).to eq(invoice_1.id)
      expect(returned_invoices.second["attributes"]["id"]).to eq(invoice_2.id)
      expect(returned_invoices.last["attributes"]["id"]).to eq(invoice_3.id)
    end
  end
end