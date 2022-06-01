class PaymentsController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: 'not_found', status: :not_found
  end

  before_action :find_payment, only: :show

  # GET /payments/:id
  def show
    render json: @payment
  end

  # POST /payments
  def create
    @payment = Payment.new(payment_params)
    begin
      ActiveRecord::Base.transaction do
        @payment.save!
        @payment.loan.update(total_payments: @payment.loan.total_payments + @payment.amount)
      end
    rescue StandardError
      render json: @payment.errors, status: :unprocessable_entity
    else
      render json: @payment, status: :created
    end
  end

  private

    def find_payment
      @payment = Payment.find(params[:id])
    end

    def payment_params
      params.require(:payment).permit(:amount, :loan_id).tap do |p|
        p[:date] = Date.today
      end
    end
end
