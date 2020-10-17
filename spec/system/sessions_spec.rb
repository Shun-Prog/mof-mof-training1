require 'rails_helper'

RSpec.describe 'Sessions', type: :system do
  context 'ログイン時' do
    before { login(user) }

    context 'ログインできるユーザーが存在する時' do
      let(:user) { create(:user) }

      it 'ログインできる' do
        expect(page).to have_content 'ログインしました'
      end
    end

    context 'ログインできるユーザーが存在しない時' do
      let(:user) { build(:user) }

      it 'ログインできない' do
        expect(page).to have_content 'ログインできませんでした'
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
      expect(page).to have_content 'ログアウトしました'
    end
  end
end
