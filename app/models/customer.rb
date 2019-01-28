class Customer < ApplicationRecord
  validates_presence_of :first_name
  validates_presence_of :last_name
  
  has_many :invoices
  has_many :transactions, through: :invoices
  
  def favorite_merchant
    id = invoices.joins(:transactions)
            .merge(Transaction.successful)
            .group(:merchant_id)
            .select("invoices.merchant_id, COUNT(transactions.id) AS num_transactions")
            .order("num_transactions DESC")
            .first.merchant_id
    Merchant.find(id)
  end
end
