# == Schema Information
#
# Table name: tasks
#
#  id          :bigint           not null, primary key
#  description :text
#  expired_at  :datetime
#  name        :string
#  priority    :integer          default("low")
#  status      :integer          default("ready")
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint
#
# Indexes
#
#  index_tasks_on_status   (status)
#  index_tasks_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Task, type: :model do

  describe 'アソシエーション' do

    describe 'belongs_to' do
      let!(:user) { create(:user) }
      let!(:task) { create(:task, user_id: user.id) }

      it 'TaskとUserは1対多の関係になる' do
        expect(task.user).to eq user
      end

    end
  end

  describe 'タスク名のバリデーション' do

    context 'タスク名が無い場合' do
      
      let!(:task){ build(:task, name: "") }

      it '無効である' do
        expect(task).to be_invalid
      end

      it '入力不足のエラーメッセージが出る' do
        task.valid?
        expect(task.errors[:name]).to include('を入力してください')
      end

    end
  
    context 'タスク名が31文字以上の場合' do

      let!(:task){ build(:task, name: 'a' * 31) }
  
      it '無効である' do
        expect(task).to be_invalid
      end
  
      it '文字数超過のエラーメッセージが出る' do
        task.valid?
        expect(task.errors[:name]).to include('は30文字以内で入力してください')
      end
  
    end
  
    context 'タスク名が30文字以内の場合' do
      
      let!(:task){ build(:task, name: 'a' * 30) }
  
      it '有効である' do
        expect(task).to be_valid
      end
  
    end
  end


  describe 'タスク詳細のバリデーション' do

    context 'タスク詳細が無い場合' do

      let!(:task){ build(:task, description: '') }
  
      it '無効である' do
        expect(task).to be_invalid
      end
  
      it '入力不足のエラーメッセージが出る' do
        task.valid?
        expect(task.errors[:description]).to include('を入力してください')
      end

    end

    context 'タスク詳細が1001文字以上の場合' do

      let!(:task){ build(:task, description: 'a' * 1001) }
  
      it '無効である' do
        expect(task).to be_invalid
      end
  
      it '文字数超過のエラーメッセージが出る' do
        task.valid?
        expect(task.errors[:description]).to include('は1000文字以内で入力してください')
      end
      
    end

    context 'タスク詳細が1000文字以内の場合' do

      let!(:task){ build(:task, description: 'a' * 1000) }
  
      it '有効である' do
        expect(task).to be_valid
      end
  
    end
  end

  describe '終了期限' do
    context '終了期限が無い場合' do

      let!(:task){ build(:task, expired_at: nil) }
  
      it '無効である' do
        expect(task).to be_invalid
      end
  
      it '入力不足のエラーメッセージが出る' do
        task.valid?
        expect(task.errors[:expired_at]).to include('は現在日以降の日付を入力してください')
      end

    end

    context '終了期限が現在日より過去の日付の場合' do

      let!(:task){ build(:task, expired_at: Date.today - 1.day) }
  
      it '無効である' do
        expect(task).to be_invalid
      end
  
      it '入力不足のエラーメッセージが出る' do
        task.valid?
        expect(task.errors[:expired_at]).to include('は現在日以降の日付を入力してください')
      end

    end
  end

  describe 'ステータス' do
    context '初期状態' do

      let!(:task){ build(:task) }
  
      it '未着手(ready)である' do
        expect(task.status).to eq 'ready'
      end

    end
  end

  describe '優先順位' do
    context '初期状態' do

      let!(:task){ build(:task) }
  
      it '低(low)である' do
        expect(task.priority).to eq 'low'
      end

    end
  end

end
