Rails.configuration.stripe = {
  :publishable_key => Rails.application.secrets.STRIPE_PUBLISHABLE_KEY,
  :secret_key      => Rails.application.secrets.STRIPE_SECRET_KEY
}

Stripe.api_key = Rails.application.secrets.STRIPE_SECRET_KEY