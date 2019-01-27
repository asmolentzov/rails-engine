require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'Validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:unit_price) }
  end
  
  describe 'Relationships' do
    it { should belong_to(:merchant) }
  end
  
  describe 'Class Methods' do
    describe '.top_items_by_revenue' do
      it 'returns the top x items ranked by total revenue generated' do
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
        
        expect(Item.top_items_by_revenue(2)).to eq([item_5, item_3])
        expect(Item.top_items_by_revenue(3)).to eq([item_5, item_3, item_2])
      end
    end
    
    describe '.top_items_by_number_sold' do
      it 'returns the top x items ranked by total number sold' do
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
        
        expect(Item.top_items_by_number_sold(2)).to eq([item_5, item_3])
        expect(Item.top_items_by_number_sold(3)).to eq([item_5, item_3, item_2])
      end
    end
  end
end
