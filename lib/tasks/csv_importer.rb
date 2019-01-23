require 'csv'
require './config/environment'

def import_customers
  CSV.foreach("db/csv_data/customers.csv", headers: true) do |row|
    Customer.create!(row.to_h)
  end
end