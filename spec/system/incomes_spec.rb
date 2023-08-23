require 'rails_helper'

RSpec.describe "Incomes", type: :system do
  let(:user) { create(:user) }
  let(:location) { create(:location, user: user) }
  let!(:income) { create(:income, location: location, user: user) }
  let!(:incomes) { Array.new(2) { create(:income, location: location, user: user) } }

  before do
    sign_in user
    visit location_incomes_path(location)
  end

  describe "index page" do
    it "入金一覧が全て表示されること" do
      incomes.all? do |income|
        expect(page).to have_content(income.income_name)
        expect(page).to have_content(income.income_day.to_datetime.strftime('%Y/%m/%d'))
        expect(page).to have_content("#{income.income_money.to_s(:delimited)}円")
        
      end
    end

    context "リンクの表示について" do
      it "全てのリンクが表示されること" do
        incomes.each do |income|
          expect(page).to have_link("新規作成", href: new_location_income_path(location))
          expect(page).to have_link(href: location_income_path(location, income))
          expect(page).to have_link("編集", href: edit_location_income_path(location, income))
          expect(page).to have_link("削除", href: location_income_path(location, income))
        end
      end
    end
  end

  describe "new page" do
    before do
      visit new_location_income_path(location)
    end

    it "フォームが表示されること" do
      expect(page).to have_selector("form")
    end

    it "戻るリンクが表示されること" do
      expect(page).to have_link("戻る")
    end

    it "入金が作成されること" do
      fill_in "入金名", with: "新しい入金"
      fill_in "入金日", with: Date.current
      fill_in "金額", with: 1000
      click_button "登録"
      expect(page).to have_content("新しい入金")
    end
  end

  describe "edit page" do
    before do
      visit edit_location_income_path(location, income)
    end

    context "編集ページの表示について" do
      it "入金名の編集欄が表示されること" do
        expect(page).to have_field("income[income_name]", with: income.income_name)
      end
      
      it "入金日の編集欄が表示されること" do
        expect(page).to have_field("income[income_day]", with: income.income_day)
      end

      it "金額の編集欄が表示されること" do
        expect(page).to have_field("income[income_money]", with: income.income_money.to_s)
      end

      it "入金日の編集欄が表示されること" do
        expect(page).to have_field("income[income_memo]", with: income.income_memo)
      end
    end

    it "戻るリンクが表示されること" do
      expect(page).to have_link("戻る")
    end

    it "入金が更新されること" do
      fill_in "入金名", with: "更新後の入金"
      click_button "更新"
      expect(page).to have_content("更新後の入金")
    end
  end

  describe "monthly incomes page" do
    before do
      visit monthly_incomes_location_incomes_path(location)
    end

    it "月次収入のグラフが表示されること" do
      expect(page).to have_selector(".monthly-container")
    end

    it "戻るリンクが表示されること" do
      expect(page).to have_link("戻る")
    end
  end
end
