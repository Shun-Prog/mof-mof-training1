require "rails_helper"

RSpec.describe "Users", type: :system do

  let(:user) { create(:user) }
  let(:task) { create(:task, user: user) }

  describe "一覧" do

    before do
      login(user)
      visit admin_users_path
    end

    it "ユーザー一覧が表示される" do
      expect(page).to have_content user.name
      expect(page).to have_content user.email
      expect(page).to have_content user.tasks.count
    end

  end

  describe "詳細" do

    before do
      login(user)
      visit admin_user_path(user)
    end

    it "ユーザー詳細が表示される" do
      expect(page).to have_content user.name
      expect(page).to have_content user.email
    end
    
  end

  describe "作成" do

    before do
      login(user)
      visit new_admin_user_path
      fill_in "user_name",	with: name
      fill_in "user_email",	with: email
      fill_in "user_password",	with: "12345678"
      click_button "保存"
    end

    context "作成した時" do

      let(:name) { "ユーザー名" }
      let(:email) { "test@example.com" }

      it "ユーザーを作成できる" do
        expect(page).to have_content name
        expect(page).to have_content email
      end

    end

  end

  describe "編集" do

    before do
      login(user)
      visit edit_admin_user_path(user)
      fill_in "user_name",	with: name
      fill_in "user_email",	with: email
      fill_in "user_password",	with: "12345678"
      click_button "保存"
    end

    context "編集した時" do

      let(:name) { "ユーザー名(変更語)" }
      let(:email) { "test_modified@example.com" }

      it "ユーザーを編集できる" do
        expect(page).to have_content name
        expect(page).to have_content email
      end

    end
      
  end

  describe "削除" do

    before do
      login(user)
      visit admin_user_path(user)
      page.accept_confirm do
        click_on "削除"
      end
    end

    it "ユーザーを削除できる" do
      expect(page).to have_content "ユーザーを削除しました"
    end

  end

end
