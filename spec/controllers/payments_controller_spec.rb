require 'rails_helper'

RSpec.describe PaymentsController, type: :controller do
  describe '#show' do
    let(:loan) { Loan.create!(funded_amount: 100.0) }
    let(:payment) { Payment.create!(amount: 20.0, date: Date.today, loan_id: loan.id) }

    it 'responds with a 200' do
      get :show, params: { id: payment.id }
      expect(response).to have_http_status(:ok)
    end

    context 'if the payment is not found' do
      it 'responds with a 404' do
        get :show, params: { id: 10000 }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe '#create' do
    let(:loan) { Loan.create!(funded_amount: 100.0) }
    # let(:payment) { Payment.create!(amount: 20.0, date: Date.today, loan_id: loan.id) }

    it 'responds with a 422' do
      post :create, params: { payment: {amount: 1000.0, loan_id: loan.id} }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("Payment can't be greater than $100.0")
    end

    context 'if the loan is not found' do
      it 'responds with a 422' do
        post :create, params: { payment: {amount: 10.0, loan_id: 12} }
        expect(response).to have_http_status(:unprocessable_entity)
      end  
    end

    context 'payment is succesfull' do
      it 'responds with a 201' do
        post :create, params: { payment: {amount: 10.0, loan_id: loan.id} }
        expect(response).to have_http_status(:created)
      end  
    end
  end

end
