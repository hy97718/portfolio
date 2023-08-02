class IncomesController < ApplicationController
  def index
    @location = Location.find(params[:location_id])
    if @location.user == current_user
      @incomes = @location.incomes.includes(:user).order(income_day: :desc)
      @income_counts = Income.group(:income_name).count
    else
      flash[:alert] = "不正なアクセスです"
      redirect_to locations_path
    end
  end

  def show
    @location = Location.find(params[:location_id])
    @income = @location.incomes.find(params[:id])
  end

  def monthly_incomes
    @location = Location.find(params[:location_id])
    if @location.user == current_user
      @monthly_incomes = if Rails.env.production? &&
        ActiveRecord::Base.connection.adapter_name.downcase.start_with?("postgresql")
                           postgresql_monthly_incomes
                         else
                           sqlite_monthly_incomes
                         end
    else
      flash[:alert] = "不正なアクセスです"
      redirect_to locations_path
    end
  end

  def new
    @location = Location.find(params[:location_id])
    @income = @location.incomes.new
  end

  def create
    @location = Location.find(params[:location_id])
    @income = @location.incomes.new(income_params)
    @income.user = current_user
    if @income.save
      redirect_to location_incomes_path, notice: "#{@location.location_name}の入金が登録されました。"
    else
      flash.now[:alert] = "#{@location.location_name}入金を登録できませんでした。"
      render action: :new
    end
  end

  def edit
    @location = Location.find(params[:location_id])
    @income = @location.incomes.find(params[:id])
    if @location.user != current_user
      redirect_to location_incomes_path, alert: "不正なアクセスです"
    end
  end

  def update
    @location = Location.find(params[:location_id])
    @income = @location.incomes.find(params[:id])
    if @income.update(income_params)
      redirect_to location_incomes_path, notice: "入金の情報が変更されました"
    else
      flash.now[:alert] = "入金の情報を更新できませんでした。"
      render action: :edit
    end
  end

  def destroy
    @location = Location.find(params[:location_id])
    @income = @location.incomes.find(params[:id])
    if @income.destroy
      redirect_to location_incomes_path, notice: "入金情報を削除しました。"
    else
      flash.now[:alert] = "入金情報の削除に失敗しました。"
      render action: :index
    end
  end

  private

  def income_params
    params.require(:income).permit(:income_name, :income_day, :income_money, :income_memo)
  end

  def postgresql_monthly_incomes
    @location.incomes.group("to_char(income_day, 'YYYY/MM')").sum(:income_money)
  end

  def sqlite_monthly_incomes
    @location.incomes.group("strftime('%Y/%m', income_day)").sum(:income_money)
  end
end
