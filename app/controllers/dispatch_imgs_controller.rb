class DispatchImgsController < ApplicationController
  layout "back_end"

  IMG_LAST_DIR = 'tmp'
  IMG_TMP_DIR = Rails.root.join('app', 'assets', 'images', "#{IMG_LAST_DIR}")

# TODO: tests!!!!!!!!!
# TODO: check views!!!
# TODO: refact
# TODO: split stack controller and dispatch img
# TODO: move backend to directory like 'admin'

  def index
    page = params[:page] ? params[:page] : 1
    @imgs = Image.desc.page(page)
  end

  def new
    @img = Image.new()
    @tags = Tag.order("name ASC").all
  end

  def create
    # fail "#{params}"
    # TODO: !!!! can't add tags
    @img = Image.new(params[:image], images_tags: params[:images_tags])
    @img.rename_image!

    response = @img.save_with_response
    redirect_to dispatch_imgs_path, response
  end

  def edit
    # TODO: id was shown ??
    @img = Image.find_by_id(params[:id])
    @tags = Tag.order("name ASC").all
  end

  def update
    @img = Image.find_by_id(params[:id])
    @img.assign_attributes(params[:image], images_tags: params[:images_tags])
    @img.rename_image!

    response = @img.save_with_response
    redirect_to dispatch_imgs_path, response
  end

  def destroy
    @img = Image.find(params[:id])
    response = @img.destroy_with_response
    redirect_to dispatch_imgs_path, response
  end

  # TODO: check back_end on missed partials!!!
  def images_from_dir
    if Dir.exist? IMG_TMP_DIR
      Dir.chdir(IMG_TMP_DIR) do
        file = Dir["*.{jpg,jpeg,png,gif}"].first
        @img = "#{IMG_LAST_DIR}/#{file}" if file && check_img?(file)
      end
      @tags = Tag.order('name ASC').all
    else
      flash[:error] = "The directory #{IMG_TMP_DIR} does not exist. Create it before continue"
    end
  end

  def saving_from_dir
    file = File.open(File.join(IMG_TMP_DIR, File.basename(params[:image])))
    if params[:button] == 'accept'
      img = Image.create!(image: file)
      img.tag_ids = params[:tag_ids]
    end
    File.delete(File.join(IMG_TMP_DIR, File.basename(params[:image])))
    redirect_to stack_path
  end

  def paginate_tags
    page = params[:page] ? params[:page] : 1
    @image = params[:id].blank? ? Image.new() : Image.find(params[:id])
    @tags = get_tags(page)
  end

# TODO: modify to application controller
  private
    def get_tags(page)
      Tag.order("name ASC").page(page).per(20) # !!!!!!!!!! per(5)
    end

  # FIXME: sometimes can't determine images
    def check_img?(file_path)
      file = File.open("#{IMG_TMP_DIR}/#{file_path}")
      data = file.read(9)
      file.close()
      data[0,4].casecmp('GIF8').to_i.zero? ||
          data[0,4].casecmp("\xff\xd8\xff\xe0").to_i.zero? ||
          data[0,4].casecmp("\x89\x50\x4e\x47").to_i.zero?
    end

end
