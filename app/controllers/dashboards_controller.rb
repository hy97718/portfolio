class DashboardsController < ApplicationController
  def index
    if current_user && current_user.id == params[:user_id].to_i
      @total_income = current_user.incomes.sum(:income_money)
      @total_expense = current_user.expenses.sum(:expense_money)
      @user_assets = @total_income - @total_expense
      @assets_data = [
        { name: '総収入', y: @total_income },
        { name: '総支出', y: @total_expense },
      ]
    else
      flash[:alert] = "不正なアクセスです"
      redirect_to root_path
    end
  end
end
