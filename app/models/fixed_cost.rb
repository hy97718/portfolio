class FixedCost < ApplicationRecord
  belongs_to :user
  belongs_to :location


  def create_recurring_costs
    case recurring_period
    when 'monthly'
      create_monthly_costs
    when 'weekly'
      create_weekly_costs
    when 'daily'
      create_daily_costs
    end
  end

  private

  def create_recurring_costs
    case recurring_period
    when 'monthly'
      create_monthly_costs
    when 'weekly'
      create_weekly_costs
    when 'daily'
      create_daily_costs
    end
  end

  private

  def create_monthly_costs
    current_date = recurring_start_date
    while current_date <= recurring_end_date
      FixedCost.create(fixed_cost_name: fixed_cost_name, fixed_cost_money: fixed_cost_money, recurring_start_date: current_date, recurring_end_date: current_date, user_id: user_id, location_id: location_id)
      current_date = current_date.next_month(recurring_day)
    end
  end

  def create_weekly_costs
    current_date = recurring_start_date
    while current_date <= recurring_end_date
      FixedCost.create(fixed_cost_name: fixed_cost_name, fixed_cost_money: fixed_cost_money, recurring_start_date: current_date, recurring_end_date: current_date, user_id: user_id, location_id: location_id)
      current_date = current_date + recurring_day.weeks
    end
  end

  def create_daily_costs
    current_date = recurring_start_date
    while current_date <= recurring_end_date
      FixedCost.create(fixed_cost_name: fixed_cost_name, fixed_cost_money: fixed_cost_money, recurring_start_date: current_date, recurring_end_date: current_date, user_id: user_id, location_id: location_id)
      current_date = current_date + recurring_day.days
    end
  end
end
