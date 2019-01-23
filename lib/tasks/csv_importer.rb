require 'csv'
require './config/environment'

def import_customers
  CSV.foreach("db/csv_data/customers.csv", headers: true) do |row|
    Customer.create!(row.to_h)
  end
end

def import_invoice_items
  CSV.foreach("db/csv_data/invoice_items.csv", headers: true) do |row|
    InvoiceItem.create!(row.to_h)
  end
end

def import_invoices 
  CSV.foreach("db/csv_data/invoices.csv", headers: true) do |row|
    Invoice.create!(row.to_h)
  end
end

def import_items
  CSV.foreach("db/csv_data/items.csv", headers: true) do |row|
    Item.create!(row.to_h)
  end
end

def import_merchants
  CSV.foreach("db/csv_data/merchants.csv", headers: true) do |row|
    Merchant.create!(row.to_h)
  end
end

def import_transactions
  CSV.foreach("db/csv_data/transactions.csv", headers: true) do |row|
    Transaction.create!(row.to_h)
  end
end