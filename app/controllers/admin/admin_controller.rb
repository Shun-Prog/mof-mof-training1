class Admin::AdminController < ApplicationController
  before_action :require_admin

  def require_admin
    if controller_path.start_with?('admin') && !current_user.admin?
      raise CustomExceptions::NotAuthorizedError, '管理者権限がありません'
    end
  end # 管理者権限が無い場合は例外を投げる
end
