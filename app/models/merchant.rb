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
  
  def self.merchants_by_revenue(quantity)
     Merchant.joins(invoices: :invoice_items)
              .joins(invoices: :transactions)
              .where(transactions: {result: "success"})
              .select("merchants.*, SUM(invoice_items.quantity * invoice_items.unit_price) AS total_revenue")
              .group(:id)
              .order("total_revenue DESC")
              .limit(quantity)
  end
end
