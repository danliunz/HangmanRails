class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  rescue_from ActiveRecord::RecordNotFound, with: :show_missing_record_error
  
  private
  
  def show_missing_record_error(exception)
    @exception = exception
    render template: "errors/missing_record"
  end
end
