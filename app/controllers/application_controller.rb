class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  rescue_from ActiveRecord::ActiveRecordError, with: :show_db_error
  
  private
  
  def show_db_error(exception)
    @exception = exception
    render template: "errors/db_error"
  end
end
