module ApplicationHelper
  def other_plan_name(plan)
    if plan == PaymentPlan::MONTHLY_PLAN_NAME
      PaymentPlan::ANNUAL_PLAN_NAME
    elsif plan == PaymentPlan::ANNUAL_PLAN_NAME
      PaymentPlan::MONTHLY_PLAN_NAME
    end
  end

  def other_plan_cost(plan)
    if plan == PaymentPlan::MONTHLY_PLAN_NAME
      PaymentPlan::ANNUAL_PLAN_AMOUNT_IN_CENTS
    elsif plan == PaymentPlan::ANNUAL_PLAN_NAME
      PaymentPlan::MONTHLY_PLAN_AMOUNT_IN_CENTS
    end
  end

  def money_class(amount)
    if amount > 0
      'in-the-black'
    elsif amount < 0
      'in-the-red'
    else
      'even'
    end
  end
end
