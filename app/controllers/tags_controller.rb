class TagsController < ApplicationController

  def index
    @tags = Tag.page(current_page)
  end
#TODO -- make image search also by list of tags
  #show images list by current tag
  def show 
    @cur_tag = Tag.joins(:images).find(params[:id])
    @imgs = @cur_tag.images.order("id DESC").page(current_page)
    @tags = get_uniq_tags @imgs
  end

private
  #get tags list without dublicates
  def get_uniq_tags image_list = {}
    tags = Tag.includes(:images).where(images: { id: image_list.map { |i| i.id } })
    tags.sort.uniq
  end
end