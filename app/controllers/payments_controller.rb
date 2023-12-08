class PaymentsController < ApplicationController
  def new
  end

  def create
    byebug
    # Set your actual success and cancel URLs
    success_url = 'http://yourdomain.com/success'
    cancel_url = 'http://yourdomain.com/cancel'
 byebug
payment_method = Stripe::PaymentMethod.create({
  type: 'card',
  card: { token: 'tok_visa' }
})
# payment_method_id ='pi_3OL1rsSG8L3EVXz90XXAHL0j'
    payment_intent = Stripe::PaymentIntent.create(
      amount: 20000, 
      currency: 'usd',

      payment_method: params[:payment_method_id],
      return_url: success_url, 
      confirm: true
    )
    payment_intent.confirm

  byebug  
    render json: { paymentIntentId: payment_intent.id }
  rescue Stripe::CardError => e
    render json: { error: e.message }
  rescue Stripe::InvalidRequestError => e
    render json: { error: e.message }
  end
end
