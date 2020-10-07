require 'rails_helper'

RSpec.describe 'Tasks', type: :system do

  describe '一覧' do

    let!(:task){ FactoryBot.create(:task, expired_at: Time.now.next_year) }
    let!(:task_add_1year){ FactoryBot.create(:task, expired_at: Time.now.next_year + 1.years, created_at: Time.now + 1.years) }
    let!(:task_add_1day){ FactoryBot.create(:task, expired_at: Time.now.next_year + 1.days, created_at: Time.now + 1.days) }
    let!(:task_add_1hour){ FactoryBot.create(:task, expired_at: Time.now.next_year + 1.hours, created_at: Time.now + 1.hours) }

    # タスク一覧のtable rowを取得
    let(:rows) { page.all('.task_row') }

    before do
      visit tasks_path
    end
    
    it '一覧で表示される' do
      expect(page).to have_content task.name
      expect(page).to have_content task.status_i18n
      expect(page).to have_content task.created_at
      expect(page).to have_content task.expired_at
    end

    it '作成日の降順で並ぶ' do
      expect(rows[0].find('.task_created_at').text).to eq task_add_1year.created_at.to_s # 現在日時 + 1年
      expect(rows[1].find('.task_created_at').text).to eq task_add_1day.created_at.to_s # 現在日時 + 1日
      expect(rows[2].find('.task_created_at').text).to eq task_add_1hour.created_at.to_s # 現在日時 + 1時間
      expect(rows[3].find('.task_created_at').text).to eq task.created_at.to_s # 現在日時
    end

    it '終了期限の降順で並ぶ' do
      click_link '▼'
      sleep 0.5 # DOMを待つ
      expect(rows[0].find('.task_expired_at').text).to eq task_add_1year.expired_at.to_s # 現在日時 + 1年
      expect(rows[1].find('.task_expired_at').text).to eq task_add_1day.expired_at.to_s # 現在日時 + 1日
      expect(rows[2].find('.task_expired_at').text).to eq task_add_1hour.expired_at.to_s # 現在日時 + 1時間
      expect(rows[3].find('.task_expired_at').text).to eq task.expired_at.to_s # 現在日時
    end

    it '終了期限の昇順で並ぶ' do
      click_link '▲'
      sleep 0.5 # DOMを待つ
      expect(rows[0].find('.task_expired_at').text).to eq task.expired_at.to_s # 現在日時
      expect(rows[1].find('.task_expired_at').text).to eq task_add_1hour.expired_at.to_s # 現在日時 + 1時間
      expect(rows[2].find('.task_expired_at').text).to eq task_add_1day.expired_at.to_s # 現在日時 + 1日
      expect(rows[3].find('.task_expired_at').text).to eq task_add_1year.expired_at.to_s # 現在日時 + 1年
    end

  end

  describe '詳細' do

    let!(:task){ FactoryBot.create(:task) }

    it '詳細が表示される' do
      visit task_path(task)
      expect(page).to have_content task.name
      expect(page).to have_content task.description
      expect(page).to have_content task.status_i18n
      expect(page).to have_content task.expired_at
      expect(page).to have_content task.created_at
    end

  end

  describe '作成' do

    before do
      visit new_task_path
      fill_in 'タスク名',	with: name
      fill_in 'タスク詳細',	with: description
      fill_in '終了期限',	with: expired_at
      click_button '保存'
    end

    context 'タスク名を入力した時' do
      let(:name) { 'タスク名' }
      let(:description) { 'タスク詳細' }
      let!(:expired_at) { Time.zone.parse('2020-12-01 00:00:00') }

      it '作成できる' do
        expect(page).to have_content name
        expect(page).to have_content description
        expect(page).to have_content I18n.t("enums.task.status.ready")
        expect(page).to have_selector '.task_expired_at', text: expired_at.to_s
        expect(page).to have_selector '.task_created_at', text: /^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}/
        
      end
    end

    context 'タスク名を入力しない時' do
      let(:name) { '' }
      let(:description) { 'タスク詳細' }
      let(:expired_at) { Time.now }

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
      fill_in '終了期限',	with: expired_at
      click_button '保存'
    end

    context 'タスク名編集した時' do
      let(:name) { 'タスク名(変更後)' }
      let(:description) { 'タスク詳細(変更後)' }
      let(:expired_at) { Time.zone.parse('2020-12-01 00:00:00') }

      it '編集できる' do
        expect(page).to have_content name
        expect(page).to have_content description
        expect(page).to have_content I18n.t("enums.task.status.ready")
        expect(page).to have_selector '.task_expired_at', text: expired_at.to_s
        expect(page).to have_selector '.task_created_at', text: /^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}/
      end
    end
  end
end
