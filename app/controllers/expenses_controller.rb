class ExpensesController < ApplicationController
  def index
    @location = Location.find(params[:location_id])
    if @location.user == current_user
      @expenses = @location.expenses.includes(:user).order(expense_day: :desc)
      @expense_counts = Expense.group(:expense_name).count
    else
      flash[:alert] = "不正なアクセスです"
      redirect_to locations_path
    end
  end

  def show
    @location = Location.find(params[:location_id])
    @expense = @location.expenses.find(params[:id])
  end

  def monthly_expenses
    @location = Location.find(params[:location_id])
    if @location.user == current_user
      @monthly_expenses = @location.expenses.
        group("strftime('%Y-%m', expense_day)").sum(:expense_money)
    else
      flash[:alert] = "不正なアクセスです"
      redirect_to locations_path
    end
  end

  def new
    @location = Location.find(params[:location_id])
    @expense = @location.expenses.new
  end

  def create
    @location = Location.find(params[:location_id])
    @expense = @location.expenses.new(expense_params)
    @expense.user = current_user
    if @expense.save
      redirect_to location_expenses_path
      @message = @location.check_max_expense(@expense)
      if @message.present?
        flash[:warn] = @message
      end
    else
      flash.now[:alert] = "#{@location.location_name}出金を登録できませんでした。"
      render action: :new
    end
  end

  def edit
    @location = Location.find(params[:location_id])
    @expense = @location.expenses.find(params[:id])
    if @location.user != current_user
      redirect_to location_expenses_path, alert: "不正なアクセスです"
    end
  end

  def update
    @location = Location.find(params[:location_id])
    @expense = @location.expenses.find(params[:id])
    if @expense.update(expense_params)
      redirect_to location_expenses_path
      @message = @location.check_max_expense(@expense)
      if @message.present?
        flash[:warn] = @message
      end
    else
      flash.now[:alert] = "出金の情報を更新できませんでした。"
      render action: :edit
    end
  end

  def destroy
    @location = Location.find(params[:location_id])
    @expense = @location.expenses.find(params[:id])
    if @expense.destroy
      redirect_to location_expenses_path, notice: "出金情報を削除しました。"
    else
      flash.now[:alert] = "出金情報の削除に失敗しました。"
      render action: :index
    end
  end

  private

  def expense_params
    params.require(:expense).permit(:expense_name, :expense_day, :expense_money, :expense_memo)
  end
end
