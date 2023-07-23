require "rails_helper"

RSpec.describe DashboardsController, type: :request do
  let(:user) { create(:user) }
  let(:location) { create(:location, user: user) }
  let!(:incomes) { Array.new(3) { create(:income, user: user, location: location) } }
  let!(:expenses) { Array.new(2) { create(:expense, user: user, location: location) } }

  describe "GET #index" do
    context "ユーザーがログインしている場合" do
      before do
        sign_in user
        get user_dashboards_path(user_id: user.id)
      end

      it "正常にレスポンスを返すこと" do
        expect(response).to have_http_status(200)
      end

      it "@total_incomeが取得できること" do
        expect(response.body).to include("総収入: #{controller.instance_variable_get(:@total_income)}")
      end

      it "@total_expenseが取得できること" do
        expect(response.body).to include("総支出: #{controller.instance_variable_get(:@total_expense)}")
      end

      it "@user_assetsが取得できること" do
        expect(response.body).to include("総資産: #{controller.instance_variable_get(:@user_assets)}")
      end      
    end

    context "ユーザーがログインしていない場合" do
      it "ルートパスにリダイレクトされること" do
        get user_dashboards_path(user_id: user.id)
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
