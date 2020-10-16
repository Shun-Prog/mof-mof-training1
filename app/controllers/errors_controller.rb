class ErrorsController < ActionController::Base
  include CustomExceptions;

  rescue_from StandardError, with: :render_500
  rescue_from ActionController::RoutingError, with: :render_404
  rescue_from NotAuthorizedError, with: :render_403

  def render_403(exception = nil)
    if exception
      logger.info "Rendering 403 with exception: #{exception.message}"
    end
    renderer 403
  end

  def render_404(exception = nil)
    if exception
      logger.info "Rendering 404 with exception: #{exception.message}"
    end
    renderer 404
  end

  def render_500(exception = nil)
    if exception
      logger.info "Rendering 500 with exception: #{exception.message}"
    end
    renderer 500
  end

  def renderer(status)
    render template: "errors/error_#{status}", status: status, layout: 'application'
  end

  def show
    raise request.env["action_dispatch.exception"]
  end

end
