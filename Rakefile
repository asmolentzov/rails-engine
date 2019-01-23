# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks


namespace :import do
  desc "Imports customers from CSV file"
  task customers: :environment do
    ruby '-r "./lib/tasks/csv_importer.rb" -e "import_customers"'
  end
  
  desc "Imports invoices from CSV file"
  task invoices: :environment do
    ruby '-r "./lib/tasks/csv_importer.rb" -e "import_invoices"'
  end
  
  desc "Imports items from CSV file"
  task items: :environment do
    ruby '-r "./lib/tasks/csv_importer.rb" -e "import_items"'
  end
  
  desc "Imports invoice_items from CSV file"
  task invoice_items: :environment do
    ruby '-r "./lib/tasks/csv_importer.rb" -e "import_invoice_items"'
  end
  
  desc "Imports merchants from CSV file"
  task merchants: :environment do
    ruby '-r "./lib/tasks/csv_importer.rb" -e "import_merchants"'
  end
  
  desc "Imports transactions from CSV file"
  task transactions: :environment do
    ruby '-r "./lib/tasks/csv_importer.rb" -e "import_transactions"'
  end
  
  desc "Imports all data from CSV file"
  task all: :environment do
    Rake::Task["import:customers"].invoke
    Rake::Task["import:merchants"].invoke
    Rake::Task["import:invoices"].invoke
    Rake::Task["import:items"].invoke
    Rake::Task["import:invoice_items"].invoke
    Rake::Task["import:transactions"].invoke
  end
end



