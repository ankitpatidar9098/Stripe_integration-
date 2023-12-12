class PaymentsController < ApplicationController

before_action :set_product, only: [:show, :purchase]

def index
  @tickets = Ticket.all
end

def show
end

def purchase

  begin
    # byebug
    customer = Stripe::Customer.create(
      email: params[:stripeEmail],
      # name: params[:customerName],
      source: params[:stripeToken] 
    )

    stripe_customer_id = customer.id

    payment_method = Stripe::PaymentMethod.create({
      type: 'card',
      card: { token: 'tok_visa' }
    })

    payment_method = Stripe::PaymentMethod.attach(payment_method.id, { customer: stripe_customer_id })
#  byebug
    payment_intent = Stripe::PaymentIntent.create(
      amount: @ticket.price,  
      currency: 'usd',
      description: @ticket.name,
      payment_method: payment_method.id,
      customer: customer['id'],
      automatic_payment_methods: { enabled: true, allow_redirects: 'never' }
    )

   
    if payment_intent.status == 'requires_action' && payment_intent.next_action['type'] == 'use_stripe_sdk' && payment_intent.next_action['use_stripe_sdk']['type'] == 'three_d_secure_redirect'
      # payment_intent = Stripe::PaymentIntent.retrieve(payment_intent.id,{ payment_method: payment_method, receipt_email: customer.email })
      redirect_to(payment_intent.next_action['use_stripe_sdk']['stripe_js'], allow_other_host: true)
    
    elsif payment_intent.status == 'succeeded'
     
      flash[:success] = "Payment Successfully Completed"
    else
      flash[:error] = "Payment failed: #{payment_intent.last_payment_error.message}"
      redirect_to @ticket
    end
    # byebug
  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to @ticket
  rescue Stripe::StripeError => e
    flash[:error] = e.message
    redirect_to @ticket
  end
end

private

def set_product
  @ticket = Ticket.find(params[:id])
end
end
# class PaymentsController < ApplicationController
#   before_action :set_ticket, only: [:show, :purchase]

#   def index
#     @tickets = Ticket.all
#   end

#   def show
#   end

#   def purchase
#     begin
#       # Create a customer using the provided email and token
#       customer = Stripe::Customer.create(
#         email: params[:stripeEmail],
#         source: params[:stripeToken]
#       )

#       # Attach a payment method to the customer
#       payment_method = Stripe::PaymentMethod.create({
#         type: 'card',
#         card: { token: params[:stripeToken] }
#       })

#       Stripe::PaymentMethod.attach(payment_method.id, { customer: customer.id })

#       # Create a payment intent with the attached payment method
#       payment_intent = Stripe::PaymentIntent.create(
#         amount: @ticket.price,
#         currency: 'usd',
#         description: @ticket.name,
#         payment_method: payment_method.id,
#         # customer: customer.id,
#         confirm: true
#       )

#       if payment_intent.status == 'succeeded'
#         flash[:success] = "Payment Successfully Completed"
#       else
#         flash[:error] = "Payment failed: #{payment_intent.last_payment_error.message}"
#         redirect_to @ticket
#       end
#     rescue Stripe::CardError => e
#       flash[:error] = e.message
#       redirect_to @ticket
#     rescue Stripe::StripeError => e
#       flash[:error] = e.message
#       # redirect_to @ticket
#       redirect_to ticket_path(@ticket)
#     end
#   end

#   private

#   def set_ticket
#     @ticket = Ticket.find(params[:id])
#   end
# end
