class ImagesController < ApplicationController

  def index
    @imgs = Image.includes(:tags).desc.page(current_page)
    @tags = get_uniq_tags_from(@imgs)
  end

  # TODO: may be not id
  def show 
    @img = Image.find(params[:id])
    @tags = @img.tags
  end
  
end