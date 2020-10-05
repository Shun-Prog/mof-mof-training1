require 'rails_helper'

RSpec.describe 'Tasks', type: :system do

  describe '一覧' do

    let!(:task){ FactoryBot.create(:task) }

    it '一覧で表示される' do
      visit tasks_path
      expect(page).to have_content task.name
    end
    
  end

  describe '詳細' do

    let!(:task){ FactoryBot.create(:task) }

    it '詳細が表示される' do
      visit tasks_path(task)
      expect(page).to have_content task.name
      expect(page).to have_content task.description
    end

  end

  describe '作成' do

    before do
      visit new_task_path
      fill_in 'タスク名',	with: name
      fill_in 'タスク詳細',	with: description
      click_button '保存'
    end

    context 'タスク名を入力した時' do
      let(:name) { 'タスク名' }
      let(:description) { 'タスク詳細' }

      it '作成できる' do
        expect(page).to have_content name
        expect(page).to have_content description
      end
    end

    context 'タスク名を入力しない時' do
      let(:name) { '' }
      let(:description) { 'タスク詳細' }

      it 'エラーになる' do
        expect(page).to have_content 'タスク名を入力してください'
      end
    end
    
  end


  describe '編集' do

    let!(:task){ FactoryBot.create(:task) }

    before do
      visit edit_task_path(task)
      fill_in 'タスク名',	with: name
      fill_in 'タスク詳細',	with: description
      click_button '保存'
    end

    context 'タスク名編集した時' do
      let(:name) { 'タスク名(変更後)' }
      let(:description) { 'タスク詳細(変更後)' }

      it '編集できる' do
        expect(page).to have_content name
        expect(page).to have_content description
      end
    end
    
  end

end
