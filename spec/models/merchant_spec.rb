require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'Validations' do
    it { should validate_presence_of(:name) }
  end
  
  describe 'Instance Methods' do
    describe '#total_revenue' do
      it 'should return the total revenue for a merchant across successful transactions' do
        merchant = create(:merchant)
        item = create(:item, merchant: merchant, unit_price: 10)
        invoice = create(:invoice, merchant: merchant)
        invoice_item = create(:invoice_item, item: item, invoice: invoice, unit_price: 10, quantity: 2)
        transaction = create(:transaction, invoice: invoice, result: "success")
        transaction_2 = create(:transaction, invoice: invoice, result: "fail")
        
        revenue = invoice_item.unit_price * invoice_item.quantity
        expect(merchant.total_revenue).to eq(revenue)
      end
    end
  end
end
