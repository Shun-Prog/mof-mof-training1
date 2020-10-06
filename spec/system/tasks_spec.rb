require 'rails_helper'

RSpec.describe 'Tasks', type: :system do

  describe '一覧' do

    let!(:task){ FactoryBot.create(:task) }
    let!(:task_add_1year){ FactoryBot.create(:task, created_at: Time.now + 1.years) }
    let!(:task_add_1day){ FactoryBot.create(:task, created_at: Time.now + 1.days) }
    let!(:task_add_1hour){ FactoryBot.create(:task, created_at: Time.now + 1.hours) }

    before do
      visit tasks_path
    end
    
    it '一覧で表示される' do
      expect(page).to have_content task.name
      expect(page).to have_content task.created_at
    end

    it '作成日の降順で並ぶ' do

      task_list = page.all('.task')
      id_of_task_created = 'task_created_at'

      expect(task_list[0].find_by_id(id_of_task_created).text).to eq task_add_1year.created_at.to_s # 現在日時 + 1年
      expect(task_list[1].find_by_id(id_of_task_created).text).to eq task_add_1day.created_at.to_s # 現在日時 + 1日
      expect(task_list[2].find_by_id(id_of_task_created).text).to eq task_add_1hour.created_at.to_s # 現在日時 + 1時間
      expect(task_list[3].find_by_id(id_of_task_created).text).to eq task.created_at.to_s # 現在日時
    end
    
  end

  describe '詳細' do

    let!(:task){ FactoryBot.create(:task) }

    it '詳細が表示される' do
      visit task_path(task)
      expect(page).to have_content task.name
      expect(page).to have_content task.description
      expect(page).to have_content task.created_at
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
        expect(page).to have_content /^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}/
        
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
        expect(page).to have_content /^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}/
      end
    end
    
  end

end
