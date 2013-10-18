class DispatchImgsController < ApplicationController
  layout "back_end"

  # TODO: move backend to directory like 'admin'

  before_filter :find_image, only: [:update, :destroy, :edit]

  def index
    page = params[:page] ? params[:page] : 1
    @imgs = Image.desc.page(page)
  end

  def new
    @img = Image.new
    @tags = Tag.order("name ASC").all
  end

  def create
    @img = Image.new(params[:image])
    @img.tag_ids = params[:tag_ids] if params[:tag_ids]
    response = @img.save_with_response
    redirect_to dispatch_imgs_path, response
  end

  # TODO: id was shown ??
  def edit
    @tags = Tag.order("name ASC").all
  end

  def update
    @img.assign_attributes(params[:image])
    @img.tag_ids = params[:tag_ids]
    response = @img.save_with_response
    redirect_to dispatch_imgs_path, response
  end

  def destroy
    response = @img.destroy_with_response
    redirect_to dispatch_imgs_path, response
  end

  private
    def find_image
      @img = Image.find_by_id(params[:id])
      redirect_to dispatch_imgs_path, Image.not_found unless @img
    end
end
