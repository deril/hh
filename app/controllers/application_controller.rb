class ApplicationController < ActionController::Base
  protect_from_forgery

  #gets current page
  def current_page 
    page = (params[:page].to_i > 1) ? params[:page].to_i : 1
  end

end
