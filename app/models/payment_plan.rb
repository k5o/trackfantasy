class PaymentPlan < ActiveRecord::Base
  PLAN_NAMES = ['monthly', 'annual']
  MONTHLY_PLAN_NAME = 'monthly'
  MONTHLY_PLAN_AMOUNT_IN_CENTS = 1900
  ANNUAL_PLAN_NAME = 'annual'
  ANNUAL_PLAN_AMOUNT_IN_CENTS = 17900
end