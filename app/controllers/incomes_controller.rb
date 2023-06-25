class IncomesController < ApplicationController
  def index
    @location = Location.find(params[:location_id])
    if @location.user == current_user
      @incomes = @location.incomes.order(income_day: :desc)
    else
      flash[:alert] = "不正なアクセスです"
      redirect_to locations_path
    end
  end

  def show
    @location = Location.find(params[:location_id])
    @income = @location.incomes.find(params[:id])
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

  private

  def income_params
    params.require(:income).permit(:income_name, :income_day, :income_money, :income_memo)
  end
end
