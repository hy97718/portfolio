require 'rails_helper'

RSpec.describe "Users", type: :system do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  
  describe "show page" do
    context "ログインしている時" do
      before do
        sign_in user
        visit user_path(user)
      end

      context "ユーザー情報が表示されること" do
        it "ユーザー名が表示されること" do
          expect(page).to have_content(user.username)
        end

        it "メールアドレスが表示されること" do
          expect(page).to have_content(user.email)
        end

        it "目標貯金額が表示されること" do
          expect(page).to have_content("#{user.savings_target.to_s(:delimited)}円")
        end
      end

      it "他のユーザーの詳細ページは表示されないこと" do
        visit user_path(another_user)
        expect(page).to have_current_path(user_path(user))
        expect(page).to have_content("不正なアクセスです")
      end
    end
  end

  describe "edit page" do
    context "ログインしている時" do
      before do
        sign_in user
        visit edit_user_path(user)
      end

      context "編集ページの表示について" do
        it "ユーザー名の編集欄が表示されること" do
          expect(page).to have_field("user[username]", with: user.username)
        end
        
        it "目標貯金額の編集欄が表示されること" do
          expect(page).to have_field("user[savings_target]", with: user.savings_target.to_s)
        end
      end

      it "他のユーザーの編集ページは表示されないこと" do
        visit edit_user_path(another_user)
        expect(page).to have_current_path(user_path(user))
        expect(page).to have_content("不正なアクセスです")
      end
    end
  end

  describe "personal information edit page" do
    context "ログインしている時" do
      before do
        sign_in user
        visit user_personal_information_edit_path(user)
      end

      context "編集ページの表示について" do
        it "メールアドレスの編集欄が表示されること" do
          expect(page).to have_field("user[email]", with: user.email)
        end

        it "現在のパスワードが表示されないこと" do
          expect(page).not_to have_content(user.password)
        end
        
        it "パスワードの編集欄が表示されること" do
          expect(page).to have_field("user_password", type: "password")
        end
      end

      it "他のユーザーの個人情報編集ページが表示されないこと" do
        visit user_personal_information_edit_path(another_user)
        expect(page).to have_current_path(user_path(user))
        expect(page).to have_content("不正なアクセスです")
      end
    end
  end

  describe "update" do
    context "ログインしている時" do
      before do
        sign_in user
      end

      it "ユーザ情報の更新ができること" do
        visit edit_user_path(user)
        fill_in "user_username", with: "New Username"
        fill_in "user_savings_target", with: 5000
        click_button "更新"
        expect(page).to have_content("プロフィール情報を更新しました。")
        expect(page).to have_content("New Username")
        expect(page).to have_content("5,000円")
      end

      it "ユーザー個人情報の編集ができること" do
        visit user_personal_information_edit_path(user)
        fill_in "メールアドレス", with: "new_email@example.com"
        fill_in "新しいパスワードを入力してください", with: "newpassword"
        fill_in "確認のため新しいパスワードを入力してください", with: "newpassword"
        click_button "更新"
        expect(page).to have_content("アカウント情報を更新しました。")
        expect(page).to have_content("new_email@example.com")
      end
    end
  end

  describe "destroy" do
    context "ログインしているとき" do
      before do
        sign_in user
        visit user_path(user)
      end

      it "ユーザーの削除ができること" do
        find('.dropdown_btn').click
        click_link "退会"
        expect(page).to have_current_path(root_path)
        expect(page).to have_content("ユーザー情報を削除しました。")
      end
    end
  end

  describe "guest user" do
    let(:guest_user) { create(:guest_user) }

    it "詳細ページの表示がされないこと" do
      visit user_path(guest_user)
      expect(page).to have_current_path(root_path)
      expect(page).to have_content("ゲストユーザーの編集,削除はできません")
    end

    it "編集ページの表示がされないこと" do
      visit edit_user_path(guest_user)
      expect(page).to have_current_path(root_path)
      expect(page).to have_content("ゲストユーザーの編集,削除はできません")
    end

    it "個人情報編集ページの表示がされないこと" do
      visit user_personal_information_edit_path(guest_user)
      expect(page).to have_current_path(root_path)
      expect(page).to have_content("ゲストユーザーの編集,削除はできません")
    end
  end
end
