class Payment < ActiveRecord::Base
  belongs_to :loan
  validates :amount, presence: true
  validate :is_payment_valid?


  # check payment doesn't exceed outstanding balance
  def is_payment_valid?
    loan = Loan.find(loan_id)
    if amount > loan.outstanding_balance
      errors.add(:amount, "Payment can't be greater than $#{loan.outstanding_balance}")
    end
  end
end