class SearchesController < ApplicationController
  def index
    if params[:keyword].present?
      @incomes = Income.includes(:location).search(params[:keyword])
      @expenses = Expense.includes(:location).search(params[:keyword])
    else
      @incomes = []
      @expenses = []
    end
  end
end
