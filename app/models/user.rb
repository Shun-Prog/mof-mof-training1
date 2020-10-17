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

  before_validation :downcase_email

  validates :name, presence: true, length: { maximum: 30 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email,
            presence: true,
            format: VALID_EMAIL_REGEX,
            uniqueness: { case_sensitive: false }

  validates :password, presence: true, length: { minimum: 8 }

  validate :admin_change_validation,
           if: -> { will_save_change_to_admin? && !self.admin? }

  before_destroy :admin_destory_validation, if: -> { self.admin? }

  private

  def admin_change_validation
    set_admin_error_message if last_one_admin?
  end

  def admin_destory_validation
    if last_one_admin?
      set_admin_error_message
      throw(:abort)
    end
  end

  def last_one_admin?
    User.where(admin: true).count == 1
  end

  def set_admin_error_message
    errors.add(:admin, 'は最低1ユーザー保持する必要があります')
  end

  def downcase_email
    self.email.downcase!
  end
end
