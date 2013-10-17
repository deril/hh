class DispatchImgsController < ApplicationController
  layout "back_end"

  # TODO: move backend to directory like 'admin'

  before_filter :find_image, only: [:update, :destroy, :edit]

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
  def create
    @img = Image.new(params[:image])

    response = @img.save_with_response
    redirect_to dispatch_imgs_path, response
  end

  # TODO: id was shown ??
  def edit
    @tags = Tag.order("name ASC").all
  end

  # TODO: !!!! can't edit tags
  # TODO: !!!! tags: [tags]
  def update
    @img.assign_attributes(params[:image])
    response = @img.save_with_response
    redirect_to dispatch_imgs_path, response
  end

  def destroy
    response = @img.destroy_with_response
    redirect_to dispatch_imgs_path, response
  end

  # TODO: check back_end on missed partials!!!
  #def images_from_dir
  #  if Dir.exist? IMG_TMP_DIR
  #    Dir.chdir(IMG_TMP_DIR) do
  #      file = Dir["*.{jpg,jpeg,png,gif}"].first
  #      @img = "#{IMG_LAST_DIR}/#{file}" if file && check_img?(file)
  #    end
  #    @tags = Tag.order('name ASC').all
  #  else
  #    flash[:error] = "The directory #{IMG_TMP_DIR} does not exist. Create it before continue"
  #  end
  #end
  #
  #def saving_from_dir
  #  file = File.open(File.join(IMG_TMP_DIR, File.basename(params[:image])))
  #  if params[:button] == 'accept'
  #    img = Image.create!(image: file)
  #    img.tag_ids = params[:tag_ids]
  #  end
  #  File.delete(File.join(IMG_TMP_DIR, File.basename(params[:image])))
  #  redirect_to stack_path
  #end

  private
    def find_image
      @img = Image.find_by_id(params[:id])
      redirect_to dispatch_imgs_path, Image.not_found unless @img
    end
end
