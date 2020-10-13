# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  admin           :boolean          default(FALSE), not null
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

  validate :admin_validation, if: :will_save_change_to_admin?

  before_save :downcase_email

  private

    def admin_validation
      return if self.admin?
      admin_count = User.where(admin: true).count
      errors.add(:admin, 'は最低1ユーザー保持する必要があります') if admin_count == 1
    end

    def downcase_email
      self.email.downcase! 
    end

end
