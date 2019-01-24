class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices
  validates_presence_of :name
  
  def total_revenue
    invoices.joins(:items)
            .joins(:transactions)
            .where(transactions: {result: "success"})
            .sum("invoice_items.quantity * invoice_items.unit_price")
  end
end
