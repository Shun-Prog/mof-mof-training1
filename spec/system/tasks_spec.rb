require 'rails_helper'

RSpec.describe 'Tasks', type: :system do

  describe '一覧' do

    # 順番のテストのため、順序をバラバラに作成 letの名前を日付の降順で命名
    let!(:task_order1){ FactoryBot.create(:task, created_at: Time.now + 1.days) }
    let!(:task_order0){ FactoryBot.create(:task, created_at: Time.now + 1.years) }
    let!(:task_order2){ FactoryBot.create(:task, created_at: Time.now + 1.hours) }
    let!(:task_order3){ FactoryBot.create(:task) }

    before do
      visit tasks_path
    end
    
    it '一覧で表示される' do
      expect(page).to have_content task_order0.name
      expect(page).to have_content task_order0.created_at
    end

    it '作成日の降順で並ぶ' do
      page.all(".task").each_with_index do | task, idx | 
        display_text = task.find_by_id('task_created_at').text
        expect(display_text).to eq eval("task_order#{idx}").created_at.to_s
      end
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
