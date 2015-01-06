class ImagesController < ApplicationController

  before_action :find_image,    only: [:show]
  before_action :add_all_warns, only: [:index, :show]

  def index
    @imgs = Image.desc.page(current_page)
    @tags = get_uniq_tags_from(@imgs)
    @cur_page_num = current_page.to_s
  end

  def show
    @tags = @img.tags
  end

  private
    def find_image
      @img = Image.find_by(id: params[:id])
      redirect_to images_path, { alert: "Can't find such Image." } unless @img
    end

end
