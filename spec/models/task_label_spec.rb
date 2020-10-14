# == Schema Information
#
# Table name: task_labels
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  label_id   :bigint           not null
#  task_id    :bigint           not null
#
# Indexes
#
#  index_task_labels_on_label_id  (label_id)
#  index_task_labels_on_task_id   (task_id)
#
# Foreign Keys
#
#  fk_rails_...  (label_id => labels.id)
#  fk_rails_...  (task_id => tasks.id)
#
require 'rails_helper'

RSpec.describe TaskLabel, type: :model do

  describe "アソシエーション" do

    describe "belongs_to task" do

      let!(:task) { create(:task) }
      let!(:task_label) { create(:task_label, task: task) }

      it "TaskとTaskLabelは1対多の関係になる" do

        expect(task_label.task).to eq task
      end

    end

    describe "belongs_to label" do

      let!(:label) { create(:label) }
      let!(:task_label) { create(:task_label, label: label) }

      it "LabelとTaskLabelは1対多の関係になる" do
        expect(task_label.label).to eq label
      end

    end

  end

end
