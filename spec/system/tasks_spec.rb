require "rails_helper"

RSpec.describe "Tasks", type: :system do

  let(:user) { create(:user) }

  describe "一覧" do

    # タスク一覧のtable rowを取得
    let(:rows) { page.all(".task_row") }

    context "初期表示時" do

      let!(:task){ create(:task, user: user) }
      let!(:task_add_1day){ create(:task, created_at: Time.current + 1.days, user: user) }
      let!(:task_labels){ create_pair(:task_label, task: task) }

      before do
        login(user)
      end

      it "一覧で表示される" do
        expect(page).to have_content task.name
        expect(page).to have_content task.status_i18n
        expect(page).to have_content task.priority_i18n
        expect(page).to have_content I18n.l(task.created_at)
        expect(page).to have_content I18n.l(task.expired_at)
        task_labels.each do |task_label|
          expect(page).to have_content task_label.label.name
        end
      end

      it "作成日の降順で並ぶ" do
        expect(rows[0].find(".task_created_at").text).to eq I18n.l(task_add_1day.created_at).to_s
        expect(rows[1].find(".task_created_at").text).to eq I18n.l(task.created_at).to_s
      end

    end

    describe "閲覧範囲のテスト" do

      let(:user_a) { create(:user) }
      let!(:user_a_task) { create(:task, user: user_a) }
      let(:user_b) { create(:user) }
      let!(:user_b_task) { create(:task, user: user_b) }

      context "ユーザーAでログインした時" do

        before do
          login(user_a)
        end

        it "ユーザーAのタスクのみ表示される" do
          expect(page).to have_content user_a_task.name
          expect(page).to have_no_content user_b_task.name
        end

      end

      context "ユーザーBでログインした時" do

        before do
          login(user_b)
        end

        it "ユーザーBのタスクのみ表示される" do
          expect(page).to have_content user_b_task.name
          expect(page).to have_no_content user_a_task.name
        end

      end
    
    end
    
    context "終了期限でソートした時" do

      let!(:task){ create(:task, user: user) }
      let!(:task_add_1day){ create(:task, expired_at: Time.current + 1.days, user: user) }

      before do
        login(user)
      end

      it "昇順で並ぶ" do 
        click_link Task.human_attribute_name(:expired_at)
        sleep 0.5 # DOMを待つ
        expect(rows[0].find(".task_expired_at").text).to eq I18n.l(task.expired_at).to_s
        expect(rows[1].find(".task_expired_at").text).to eq I18n.l(task_add_1day.expired_at).to_s
      end

      it "降順で並ぶ" do
        
        2.times do  # 2回クリックして降順にする
          click_link Task.human_attribute_name(:expired_at)
          sleep 0.5 # DOMを待つ
        end

        expect(rows[0].find(".task_expired_at").text).to eq I18n.l(task_add_1day.expired_at).to_s
        expect(rows[1].find(".task_expired_at").text).to eq I18n.l(task.expired_at).to_s
      end

    end

    context "優先順位でソートした時" do

      let!(:task_priority_low){ create(:task, priority: 0, user: user) }
      let!(:task_priority_high){ create(:task, priority: 2, user: user) }

      before do
        login(user)
      end
 
      it "昇順で並ぶ" do
        click_link Task.human_attribute_name(:priority)
        sleep 0.5 # DOMを待つ
        expect(rows[0].find(".task_priority").text).to eq task_priority_low.priority_i18n
      end

      it "降順で並ぶ" do
        2.times do  # 2回クリックして降順にする
          click_link Task.human_attribute_name(:priority)
          sleep 0.5 # DOMを待つ
        end
        expect(rows[0].find(".task_priority").text).to eq task_priority_high.priority_i18n
      end

    end

    context "タスク名で検索した時" do

      let(:task){ create(:task, user: user) }

      before do
        login(user)
      end

      it "検索した値で表示される" do
        fill_in "q_name_cont", with: task.name
        click_button "検索"
        expect(rows[0].find(".task_name").text).to eq task.name
      end
      
    end

    context "ステータスで検索した時" do

      let!(:task){ create(:task, status: :started, user: user) }

      before do
        login(user)
      end

      it "検索した値で表示される" do
        value = Task.statuses[task.status].to_s
        find("option[value=\'#{value}\']").select_option
        click_button "検索"
        expect(rows[0].find(".task_status").text).to eq task.status_i18n
      end
    end

    context "ラベルで検索した時" do

      let!(:task){ create(:task, user: user) }
      let!(:task_labels){ create_pair(:task_label, task: task) }

      before do
        login(user)
      end

      it "検索した値で表示される" do
        check "q_labels_id_eq_any_#{task_labels[0].label.id}"
        click_button "検索"
        expect(rows[0].find(".task_labels").text).to have_content task_labels[0].label.name
      end
    end

  end

  describe "詳細" do

    let!(:task){ create(:task, user: user) }
    let!(:task_labels){ create_pair(:task_label, task: task) }

    before do
      login(user)
      visit task_path(task)
    end

    it "詳細が表示される" do
      expect(page).to have_content task.name
      expect(page).to have_content task.description
      expect(page).to have_content task.status_i18n
      expect(page).to have_content task.priority_i18n
      expect(page).to have_content I18n.l(task.expired_at)
      expect(page).to have_content I18n.l(task.created_at)
      task_labels.each do |task_label|
        expect(page).to have_content task_label.label.name
      end

    end

  end

  describe "作成" do

    let!(:labels){ create_pair(:label) }

    before do
      login(user)
      visit new_task_path
      fill_in "タスク名",	with: name
      fill_in "タスク詳細",	with: description
      fill_in "終了期限",	with: expired_at
      check "task_label_ids_#{labels[0].id}"
      click_button "保存"
    end

    context "タスク名を入力した時" do

      let(:name) { "タスク名" }
      let(:description) { "タスク詳細" }
      let(:expired_at) { Time.current }

      it "作成できる" do
        expect(page).to have_content name
        expect(page).to have_content description
        expect(page).to have_content I18n.t(:ready, scope: [:enums, :task, :status])
        expect(page).to have_content I18n.t(:low, scope: [:enums, :task, :priority])
        expect(page).to have_selector ".task_expired_at", text: I18n.l(expired_at).to_s
        expect(page).to have_selector ".task_created_at", text: /^\d{4}\/\d{2}\/\d{2} \d{2}:\d{2}/
        expect(page).to have_content labels[0].name
        expect(page).to have_no_content labels[1].name
      end
    end

    context "タスク名を入力しない時" do

      let(:name) { "" }
      let(:description) { "タスク詳細" }
      let(:expired_at) { Time.current }

      it "エラーになる" do
        expect(page).to have_content "タスク名を入力してください"
      end
    end
  end


  describe "編集" do

    let!(:labels){ create_pair(:label) }
    let!(:task){ create(:task, user: user) }

    before do
      login(user)
      visit edit_task_path(task)
      fill_in "タスク名",	with: name
      fill_in "タスク詳細",	with: description
      fill_in "終了期限",	with: expired_at
      check "task_label_ids_#{labels[0].id}"
      click_button "保存"
    end

    context "タスクを編集した時" do
      
      let(:name) { "タスク名(変更後)" }
      let(:description) { "タスク詳細(変更後)" }
      let(:expired_at) { Date.today + 1.day }

      it "編集できる" do
        expect(page).to have_content name
        expect(page).to have_content description
        expect(page).to have_content I18n.t(:ready, scope: [:enums, :task, :status])
        expect(page).to have_content I18n.t(:low, scope: [:enums, :task, :priority])
        expect(page).to have_selector ".task_expired_at", text: I18n.l(expired_at).to_s
        expect(page).to have_selector ".task_created_at", text: /^\d{4}\/\d{2}\/\d{2} \d{2}:\d{2}/
        expect(page).to have_content labels[0].name
        expect(page).to have_no_content labels[1].name
      end
    end
  end
end
