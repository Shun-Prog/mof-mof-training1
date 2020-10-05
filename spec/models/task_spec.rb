require 'rails_helper'

RSpec.describe Task, type: :model do

  describe 'タスク名のバリデーション' do

    context 'タスク名が無い場合' do
      task = Task.new(description: 'description')
  
      it '無効である' do
        expect(task).to be_invalid
      end

      it "can't be blankとエラーメッセージが出る" do
        task.valid?
        expect(task.errors[:name]).to include("can't be blank")
      end

    end
  
    context 'タスク名が31文字以上の場合' do
      task = Task.new(name: 'a' * 31, description: 'description')
  
      it '無効である' do
        expect(task).to be_invalid
      end
  
      it "is too long~ とエラーメッセージが出る" do
        task.valid?
        expect(task.errors[:name]).to include("is too long (maximum is 30 characters)")
      end
  
    end
  
    context 'タスク名が30文字以内の場合' do
      task = Task.new(name: 'a' * 30, description: 'description')
  
      it '有効である' do
        expect(task).to be_valid
      end
  
    end
  end


  describe 'タスク詳細のバリデーション' do

    context 'タスク詳細が無い場合' do
      task = Task.new(name: 'name')
  
      it '無効である' do
        expect(task).to be_invalid
      end
  
      it "can't be blankとエラーメッセージが出る" do
        task.valid?
        expect(task.errors[:description]).to include("can't be blank")
      end

    end

    context 'タスク詳細が1001文字以上の場合' do
      task = Task.new(name: 'name', description: 'a' * 1001)
  
      it '無効である' do
        expect(task).to be_invalid
      end
  
      it "is too long~ とエラーメッセージが出る" do
        task.valid?
        expect(task.errors[:description]).to include("is too long (maximum is 1000 characters)")
      end
    end

    context 'タスク詳細が1000文字以内の場合' do
      task = Task.new(name: 'name', description: 'a' * 1000)
  
      it '有効である' do
        expect(task).to be_valid
      end
  
    end
  end
end
