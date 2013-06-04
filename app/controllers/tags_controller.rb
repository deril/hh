class TagsController < ApplicationController
  
  # TODO: image search also by list of tags
  # TODO: tests!!!!

  def index
    @tags = ActsAsTaggableOn::Tag.page(current_page)
  end

  def show 
    @cur_tag = ActsAsTaggableOn::Tag.find_by_id(params[:id])
    @imgs = Image.includes(:tags).tagged_with(@cur_tag).page(current_page)
    @tags = get_uniq_tags_from(@imgs) if @imgs.present?
  end

end