class Admin::AdminController < ApplicationController
  before_action :require_admin

  def require_admin
    # 管理者権限が無い場合は例外を投げる
    raise CustomExceptions::NotAuthorizedError, "管理者権限がありません" if controller_path.start_with?("admin") && !current_user.admin?
  end
  
end
