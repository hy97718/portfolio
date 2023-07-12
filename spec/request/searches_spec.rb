# require 'rails_helper'

# RSpec.describe SearchesController, type: :request do
#   let(:user) { create(:user) }
#   let(:other_user) { create(:user) }
#   let!(:income) { create(:income, user: user) }
#   let!(:expense) { create(:expense, user: user) }
#   let!(:other_income) { create(:income, user: other_user) }
#   let!(:other_expense) { create(:expense, user: other_user) }
#   let(:keyword_income) { "Income_with_keyword" }
#   let(:keyword_expense) { "Expense_with_keyword" }
#   let!(:income_with_keyword) { create(:income, user: user, income_name: "Income_with_keyword") }
#   let!(:expense_with_keyword) { create(:expense, user: user, expense_name: "Expense_with_keyword") }

#   describe "GET #index" do
#     context "ユーザーがログインしている場合" do
#       before do
#         sign_in user
#       end

#       context "自分のユーザーIDが指定されている場合" do
#         it "正常にレスポンスを返すこと" do
#           get user_searches_path(user_id: user.id)
#           expect(response).to have_http_status(200)
#         end

#         context "キーワードが指定されている場合" do
#           it "incomeの検索結果を返すこと" do
#             get user_searches_path(user_id: user.id, keyword: keyword_income)
#             expect(response).to have_http_status(200)
#             within(".table") do
#               expect(response.body).to include(income_with_keyword)
#             end
#           end

#           it "expenseの検索結果を返すこと" do
#             get user_searches_path(user_id: user.id, keyword: keyword_expense)
#             expect(response).to have_http_status(200)
#             within(".table") do
#               expect(response.body).to include(expense_with_keyword)
#             end
#           end
#         end

#         context "キーワードが指定されていない場合" do
#           it "空の検索結果を返すこと" do
#             get user_searches_path(user_id: user.id)
#             expect(response).to have_http_status(200)
#             within(".table") do
#               expect(response.body).to be_empty
#             end
#           end
#         end
#       end

#       context "他のユーザーのユーザーIDが指定されている場合" do
#         it "不正なアクセスとなり、ルートパスにリダイレクトされること" do
#           get user_searches_path(user_id: other_user.id)
#           expect(response).to redirect_to(root_path)
#           expect(flash[:alert]).to eq("不正なアクセスです")
#         end
#       end
#     end

#     context "ユーザーがログインしていない場合" do
#       it "ルートパスにリダイレクトされること" do
#         get user_searches_path(user_id: user.id)
#         expect(response).to redirect_to(root_path)
#       end
#     end
#   end
# end
