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
FactoryBot.define do
  factory :task_label do
    association :task
    association :label
  end
end
