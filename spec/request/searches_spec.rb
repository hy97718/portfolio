require 'rails_helper'

RSpec.describe SearchesController, type: :request do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:location) { create(:location, user: user) }
  let(:another_location) { create(:location, user: user) }
  let(:keyword_income) { "Income_with_keyword" }
  let(:keyword_expense) { "Expense_with_keyword" }
  let!(:income) { create(:income, user: user, location: location, income_name: "Income_with_keyword") }
  let!(:income_b) { create(:income, user: user, location: location, income_memo: "Income_with_keyword") }
  let!(:expense) { create(:expense, user: user, location: location, expense_name: "Expense_with_keyword") }
  let!(:expense_b) { create(:expense, user: user, location: location, expense_memo: "Expense_with_keyword") }
  let!(:another_income) { create(:income, location: another_location, user: another_user) }
  let!(:another_expense) { create(:expense, location: another_location, user: another_user) }
  

  describe "GET #index" do
    context "ユーザーがログインしている場合" do
      before do
        sign_in user
      end

      context "自分のユーザーIDが指定されている場合" do
        it "正常にレスポンスを返すこと" do
          get user_searches_path(user_id: user.id)
          expect(response).to have_http_status(200)
        end

        context "キーワードが指定されている場合" do
          it "incomeの検索結果を返すこと" do
            get user_searches_path(user_id: user.id, keyword: keyword_income)
            expect(response).to have_http_status(200)
            within(".table") do
              expect(response.body).to include(income.income_name)
              expect(response.body).to include(income_b.income_name)
            end
          end

          it "expenseの検索結果を返すこと" do
            get user_searches_path(user_id: user.id, keyword: keyword_expense)
            expect(response).to have_http_status(200)
            within(".table") do
              expect(response.body).to include(expense.expense_name)
              expect(response.body).to include(expense_b.expense_name)
            end
          end
        end

        context "キーワードが指定されていない場合" do
          it "空の検索結果を返すこと" do
            get user_searches_path(user_id: user.id)
            expect(response).to have_http_status(200)
            within(".table") do
              expect(response.body).to be_empty
            end
          end
        end
      end

      context "他のユーザーのユーザーIDが指定されている場合" do
        it "不正なアクセスとなり、ルートパスにリダイレクトされること" do
          get user_searches_path(user_id: another_user.id)
          expect(response).to redirect_to(root_path)
          expect(flash[:alert]).to eq("不正なアクセスです")
        end
      end
    end

    context "ユーザーがログインしていない場合" do
      it "ルートパスにリダイレクトされること" do
        get user_searches_path(user_id: user.id)
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
