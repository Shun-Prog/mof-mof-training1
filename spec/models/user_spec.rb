# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  admin           :boolean          default(FALSE), not null
#  email           :string
#  name            :string
#  password_digest :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
require "rails_helper"

RSpec.describe User, type: :model do

  describe "アソシエーション" do

    describe "has_many" do

      let!(:user) { create(:user) }
      let!(:tasks) { create_pair(:task, user: user) }

      it "UserとTaskは1対多の関係になる" do
        expect(user.tasks).to match_array tasks
      end

    end

    context "ユーザーを削除した時" do

      let!(:non_admin_user) { create(:user, admin: false) }
      let!(:tasks) { create(:task, user: non_admin_user) }

      it "関連するタスクが削除される" do
        expect{ non_admin_user.destroy }.to change{ Task.count }.by(-1)
      end

    end

  end

  describe "ユーザー名" do

    context "ユーザー名が有る場合" do
      
      let!(:user){ build(:user) }

      it "有効である" do
        expect(user).to be_valid
      end

    end

    context "ユーザー名が無い場合" do
      
      let!(:user){ build(:user, name: "") }

      it "無効である" do
        expect(user).to be_invalid
      end

      it "入力不足のエラーメッセージが出る" do
        user.valid?
        expect(user.errors[:name]).to include("を入力してください")
      end

    end

    context "30文字超過の時" do

      let!(:user){ build(:user, name: "a" * 31) }

      it "無効である" do
        expect(user).to be_invalid
      end

      it "文字数超過のエラーメッセージが出る" do
        user.valid?
        expect(user.errors[:name]).to include("は30文字以内で入力してください")
      end

    end

  end

  describe "メールアドレス" do

    context "メールアドレスが有る場合" do

      let!(:user){ build(:user) }

      it "有効である" do
        expect(user).to be_valid
      end

    end

    context "メールアドレスが無い場合" do

      let!(:user){ build(:user, email: "") }

      it "無効である" do
        expect(user).to be_invalid
      end

      it "入力不足のエラーメッセージが出る" do
        user.valid?
        expect(user.errors[:email]).to include("を入力してください")
      end

    end

    context "メールアドレスが大文字の場合" do

      let!(:user){ create(:user, email: email) }
      let!(:email){ "TEST@EXAMPLE.COM" }

      it "小文字で保存される" do
        expect(user.email).to eq email.downcase
      end

    end

    context "メールアドレスの形式が不正な場合" do

      let!(:user){ build(:user, email: "1234atexample.com") }

      it "無効である" do
        expect(user).to be_invalid
      end

      it "入力不足のエラーメッセージが出る" do
        user.valid?
        expect(user.errors[:email]).to include("は不正な値です")
      end

    end

    context "既存データと重複する場合" do

      let!(:user){ create(:user, email: "duplicate@example.com") }
      let!(:duplicate_user){ build(:user, email: "duplicate@example.com") }

      it "無効である" do
        expect(duplicate_user).to be_invalid
      end

      it "重複のエラーメッセージが出る" do
        duplicate_user.valid?
        expect(duplicate_user.errors[:email]).to include("はすでに存在します")
      end

    end

  end

  describe "パスワード" do

    context "パスワードが有る場合" do

      let!(:user){ build(:user) }

      it "有効である" do
        expect(user).to be_valid
      end

    end

    context "パスワードが無い場合" do

      let!(:user){ build(:user, password: "") }

      it "無効である" do
        expect(user).to be_invalid
      end

      it "入力不足のエラーメッセージが出る" do
        user.valid?
        expect(user.errors[:password]).to include("を入力してください")
      end

    end

    context "7文字以下の時" do

      let!(:user){ build(:user, password: "a" * 7) }

      it "無効である" do
        expect(user).to be_invalid
      end

      it "文字数不足のエラーメッセージが出る" do
        user.valid?
        expect(user.errors[:password]).to include("は8文字以上で入力してください")
      end

    end

    context "確認用パスワードと一致しない時" do

      let!(:user){ build(:user, password: "a" * 8, password_confirmation: "b" * 8) }
      
      it "無効である" do
        expect(user).to be_invalid
      end

      it "不一致のエラーメッセージが出る" do
        user.valid?
        expect(user.errors[:password_confirmation]).to include("とパスワードの入力が一致しません")
      end

    end

  end

  describe "管理者権限" do

    let!(:user){ create(:user) }

    context "管理者が1ユーザーの状態管理者権限を無しにする時" do

      before do
        user.admin = false
        user.valid?
      end
      
      it "無効である" do
        expect(user.errors[:admin]).to include("は最低1ユーザー保持する必要があります")
      end
      
    end

    context "管理者が1ユーザーの状態で削除する時" do

      before do
        user.destroy
      end

      it "無効である" do
        expect(user.errors[:admin]).to include("は最低1ユーザー保持する必要があります")
      end

    end

  end

end
