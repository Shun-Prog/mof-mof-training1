require "rails_helper"

RSpec.describe "Users", type: :system do

  let(:user) { create(:user) }
  let(:task) { create(:task, user: user) }

  describe "一覧" do

    context "管理者ユーザーの場合" do

      before do
        login(user)
        visit admin_users_path
      end

      it "ユーザー一覧が表示される" do
        expect(page).to have_content user.name
        expect(page).to have_content user.email
        expect(page).to have_content user.tasks.count
        expect(page).to have_content user.admin? ? "有り" : "無し"
      end

    end

    context "管理者権限の無いユーザーの場合" do

      let(:non_admin_user) { create(:user, admin: false) }

      before do
        login(non_admin_user)
        visit admin_users_path
      end

      it "500エラーページが表示される" do
        expect(page).to have_content "500 Internal Server Error"
      end

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
      expect(page).to have_content user.admin? ? "有り" : "無し"
    end
    
  end

  describe "作成" do

    before do
      login(user)
      visit new_admin_user_path
      fill_in "user_name",	with: name
      fill_in "user_email",	with: email
      fill_in "user_password",	with: password
      fill_in "user_password_confirmation",	with: password
      uncheck "user_admin"
      click_button "保存"
    end

    context "作成した時" do

      let(:name) { "ユーザー名" }
      let(:email) { "test@example.com" }
      let(:password) { "12345678" }

      it "ユーザーを作成できる" do
        expect(page).to have_content name
        expect(page).to have_content email
        expect(page).to have_content "無し"
      end

    end

  end

  describe "編集" do

    before do
      login(user)
      visit edit_admin_user_path(user)
      fill_in "user_name",	with: name
      fill_in "user_email",	with: email
      fill_in "user_password",	with: password
      fill_in "user_password_confirmation",	with: password
    end

    context "編集した時" do

      let(:name) { "ユーザー名(変更語)" }
      let(:email) { "test_modified@example.com" }
      let(:password) { "12345678" }

      it "ユーザーを編集できる" do
        click_button "保存"
        expect(page).to have_content name
        expect(page).to have_content email
        expect(page).to have_content "有り"
      end

    end

    context "管理者ユーザー2人以上の状態で管理者権限を外した時" do

      let!(:admin_user) { create(:user) }

      let(:name) { "ユーザー名(変更語)" }
      let(:email) { "test_modified@example.com" }
      let(:password) { "12345678" }

      before do
        uncheck "user_admin"
        click_button "保存"
      end

      it "500エラーページが表示される" do
        expect(page).to have_content "500 Internal Server Error"
      end

    end

    context "管理者ユーザー1人の状態で管理者権限を外した時" do

      let(:name) { "ユーザー名(変更語)" }
      let(:email) { "test_modified@example.com" }
      let(:password) { "12345678" }

      before do
        uncheck "user_admin"
        click_button "保存"
      end

      it "エラーになる" do
        expect(page).to have_content "は最低1ユーザー保持する必要があります"
      end
      
    end
    
  end

  describe "削除" do

    context "管理者ユーザー以外を削除した場合" do

      let!(:non_admin_user) { create(:user, admin: false) }

      before do
        login(user)
        visit admin_user_path(non_admin_user)
        page.accept_confirm do
          click_on "削除"
        end
      end
  
      it "ユーザーを削除できる" do
        expect(page).to have_content "ユーザーを削除しました"
      end
      
    end

    context "管理者ユーザー2人以上の状態で管理者を削除した場合" do

      let!(:admin_user) { create(:user) }

      before do
        login(user)
        visit admin_user_path(admin_user)
        page.accept_confirm do
          click_on "削除"
        end
      end
  
      it "ユーザーを削除できる" do
        expect(page).to have_content "ユーザーを削除しました"
      end
      
    end

    context "管理者ユーザー1人の状態で管理者を削除した場合" do

      before do
        login(user)
        visit admin_user_path(user)
        page.accept_confirm do
          click_on "削除"
        end
      end
  
      it "エラーになる" do
        expect(page).to have_content "は最低1ユーザー保持する必要があります"
      end

    end

  end

end
