require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'Validations' do
    it { should validate_presence_of(:name) }
  end
  
  describe 'Class Methods' do
    describe '.merchants_by_revenue' do
      it 'should return the top x merchants ranked by total revenue' do
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
        
        merchants = [merchant_4, merchant_2]
        expect(Merchant.merchants_by_revenue(2)).to eq(merchants)
        
        merchants = [merchant_4, merchant_2, merchant_5]
        expect(Merchant.merchants_by_revenue(3)).to eq(merchants)
      end
    end
    
    describe '.merchants_by_items' do
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
        invoice_item = create(:invoice_item, invoice: invoice_m3_1, item: item_m3_1, unit_price: 15, quantity: 20)
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
        
        merchants = [merchant_3, merchant_2]
        expect(Merchant.merchants_by_items(2)).to eq(merchants)
      end
    end
  end
  
  describe 'Instance Methods' do
    describe '#total_revenue' do
      it 'should return the total revenue for a merchant across successful transactions' do
        merchant = create(:merchant)
        item = create(:item, merchant: merchant)
        invoice = create(:invoice, merchant: merchant)
        invoice_2 = create(:invoice, merchant: merchant)
        
        invoice_item = create(:invoice_item, item: item, invoice: invoice, unit_price: 10, quantity: 2)
        invoice_item_2 = create(:invoice_item, item: item, invoice: invoice_2, unit_price: 2, quantity: 5)
        
        # Check failing transaction
        create(:transaction, invoice: invoice, result: "failed")
        expect(merchant.total_revenue).to eq(0)
        
        # Check successful transaction
        create(:transaction, invoice: invoice, result: "success")
        create(:transaction, invoice: invoice_2, result: "success")
        revenue = (invoice_item.unit_price * invoice_item.quantity) + (invoice_item_2.unit_price * invoice_item_2.quantity)
        expect(merchant.total_revenue).to eq(revenue)
      end
    end
    
    describe '#total_revenue_by_date' do
      it 'should return the total revenue for a merchant on a specified date' do
        merchant = create(:merchant)
        item = create(:item, merchant: merchant)
        invoice = create(:invoice, merchant: merchant, created_at: "2012-03-25 09:54:09 UTC")
        invoice_2 = create(:invoice, merchant: merchant, created_at: "2012-03-25 10:54:09 UTC")
        invoice_3 = create(:invoice, merchant: merchant, created_at: "2012-03-30 09:54:09 UTC")
        
        invoice_item = create(:invoice_item, item: item, invoice: invoice, unit_price: 10, quantity: 2)
        invoice_item_2 = create(:invoice_item, item: item, invoice: invoice_2, unit_price: 2, quantity: 5)
        invoice_item_3 = create(:invoice_item, item: item, invoice: invoice_3)
        
        # Check failing transaction
        create(:transaction, invoice: invoice, result: "failed")
        expect(merchant.total_revenue_by_date("2012-03-25")).to eq(0)
        
        # Check successful transactions
        create(:transaction, invoice: invoice, result: "success")
        create(:transaction, invoice: invoice_2, result: "success")
        create(:transaction, invoice: invoice_3, result: "success")
        revenue = (invoice_item.unit_price * invoice_item.quantity) + (invoice_item_2.unit_price * invoice_item_2.quantity)
        expect(merchant.total_revenue_by_date("2012-03-25")).to eq(revenue)
      end
    end
  end
end
