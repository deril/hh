class ImagesController < ApplicationController

  # TODO: tests!!!!

  def index
    @imgs = Image.desc.page(current_page)
    @tags = get_uniq_tags_from(@imgs)
  end

  # may be not id
  def show 
    @img = Image.find_by_id(params[:id])
    @tags = @img.try(:tags)
  end

end