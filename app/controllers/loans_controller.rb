class LoansController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: 'not_found', status: :not_found
  end

  #GET /loans
  def index
    render json: Loan.all.to_json(methods: :outstanding_balance)
  end

  #GET /loans/:id
  def show
    @loan = Loan.find(params[:id])
    render json: @loan.to_json(methods: :outstanding_balance)
  end

  #GET /loans/:id/payments
  def payments
    render json: Payment.where(loan_id: params[:id])
  end
end