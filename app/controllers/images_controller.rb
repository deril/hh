class ImagesController < ApplicationController

  before_filter :find_image, only: [:show]

  def index
    @imgs = Image.includes(:tags).desc.page(current_page)
    @tags = get_uniq_tags_from(@imgs)
    @warns = Warn.all
  end

  # TODO: may be not id
  def show
    @tags = @img.tags
    @warns = Warn.all
    @selected_warn = @img.warn.try(:id)
  end

  private
    def find_image
      @img = Image.find_by_id(params[:id])
      redirect_to images_path, Image.not_found unless @img
    end

end
