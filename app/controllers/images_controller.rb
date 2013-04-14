class ImagesController < ApplicationController

  #show images list 
  def index
    @imgs = Image.order("id DESC").page(current_page)
    @tags = get_uniq_tags @imgs
  end

  #show current image 
  def show 
    @cur_img = params[:id]
    @tags = Image.find(@cur_img).tags
  end

  private
    #get tags list without dublicates
    def get_uniq_tags image_list = {}
      tags = Tag.includes(:images).where(images: { id: image_list.map { |i| i.id } })
      tags.sort.uniq
    end
end