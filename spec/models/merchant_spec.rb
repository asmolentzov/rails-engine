require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'Validations' do
    it { should validate_presence_of(:name) }
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
        create(:transaction, invoice: invoice, result: "fail")
        expect(merchant.total_revenue).to eq(0)
        
        # Check successful transaction
        create(:transaction, invoice: invoice, result: "success")
        create(:transaction, invoice: invoice_2, result: "success")
        revenue = (invoice_item.unit_price * invoice_item.quantity) + (invoice_item_2.unit_price * invoice_item_2.quantity)
        expect(merchant.total_revenue).to eq(revenue)
      end
    end
  end
end
