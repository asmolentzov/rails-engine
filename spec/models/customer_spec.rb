require 'rails_helper'

RSpec.describe Customer, type: :model do
  describe 'Validations' do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
  end
  
  describe 'Relationships' do
    it { should have_many(:invoices) }
    it { should have_many(:transactions)}
  end
  
  describe 'Instance Methods' do
    describe '#favorite_merchant' do
      it 'returns the merchant where the customer has conducted the most successful transactions' do
        customer = create(:customer)
        
        merchant_1 = create(:merchant)
        invoice_1 = create(:invoice, merchant: merchant_1, customer: customer)
        create(:transaction, invoice: invoice_1, result: 'success')
        
        merchant_2 = create(:merchant)
        invoice_2 = create(:invoice, merchant: merchant_2, customer: customer)
        invoice_3 = create(:invoice, merchant: merchant_2, customer: customer)
        invoice_4 = create(:invoice, merchant: merchant_2, customer: customer)
        invoice_5 = create(:invoice, merchant: merchant_2, customer: customer)
        create(:transaction, invoice: invoice_2, result: 'success')
        create(:transaction, invoice: invoice_3, result: 'success')
        create(:transaction, invoice: invoice_4, result: 'success')
        create(:transaction, invoice: invoice_5, result: 'success')
          
        merchant_3 = create(:merchant)
        invoice_6 = create(:invoice, merchant: merchant_3, customer: customer)
        invoice_7 = create(:invoice, merchant: merchant_3, customer: customer)
        invoice_8 = create(:invoice, merchant: merchant_3, customer: customer)
        invoice_9 = create(:invoice, merchant: merchant_3, customer: customer)
        invoice_10 = create(:invoice, merchant: merchant_3, customer: customer)
        create(:transaction, invoice: invoice_6, result: 'success')
        create(:transaction, invoice: invoice_7, result: 'success')
        create(:transaction, invoice: invoice_8, result: 'success')
        create(:transaction, invoice: invoice_9, result: 'failed')
        create(:transaction, invoice: invoice_10, result: 'failed')
        
        expect(customer.favorite_merchant).to eq(merchant_2)
      end
    end
  end
end
