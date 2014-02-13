class DispatchImgsController < ApplicationController
  layout "back_end"

  before_action :authenticate_admin!
  before_action :find_image, only: [:update, :destroy, :edit]
  before_action :add_warns, only: [:new, :edit]

  def index
    page = params[:page] ? params[:page] : 1
    @imgs = Image.desc.page(page)
  end

  def new
    @img = Image.new
    @tags = Tag.order("name ASC")
  end

  def create
    @img = Image.new(image_params)
    if @img.save
      redirect_to dispatch_imgs_path, notice: 'Image was successfully created'
    else
      render :new
    end
  end

  # TODO: id was shown ??
  def edit
    @tags = Tag.order("name ASC")
  end

  def update
    if @img.update(image_params)
      redirect_to dispatch_imgs_path, notice: 'Image was successfully updated'
    else
      render :edit
    end
  end

  def destroy
    response = @img.destroy_with_response
    redirect_to dispatch_imgs_path, response
  end

  private
    def find_image
      @img = Image.find_by(id: params[:id])
      redirect_to dispatch_imgs_path, Image.not_found unless @img
    end

    def image_params
      params.fetch(:image, {}).permit(:image, :warn_id, tag_ids: [])
      # params.require(:image).premit(:image,:images_tags, :tag_ids, :warn_id)
    end

end
