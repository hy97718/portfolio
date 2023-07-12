require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe 'GET #show' do
    context 'ログインしている時' do
      let(:user) { create(:user) }
      let(:another_user) { create(:another_user) }

      before do
        sign_in user
        get user_path(user)
      end

      it '正常にレスポンスを返すこと' do
        expect(response).to have_http_status(200)
      end

      it '他のユーザーの詳細ページにはアクセスできないこと' do
        get user_path(another_user)
        expect(response).to redirect_to(user_path(user))
        expect(flash[:alert]).to eq('不正なアクセスです')
      end

      context '@userが取得できること' do
        it 'usernameが取得できること' do
          expect(response.body).to include(user.username)
        end

        it 'emailが取得できること' do
          expect(response.body).to include(user.email)
        end

        it 'savings_targetが取得できること' do
          expect(response.body).to include(user.savings_target.to_s)
        end
      end
    end
  end

  describe 'GET #edit' do
    context 'ログインしている時' do
      let(:user) { create(:user) }
      let(:another_user) { create(:another_user) }

      before do
        sign_in user
        get edit_user_path(user)
      end

      it '正常にレスポンスを返すこと' do
        expect(response).to have_http_status(200)
      end

      it '他のユーザーの編集ページにはアクセスできないこと' do
        get edit_user_path(another_user)
        expect(response).to redirect_to(user_path(user))
        expect(flash[:alert]).to eq('不正なアクセスです')
      end

      context '@userが取得できること' do
        it 'usernameが取得できること' do
          expect(response.body). to include(user.username)
        end
        it 'savings_targetが取得できること' do
          expect(response.body). to include(user.savings_target.to_s)
        end
      end
    end
  end

  describe 'GET #personal_information_edit' do
    context 'ログインしている時' do
      let(:user) { create(:user) }
      let(:another_user) { create(:another_user) }

      before do
        sign_in user
        get user_personal_information_edit_path(user)
      end

      it '正常にレスポンスを返すこと' do
        expect(response).to have_http_status(200)
      end

      it '他のユーザーの個人情報編集ページにはアクセスできないこと' do
        get user_personal_information_edit_path(another_user)
        expect(response).to redirect_to(user_path(user))
        expect(flash[:alert]).to eq('不正なアクセスです')
      end

      context '@userが取得できること' do
        it 'emailが取得できること' do
          expect(response.body). to include(user.email)
        end
      end
    end
  end

  describe 'GET #show' do
    context 'ゲストユーザーでログインしている時' do
      let(:guest_user) { create(:guest_user) }
  
      before do
        sign_in guest_user
      end
  
      it 'ゲストユーザーが編集ページにアクセスできないこと' do
        get user_path(guest_user)
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('ゲストユーザーの編集,削除はできません')
      end
    end
  end

  describe 'GET #edit' do
    context 'ゲストユーザーでログインしている時' do
      let(:guest_user) { create(:guest_user) }
  
      before do
        sign_in guest_user
      end
  
      it 'ゲストユーザーが編集ページにアクセスできないこと' do
        get edit_user_path(guest_user)
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('ゲストユーザーの編集,削除はできません')
      end
    end
  end
  
  describe 'GET #personal_information_edit' do
    context 'ゲストユーザーとしてログインしている時' do
      let(:guest_user) { create(:guest_user) }
  
      before do
        sign_in guest_user
      end
  
      it 'ゲストユーザーが個人情報編集ページにアクセスできないこと' do
        get user_personal_information_edit_path(guest_user)
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('ゲストユーザーの編集,削除はできません')
      end
    end
  end
end
