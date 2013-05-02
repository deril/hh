class ApplicationController < ActionController::Base
  protect_from_forgery

  def current_page 
    page = (params[:page].to_i > 1) ? params[:page].to_i : 1
  end

  def get_uniq_tags_from(image_list = {})
    all_tags = []
    image_list.map { |image| all_tags += image.tags }
    all_tags.uniq.sort_by { |tag| tag.name }
  end

end
