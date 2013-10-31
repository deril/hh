class TagsController < ApplicationController
  
  # TODO: image search also by list of tags

  def index
    @tags = Tag.page(current_page)
  end

  def show 
    @cur_tag = Tag.find(params[:id])
    @imgs = @cur_tag.images.includes(:tags).page(current_page)
    @tags = get_uniq_tags_from(@imgs, @cur_tag) if @imgs.present?
  end

end