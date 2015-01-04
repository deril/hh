class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :make_current_admin

  def make_current_admin
    @current_admin = current_admin if admin_signed_in?
  end

  def current_page
    page = (params[:page].to_i > 1) ? params[:page].to_i : 1
  end

  def add_all_warns
    @warns = Warn.all.load.reverse
  end

  def get_uniq_tags_from(image_list = [], except_tag = nil)
    all_tags = Tag.joins(:images).where(images: { id: image_list.map(&:id) })
    all_tags = all_tags.where("tags.id != ?", except_tag.id) if except_tag
    all_tags.uniq
  end

  def hh_authenticate_admin!
    raise ActionController::RoutingError.new('Not Found') unless admin_signed_in?
  end
end
