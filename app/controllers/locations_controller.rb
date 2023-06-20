class LocationsController < ApplicationController
  def index
    @locations = current_user.locations.all
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

  private
    def location_params
      params.require(:location).permit(:asset_name,:location_name)
    end
end