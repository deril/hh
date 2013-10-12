class DispatchImgsController < ApplicationController
  layout "back_end"

  # TODO: tests!!!!!!!!!
  # TODO: !!!! can't add tags
  # TODO: may be hook for rename_image! !!!!!!
  # TODO: refact

  def index
    page = params[:page] ? params[:page] : 1
    @imgs = Image.desc.page(page)
  end

  def new
    @img = Image.new()
    @tags = Tag.order("name ASC").all
  end

  # TODO: !!!! can't add tags
  # TODO: !!!! tags: [tags]
  # TODO: may be hook for rename_image! !!!!!
  def create
    @img = Image.new(params[:image], images_tags: params[:images_tags])
    @img.rename_image!

    response = @img.save_with_response
    redirect_to dispatch_imgs_path, response
  end

  # TODO: id was shown ??
  def edit
    @img = Image.find_by_id(params[:id])
    @tags = Tag.order("name ASC").all
  end

  # TODO: !!!! can't edit tags
  # TODO: !!!! tags: [tags]
  # TODO: may be hook for rename_image! !!!!!!
  def update
    @img = Image.find_by_id(params[:id])
    @img.assign_attributes(params[:image], images_tags: params[:images_tags])

    p @img.inspect

    @img.rename_image!

    response = @img.save_with_response
    redirect_to dispatch_imgs_path, response
  end

  def destroy
    @img = Image.find_by_id(params[:id])
    response = @img.destroy_with_response
    redirect_to dispatch_imgs_path, response
  end

end
