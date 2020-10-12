# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  email           :string
#  name            :string
#  password_digest :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "dummy_name#{n}"}
    sequence(:email) { |n| "dummy#{n}@example.com"}
    password { "12345678" }
  end
end
