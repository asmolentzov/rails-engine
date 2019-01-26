class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices
  validates_presence_of :name
  
  def total_revenue
    # invoices.joins(:invoice_items, :transactions)
    #         .where(transactions: {result: "success"})
    #         .sum("invoice_items.quantity * invoice_items.unit_price")
            
    # items.joins(invoices: :transactions)
    #      .where(transactions: {result: 'success'})
    #      .sum("invoice_items.quantity * invoice_items.unit_price")
    
      Invoice.joins(:invoice_items, :transactions)
           .where(merchant_id: self)
           .where(transactions: {result: 'success'})
           .group("invoice_items.id")
           .select("SUM(invoice_items.quantity * invoice_items.unit_price) AS invoice_price")
           .pluck("SUM(invoice_items.quantity * invoice_items.unit_price) AS invoice_price")
           .sum 
  end
  
  def self.merchants_by_revenue(quantity)
     Merchant.joins(invoices: [:invoice_items, :transactions])
              .where(transactions: {result: "success"})
              .select("merchants.*, SUM(invoice_items.quantity * invoice_items.unit_price) AS revenue")
              .group(:id)
              .order("revenue DESC")
              .limit(quantity)
  end
  
  def self.merchants_by_items(quantity)
    Merchant.joins(invoices: [:invoice_items, :transactions])
            .where("transactions.result = 'success'")
            .select("merchants.*, SUM(invoice_items.quantity) AS item_count")
            .group(:id)
            .order("item_count DESC")
            .limit(quantity)
    
  end
end
