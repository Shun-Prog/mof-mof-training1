require 'rails_helper'

RSpec.describe 'Tasks', type: :system do
  describe '一覧' do
    let(:user) { create(:user) }
    let!(:task) { create(:task, user: user) }

    before do
      login(user)
      visit admin_user_tasks_path(user)
    end

    it 'タスク一覧が表示される' do
      expect(page).to have_content task.name
      expect(page).to have_content task.status_i18n
      expect(page).to have_content task.priority_i18n
      expect(page).to have_content I18n.l(task.expired_at)
      expect(page).to have_content I18n.l(task.created_at)
    end
  end
end
