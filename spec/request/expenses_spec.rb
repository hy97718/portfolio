require 'rails_helper'

RSpec.describe "Expenses", type: :request do
  let(:user) { create(:user) }
  let(:location) { create(:location, user: user) }
  let!(:expense) { create(:expense, location: location) }
  let(:another_user) { create(:another_user) }
  let(:another_location) { create(:location, user: another_user) }
  let!(:another_expense) { create(:expense, location: another_location) }

  describe "GET #index" do
    before do
      sign_in user
      get location_expenses_path(location)
    end

    it "正常にレスポンスを返すこと" do
      expect(response).to have_http_status(200)
    end

    it "他のユーザーの場所の支出にアクセスできないこと" do
      get location_expenses_path(another_location)
      expect(response).to redirect_to(locations_path)
      expect(flash[:alert]).to eq("不正なアクセスです")
    end
  end

  describe "GET #show" do
    before do
      sign_in user
      get location_expense_path(location, expense)
    end

    it "正常にレスポンスを返すこと" do
      expect(response).to have_http_status(200)
    end

    context "@expenseの取得について" do
      it "expense_nameが取得できること" do
        expect(response.body).to include(expense.expense_name)
      end

      it "expense_moneyが取得できること" do
        within(".table") do
          expect(response.body).to include(expense.expense_money.to_s)
        end
      end

      it "expense_dayが取得できること" do
        within(".table") do
          expect(response.body).to include(expense.expense_day.to_s)
        end
      end
      
      it "expense_memoが取得できること" do
        expect(response.body).to include(expense.expense_memo)
      end
    end
  end

  describe "GET #new" do
    before do
      sign_in user
      get new_location_expense_path(location)
    end

    it "正常にレスポンスを返すこと" do
      expect(response).to have_http_status(200)
    end
  end

  describe "POST #create" do
    before do
      sign_in user
    end

    it "支出が作成されること" do
      expense_params = attributes_for(:expense)
      post location_expenses_path(location), params: { expense: expense_params }
      expect(response).to redirect_to(location_expenses_path)
    end

    it "支出の作成に失敗した場合、再度入力画面が表示されること" do
      expense_params = attributes_for(:expense, expense_name: "")
      post location_expenses_path(location), params: { expense: expense_params }
      expect(response.body).to include("#{location.location_name}出金を登録できませんでした。")
    end
  end

  describe "GET #edit" do
    before do
      sign_in user
      get edit_location_expense_path(location, expense)
    end

    it "正常にレスポンスを返すこと" do
      expect(response).to have_http_status(200)
    end

    it "他のユーザーの支出の編集にアクセスできないこと" do
      get edit_location_expense_path(another_location, another_expense)
      expect(response).to redirect_to(location_expenses_path)
      expect(flash[:alert]).to eq("不正なアクセスです")
    end
  end

  describe "PATCH #update" do
    before do
      sign_in user
    end

    it "支出が更新されること" do
      new_expense_name = "New expense Name"
      patch location_expense_path(location, expense), params: { expense: { expense_name: new_expense_name } }
      expense.reload
      expect(expense.expense_name).to eq(new_expense_name)
      expect(response).to redirect_to(location_expenses_path)
    end

    it "支出の更新に失敗した場合、再度編集画面が表示されること" do
      patch location_expense_path(location, expense), params: { expense: { expense_name: "" } }
      expect(response.body).to include("出金の情報を更新できませんでした。")
    end
  end

  describe "DELETE #destroy" do
    before do
      sign_in user
    end

    it "支出が削除されること" do
      delete location_expense_path(location, expense)
      expect(expense[:expense_id]).to eq nil
      expect(response).to redirect_to(location_expenses_path)
      expect(flash[:notice]).to eq("出金情報を削除しました。")
    end
  end
end
