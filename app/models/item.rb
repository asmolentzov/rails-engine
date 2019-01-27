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
  
  def self.top_items_by_number_sold(quantity)
    Item.joins(invoices: :transactions)
        .merge(Transaction.successful)
        .group(:id)
        .select("items.*, SUM(invoice_items.quantity) AS total_sold")
        .order("total_sold DESC")
        .limit(quantity)
  end
  
  def best_date
    # ordered_invoices = invoices.joins(:invoice_items, :transactions)
    # .merge(Transaction.successful)
    # .group("DATE_TRUNC('day', invoices.created_at)")
    # .group(:id)
    # .group("invoice_items.id")
    # .select("invoices.*, invoice_items.quantity * invoice_items.unit_price AS total_sales")
    # .order("total_sales DESC")
    # .order(created_at: :desc)
    
    
    
    x = invoices.joins(:invoice_items, :transactions)
            .merge(Transaction.successful)
            .group(:id)
            .select("invoices.*, SUM(invoice_items.quantity * invoice_items.unit_price) AS total_sales")
            
    y = x.group("DATE_TRUNC('day', invoices.created_at)")
         .select("SUM(total_sales) AS sales_by_date")
         .order("sales_by_date DESC")
         .first
            
    require 'pry'; binding.pry
    # .first.created_at
  end
end
