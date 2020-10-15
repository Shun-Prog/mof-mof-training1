require "rails_helper"

shared_examples "500エラーページが表示される" do
  it { expect(page).to have_content "500 Internal Server Error" }
end

RSpec.describe "Errors", type: :system do

  describe "管理者権限が無い場合" do

    let(:non_admin_user) { create(:user, admin: false) }

    context "ユーザー一覧を開いた時" do

      before do
        login(non_admin_user)
        visit admin_users_path
      end
  
      it_behaves_like "500エラーページが表示される"

    end

    context "管理者用タスク一覧を開いた時" do

      before do
        login(non_admin_user)
        visit admin_user_tasks_path(non_admin_user)
      end
  
      it_behaves_like "500エラーページが表示される"

    end
    
  end

  context "不正なパスの場合" do

    let(:user) { create(:user) }

    before do
      login(user)
      visit "/examplepath"
    end

    it "404エラーページが表示される" do
      expect(page).to have_content "404 File Not Found"
    end
    
  end

end
