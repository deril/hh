class DispatchImgsController < ApplicationController
  layout "back_end"
  
  IMG_LAST_DIR = 'tmp'
  IMG_TMP_DIR = Rails.root.join("public","#{IMG_LAST_DIR}") # TODO: bad path

# TODO: tests!!!!!!!!!
# TODO: check views!!!
# TODO: refact

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
    # TODO: if no dir ????
    Dir.new(IMG_TMP_DIR).to_a.each do |file|
      if check_img?(file)
        @img = "/#{IMG_LAST_DIR}/#{file}"
        break
      end
    end
    @tags = Tag.order("name ASC").all
  end

  def saving_from_dir
    file = File.open(File.join(IMG_TMP_DIR, File.basename(params[:image]))) 
    if params[:button] == "accept"
      @img = Image.new(image: file, images_tags: params[:images_tags])
      @img.rename_image!
      response = @img.save_with_response
    end
    # TODO: may be only path!!! not a file
    File.delete(file) # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! when deny -> error
    redirect_to stack_path, response
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

    def check_img?(file_path)
      return false if file_path.scan(/.jpg$|.jpeg$|.gif$|.png$/) == []
      file = File.open("#{IMG_TMP_DIR}/#{file_path}",'rb')
      data = file.read(9)
      file.close()
      return data[0,4] == "GIF8" || data[0,4] == "\xff\xd8\xff\xe0" || data[0,4] == "\x89\x50\x4e\x47"
    end

end
