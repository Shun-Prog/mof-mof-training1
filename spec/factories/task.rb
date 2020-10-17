FactoryBot.define do
  factory :task do
    association :user
    sequence(:name) { |n| "dummy_name#{n}" }
    sequence(:description) { |n| "dummy_description#{n}" }
    expired_at { Date.today }
  end
end
