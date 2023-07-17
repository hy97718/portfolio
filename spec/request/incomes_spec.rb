require 'rails_helper'

RSpec.describe "Incomes", type: :request do
  let(:user) { create(:user) }
  let(:location) { create(:location, user: user) }
  let!(:income) { create(:income, location: location, user: user) }
  let(:another_user) { create(:another_user) }
  let(:another_location) { create(:location, user: another_user) }
  let!(:another_income) { create(:income, location: another_location, user: another_user) }

  describe "GET #index" do
    before do
      sign_in user
      get location_incomes_path(location)
    end

    it "正常にレスポンスを返すこと" do
      expect(response).to have_http_status(200)
    end

    it "他のユーザーの場所の収入にアクセスできないこと" do
      get location_incomes_path(another_location)
      expect(response).to redirect_to(locations_path)
      expect(flash[:alert]).to eq("不正なアクセスです")
    end
  end

  describe "GET #show" do
    before do
      sign_in user
      get location_income_path(location, income)
    end

    it "正常にレスポンスを返すこと" do
      expect(response).to have_http_status(200)
    end

    context "@incomeの取得について" do
      it "income_nameが取得できること" do
        expect(response.body).to include(income.income_name)
      end

      it "income_moneyが取得できること" do
        within(".table") do
          expect(response.body).to include(income.income_money.to_s)
        end
      end

      it "income_dayが取得できること" do
        within(".table") do
          expect(response.body).to include(income.income_day.to_s)
        end
      end
      
      it "income_memoが取得できること" do
        expect(response.body).to include(income.income_memo)
      end
    end
  end

  describe "GET #new" do
    before do
      sign_in user
      get new_location_income_path(location)
    end

    it "正常にレスポンスを返すこと" do
      expect(response).to have_http_status(200)
    end
  end

  describe "POST #create" do
    before do
      sign_in user
    end

    it "収入が作成されること" do
      income_params = attributes_for(:income)
      post location_incomes_path(location), params: { income: income_params }
      expect(response).to redirect_to(location_incomes_path)
      expect(flash[:notice]).to eq("#{location.location_name}の入金が登録されました。")
    end

    it "収入の作成に失敗した場合、再度入力画面が表示されること" do
      income_params = attributes_for(:income, income_name: "")
      post location_incomes_path(location), params: { income: income_params }
      expect(response.body).to include("#{location.location_name}入金を登録できませんでした。")
    end
  end

  describe "GET #edit" do
    before do
      sign_in user
      get edit_location_income_path(location, income)
    end

    it "正常にレスポンスを返すこと" do
      expect(response).to have_http_status(200)
    end

    it "他のユーザーの収入の編集にアクセスできないこと" do
      get edit_location_income_path(another_location, another_income)
      expect(response).to redirect_to(location_incomes_path)
      expect(flash[:alert]).to eq("不正なアクセスです")
    end
  end

  describe "PATCH #update" do
    before do
      sign_in user
    end

    it "収入が更新されること" do
      new_income_name = "New Income Name"
      patch location_income_path(location, income), params: { income: { income_name: new_income_name } }
      income.reload
      expect(income.income_name).to eq(new_income_name)
      expect(response).to redirect_to(location_incomes_path)
      expect(flash[:notice]).to eq("入金の情報が変更されました")
    end

    it "収入の更新に失敗した場合、再度編集画面が表示されること" do
      patch location_income_path(location, income), params: { income: { income_name: "" } }
      expect(response.body).to include("入金の情報を更新できませんでした。")
    end
  end

  describe "DELETE #destroy" do
    before do
      sign_in user
    end

    it "収入が削除されること" do
      delete location_income_path(location, income)
      expect(income[:income_id]).to eq nil
      expect(response).to redirect_to(location_incomes_path)
      expect(flash[:notice]).to eq("入金情報を削除しました。")
    end
  end
end
