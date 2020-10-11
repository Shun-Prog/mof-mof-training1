require 'rails_helper'

RSpec.describe 'Sessions', type: :system do

  describe 'ログイン' do

    context "ログインできるユーザーが存在する時" do

      let(:user) { create(:user) }

      before do
        login(user)
      end

      it 'ログインできる' do
        expect(page).to have_content "ログインしました"
      end

    end

    context "ログインできるユーザーが存在しない時" do

      let(:user) { build(:user) }

      before do
        login(user)
      end

      it 'ログインできない' do
        expect(page).to have_content "ログインできませんでした"
      end

    end
 
  end

  describe 'ログアウト' do

    let(:user) { create(:user) }

    before do
      login(user)
      click_link 'ログアウト'
    end

    it 'ログアウトできる' do
        expect(page).to have_content "ログアウトしました"
    end
  end

end
