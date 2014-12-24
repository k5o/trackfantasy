module ApplicationHelper
  def other_plan_name(plan)
    if plan == 'monthly'
      'annual'
    elsif plan == 'annual'
      'monthly'
    end
  end

  def other_plan_cost(plan)
    if plan == 'monthly'
      '$179'
    elsif plan == 'annual'
      '$19'
    end
  end
end
