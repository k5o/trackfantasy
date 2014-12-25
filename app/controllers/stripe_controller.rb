class StripeController < ApplicationController
  def webhook
    event_json = JSON.parse(request.body.read)
    event = Stripe::Event.retrieve(event_json["id"])

    if event
      if event_json[:type] = 'invoice.payment_succeeded'
        user = User.find_by_stripe_customer_id(event_json[:data][:customer])
        plan = event_json[:data][:object][:name]

        user.set_active_until!(plan)
      if event_json[:type] = 'invoice.payment_failed'
        user.inactivate!
        # Send charge failed email
      end
    end

    status 200
  end
end