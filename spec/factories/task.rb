FactoryBot.define do
  factory :task do
    name { 'タスク名' }
    description { 'タスク詳細' }
    status { 'ready' }
    expired_at { Date.today }
  end
end
