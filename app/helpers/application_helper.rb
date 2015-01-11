module ApplicationHelper
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
