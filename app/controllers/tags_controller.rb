class TagsController < ApplicationController
  
  before_filter :find_tag, only: [:show] 
  
  # TODO: image search also by list of tags

  def index
    @tags = Tag.page(current_page)
  end

  def show 
    @imgs = @cur_tag.images.includes(:tags).page(current_page)
    @tags = get_uniq_tags_from(@imgs, @cur_tag) if @imgs.present?
  end

  private
    def find_tag  
      @cur_tag = Tag.find_by_id(params[:id])
      redirect_to tags_path, Tag.not_found unless @cur_tag
    end

end