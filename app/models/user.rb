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
class User < ApplicationRecord
  has_secure_password
  has_many :tasks, dependent: :destroy

  validates :name,
    presence: true,
    length: { maximum: 30 }
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email,
    presence: true,
    format: VALID_EMAIL_REGEX,
    uniqueness: { case_sensitive: false }

  validates :password,
    presence: true,
    length: { minimum: 8 }

  before_save do
    self.email.downcase! # メールアドレスは小文字で統一 
  end

end
