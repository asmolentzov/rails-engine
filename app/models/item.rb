class Item < ApplicationRecord
  validates_presence_of :name
  validates_presence_of :description
  validates_presence_of :unit_price
  
  belongs_to :merchant
  
  has_many :invoice_items
  has_many :invoices, through: :invoice_items
  
  def self.top_items_by_revenue(quantity)
    Item.joins(invoices: :transactions)
        .merge(Transaction.successful)
        .group(:id)
        .select("items.*, SUM(invoice_items.unit_price * invoice_items.quantity) AS revenue")
        .order("revenue DESC")
        .limit(quantity)
  end
end
