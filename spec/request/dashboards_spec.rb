# require "rails_helper"

# RSpec.describe DashboardsController, type: :request do
#   let(:user) { create(:user) }
#   let!(:income1) { create(:income, user: user) }
#   let!(:income2) { create(:income, user: user) }
#   let!(:expense1) { create(:expense, user: user) }
#   let!(:expense2) { create(:expense, user: user) }

#   describe "GET #index" do
#     context "ユーザーがログインしている場合" do
#       before do
#         sign_in user
#         get user_dashboards_path(user_id: user.id)
#       end

#       it "正常にレスポンスを返すこと" do
#         expect(response).to have_http_status(200)
#       end

#       it "@total_incomeが取得できること" do
#         expect(response.body).to include("総収入: #{controller.instance_variable_get(:@total_income)}")
#       end

#       it "@total_expenseが取得できること" do
#         expect(response.body).to include("総支出: #{controller.instance_variable_get(:@total_expense)}")
#       end

#       it "@user_asstesが取得できること" do
#         expect(response.body).to include("総支出: #{controller.instance_variable_get(:@user_assets)}")
#       end
#     end

#     context "ユーザーがログインしていない場合" do
#       it "ルートパスにリダイレクトされること" do
#         get user_dashboards_path(user_id: user.id)
#         expect(response).to redirect_to(root_path)
#       end
#     end
#   end
# end
