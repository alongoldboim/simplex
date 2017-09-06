class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def json_return(status, success, data)
    render json:  {
        status: status,
        success: success,
        payload: {
            data: data
        }
    }, status: status
  end
end
