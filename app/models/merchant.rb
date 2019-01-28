class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices
  validates_presence_of :name
  
  def total_revenue
    invoices.joins(:invoice_items, :transactions)
            .merge(Transaction.successful)
            .sum("invoice_items.quantity * invoice_items.unit_price")
  end
  
  def total_revenue_by_date(date)
    start_date = date + " 00:00:00 UTC"
    end_date = date + " 23:59:59 UTC"
    invoices.joins(:invoice_items, :transactions)
            .merge(Transaction.successful)
            .where("invoices.created_at BETWEEN ? AND ?", start_date, end_date)
            .sum("invoice_items.quantity * invoice_items.unit_price")
  end
  
  def favorite_customer
    Customer.joins(invoices: :transactions)
            .merge(Transaction.successful)
            .where("invoices.merchant_id = ?", self)
            .group(:id)
            .select("customers.*, COUNT(transactions.id) AS transactions_count")
            .order("transactions_count DESC")
            .first
  end
  
  def self.merchants_by_revenue(quantity)
     Merchant.joins(invoices: [:invoice_items, :transactions])
              .merge(Transaction.successful)
              .select("merchants.*, SUM(invoice_items.quantity * invoice_items.unit_price) AS revenue")
              .group(:id)
              .order("revenue DESC")
              .limit(quantity)
  end
  
  def self.merchants_by_items(quantity)
    Merchant.joins(invoices: [:invoice_items, :transactions])
            .merge(Transaction.successful)
            .select("merchants.*, SUM(invoice_items.quantity) AS item_count")
            .group(:id)
            .order("item_count DESC")
            .limit(quantity)
    
  end
  
  def self.all_total_revenue_by_date(date)
    begin_date = date + " 00:00:00 UTC"
    end_date = date + " 23:59:59 UTC"
    
    Invoice.joins(:invoice_items, :transactions)
           .merge(Transaction.successful)
           .where(created_at: begin_date..end_date)
           .sum("invoice_items.unit_price * invoice_items.quantity")
  end
end
