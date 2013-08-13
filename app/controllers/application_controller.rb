class ApplicationController < ActionController::Base
  protect_from_forgery

  def current_page 
    page = (params[:page].to_i > 1) ? params[:page].to_i : 1
  end

  def get_uniq_tags_from(image_list = {}, except_tag = nil)
    all_tags = []
    image_list.map { |image| all_tags += image.tags }
    all_tags.uniq!
    all_tags.delete(except_tag) if except_tag
    all_tags.sort_by { |tag| tag.name }
  end

end
