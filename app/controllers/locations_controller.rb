class LocationsController < ApplicationController
  def index
    @locations = Location.includes(:incomes, :expenses).
      where(user_id: current_user.id).order(:location_name)
  end

  def new
    @location = Location.new
  end

  def create
    @location = Location.new(location_params)
    @location.user_id = current_user.id
    if @location.save
      redirect_to locations_path, notice: "資産情報を登録しました。"
    else
      flash.now[:alert] = "資産情報を登録できませんでした。"
      render action: :new
    end
  end

  def edit
    @location = Location.find(params[:id])
    if @location.user_id != current_user.id
      redirect_to locations_path, alert: "不正なアクセスです"
    end
  end

  def update
    @location = Location.find(params[:id])
    if @location.update(location_params)
      redirect_to locations_path, notice: "資産情報を更新しました。"
    else
      flash.now[:alert] = "資産情報を更新できませんでした。"
      render action: :edit
    end
  end

  def destroy
    @location = Location.find(params[:id])
    if @location.destroy
      redirect_to locations_path, notice: "資産情報を削除しました。"
    else
      flash.now[:alert] = "資産情報の削除に失敗しました。"
      render action: :index
    end
  end

  private

  def location_params
    params.require(:location).permit(:asset_name, :location_name, :max_expense)
  end
end
