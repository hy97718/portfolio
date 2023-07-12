require 'rails_helper'

RSpec.describe "Locations", type: :request do
  let(:user) { create(:user) }
  let(:location) { create(:location, user: user) }
  let(:another_user) { create(:another_user) }
  let(:another_location) { create(:location, user: another_user) }

  describe 'GET #index' do
    before do
      sign_in user
      get locations_path
    end

    it '正常にレスポンスを返すこと' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET #new' do

    before do
      sign_in user
      get new_location_path
    end

    it '正常にレスポンスを返すこと' do
      get new_location_path
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST #create' do

    before do
      sign_in user
    end

    it '資産情報が登録できること' do
      location_params = attributes_for(:location)
      post locations_path({location: location_params})
      expect(response).to redirect_to(locations_path)
      expect(flash[:notice]).to eq("資産情報を登録しました。")
    end

    it '資産情報が保存されること' do
      location_params = attributes_for(:location)
      post locations_path({location: location_params})
      expect(response).to have_http_status(302)
      expect(Location.last.location_name).to eq(location_params[:location_name])
      expect(Location.last.asset_name).to eq(location_params[:asset_name])
      # expect(Location.last.max_expense.to_s).to eq(location_params[:max_expense])
    end

    it '資産情報の登録に失敗した場合、再度入力画面が表示されること' do
      location_params = attributes_for(:location, asset_name: "")
      post locations_path({location: location_params})
      expect(response.body).to include("資産情報を登録できませんでした。")
    end
  end

  describe 'GET #edit' do
    before do
      sign_in user
      get edit_location_path(location)
    end

    it '正常にレスポンスを返すこと' do
      expect(response).to have_http_status(200)
    end

    it '他のユーザーの編集ページにはアクセスできないこと' do
      get edit_location_path(another_location)
      expect(response).to redirect_to(locations_path)
      expect(flash[:alert]).to eq('不正なアクセスです')
    end
  end

  describe 'PATCH #update' do
    before do
      sign_in user
      get edit_location_path(location)
    end

    it '資産情報を更新できること' do
      new_asset_name = "New Asset Name"
      patch location_path(location), params: { location: { asset_name: new_asset_name } }
      location.reload
      expect(location.asset_name).to eq(new_asset_name)
      expect(response).to redirect_to(locations_path)
      expect(flash[:notice]).to eq("資産情報を更新しました。")
    end

    it '資産情報の更新に失敗した場合、再度編集画面が表示されること' do
      patch location_path(location), params: { location: { asset_name: "" } }
      expect(response.body).to include("資産情報を更新できませんでした。")
    end
  end

  describe 'DELETE #destroy' do
    before do
      sign_in user
      get edit_location_path(location)
    end

    it '資産情報を削除できること' do
      delete location_path(location)
      expect(location[:location_id]).to eq nil
    end
  end
end
