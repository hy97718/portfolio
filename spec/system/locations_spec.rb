require 'rails_helper'

RSpec.describe "Locations", type: :system do
  let(:user) { create(:user) }
  let!(:location) { create(:location, user: user) }
  let!(:locations) { Array.new(2) { create(:location, user: user) } }

  before do
    sign_in user
    visit locations_path
  end

  describe "index page" do
    it "資産情報を全て表示できること" do
      locations.all? do |location|
        expect(page).to have_content(location.asset_name)
        expect(page).to have_content(location.location_name)
        expect(page).to have_content("残高: #{location.balance_money}")
      end
    end

    context "リンクの表示について" do
      it "リンクを全て表示できること" do
        locations.all? do |location|
          expect(page).to have_link("新規作成", href: new_location_path)
          #入金リンク
          expect(page).to have_link(nil, href: new_location_income_path(location))
          expect(page).to have_selector("i.fas.fa-plus") 
          # 出金リンク
          expect(page).to have_link(nil, href: new_location_expense_path(location))
          expect(page).to have_selector("i.fa.fa-minus") 
          # 編集リンク
          expect(page).to have_link(nil, href: edit_location_path(location))
          expect(page).to have_selector("i.fas.fa-pencil-alt") 
          #削除リンク
          expect(page).to have_link(nil, href: location_path(location))
          expect(page).to have_selector("i.fas.fa-trash-alt")
        end
      end
    end
  end

  
  describe "new page" do
    before do
      visit new_location_path
    end

    it "フォームが表示されること" do
      expect(page).to have_selector("form")
    end

    it "作成ボタンが表示されること" do
      expect(page).to have_button("作成")
    end

    it "戻るリンクが表示されること" do
      expect(page).to have_link("戻る")
    end
  end

  describe "create action" do
    context "有効なデータの場合" do
      let(:location_name) { "現金" }
      let(:asset_name) { "新しい資産" }
      let(:max_expense) { 10000 }

      before do
        visit new_location_path
        fill_in "資産名", with: asset_name
        select location_name, from: "資産場所"
        fill_in "上限金額", with: max_expense
        click_button "作成"
      end

      it "成功メッセージが表示されること" do
        expect(page).to have_content("資産情報を登録しました。")
      end

      it "資産一覧ページにリダイレクトされること" do
        expect(page).to have_current_path(locations_path)
      end

      it "新しい資産が表示されること" do
        expect(page).to have_content(asset_name)
      end
    end

    context "無効なデータの場合" do
      before do
        visit new_location_path
        click_button "作成"
      end

      it "エラーメッセージが表示されること" do
        expect(page).to have_content("資産情報を登録できませんでした。")
      end

      it "フォームが表示されること" do
        expect(page).to have_selector("form")
      end
    end
  end

  describe "edit page" do
    before do
      visit edit_location_path(location)
    end

    context "編集ページの表示について" do
      it "資産名の編集欄が表示されること" do
        expect(page).to have_field("location[asset_name]", with: location.asset_name)
      end
      
      it "資産場所の編集欄が表示されること" do
        expect(page).to have_field("location[location_name]", with: location.location_name)
      end

      it "上限金額の編集欄が表示されること" do
        expect(page).to have_field("location[max_expense]", with: location.max_expense)
      end
    end

    it "更新ボタンが表示されること" do
      expect(page).to have_button("更新")
    end

    it "戻るリンクが表示されること" do
      expect(page).to have_link("戻る")
    end
  end

  describe "update action" do
    context "有効なデータの場合" do
      let(:new_location_name) { "現金" }
      let(:new_asset_name) { "新しい資産" }
      let(:new_max_expense) { 10000 }

      before do
        visit edit_location_path(location)
        fill_in "資産名", with: new_asset_name
        select new_location_name, from: "資産場所"
        fill_in "上限金額", with: new_max_expense
        click_button "更新"
      end

      it "成功メッセージが表示されること" do
        expect(page).to have_content("資産情報を更新しました。")
      end

      it "資産一覧ページにリダイレクトされること" do
        expect(page).to have_current_path(locations_path)
      end

      it "更新された資産が表示されること" do
        expect(page).to have_content(new_asset_name)
      end
    end

    context "無効なデータの場合" do
      before do
        visit edit_location_path(location)
        fill_in "資産名", with: ""
        click_button "更新"
      end

      it "エラーメッセージが表示されること" do
        expect(page).to have_content("資産情報を更新できませんでした。")
      end

      it "フォームが再表示されること" do
        expect(page).to have_selector("form")
      end
    end
  end

  describe "destroy action" do
    it "資産の削除に成功した場合、一覧ページへリダイレクトされること" do
      visit locations_path
      click_link nil, href: location_path(location)
      expect(page).to have_current_path(locations_path)
      expect(page).to have_content("資産情報を削除しました。")
    end
  end
end

