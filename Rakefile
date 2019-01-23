# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

desc "Imports customers from CSV file"

task :import_customers => :environment do
  ruby '-r "./lib/tasks/csv_importer.rb" -e "import_customers"'
end

