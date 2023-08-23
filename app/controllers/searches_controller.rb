class SearchesController < ApplicationController
  def index
    if current_user && current_user.id == params[:user_id].to_i
      if params[:keyword].present?
        @incomes = current_user.incomes.includes(:location).search(params[:keyword])
        @expenses = current_user.expenses.includes(:location).search(params[:keyword])
      else
        @incomes = []
        @expenses = []
      end
    else
      flash[:alert] = "不正なアクセスです"
      redirect_to root_path
    end
  end
end
