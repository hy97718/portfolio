class UsersController < ApplicationController
  before_action :check_guest_user

  def show
    @user = User.find(params[:id])
    if @user != current_user
      redirect_to user_path(current_user), alert: "不正なアクセスです"
    end  
  end

  def edit
    @user = User.find(params[:id])
    if @user != current_user
      redirect_to user_path(current_user), alert: "不正なアクセスです"
    end  
  end
  
  def personal_information_edit
    @user = User.find(params[:id])
    if @user != current_user
      redirect_to user_path(current_user), alert: "不正なアクセスです"
    end
  end

  def update
    @user =User.find(params[:id])
    if user_params.present?
      if @user.update(user_params)
        sign_in :user, @user, bypass: true
        redirect_to user_path(@user), notice: "プロフィール情報を更新しました。"  
      else
        flash.now[:alert] = "プロフィール情報を更新できませんでした。"
        render action: :edit
      end  
    elsif personal_information_params.present?
      if @user.update(personal_information_params)
        sign_in :user, @user, bypass: true
        redirect_to user_path(@user), notice: "アカウント情報を更新しました。"  
      else
        flash.now[:alert] = "アカウント情報を更新できませんでした。"
        render action: :personal_information_edit
      end    
    end 
  end

  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      redirect_to root_path, notice: "ユーザー情報を削除しました。"  
    else
      flash.now[:alert] = "ユーザーの削除に失敗しました。"
      render template: "home/index"
    end
  end

  private
  def user_params
    params.require(:user).permit(:username, :savings_target )
  end
  def personal_information_params
    params.require(:user).permit(:email, :password, :password_confirmation )
  end
  def check_guest_user
    @user = User.find(params[:id])
    if @user.guest?
      redirect_to root_path, alert: "ゲストユーザーの編集,削除はできません"
    end
  end
end
