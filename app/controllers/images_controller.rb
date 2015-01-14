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
    @also_images = few_random_images(@img.warn_id)
  end

  def random
    redirect_to image_path(random_img_id)
  end

  private
    # TODO: take look on view
    # TODO: tests
    def few_random_images(warn_id)
      Image.where(warn_id: warn_id).limit(4)      # TODO: make random
    end

    def find_image
      @img = Image.find_by(id: params[:id])
      redirect_to images_path, { alert: "Can't find such Image." } unless @img
    end

    def random_img_id
      image_count = Image.count
      return image_count if image_count < 1
      Image.where('id >= ?', rand(image_count)).limit(1).first.id
    end
end
