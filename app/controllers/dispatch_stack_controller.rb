class DispatchStackController < ApplicationController
  layout "back_end"

  IMG_LAST_DIR = 'tmp'
  IMG_TMP_DIR = Rails.root.join("public","#{IMG_LAST_DIR}") # TODO: bad path
  GIF = "GIF8"
  JPEG = "\xff\xd8\xff\xe0"
  PNG = "\x89\x50\x4e\x47"

  DIR_NOT_FOUND = "Dir not found"

  # TODO: may be new fake model or something for DispatchStackController ???
  # TODO: !!!! can't add tags
  # TODO: rename actions !!!!

  def index
    if IMG_TMP_DIR.exist? 
      @img = Dir["#{IMG_TMP_DIR}/*"].find { |e| check_img?(e) }
      @img = "/#{IMG_LAST_DIR}/#{File.basename(@img)}"
      @tags = Tag.order("name ASC").all
    else 
      redirect_to dispatch_imgs_path, { alert: "Dir not found" }
    end
  end

  # TODO: !!!! can't add tags
  # TODO: !!!! tags: [tags]

  def create
    response = {} 
    file_path = params[:image] ? Rails.root.join("#{IMG_TMP_DIR}", File.basename(params[:image])) : nil
    if params[:button] == "accept"
      @img = Image.new(image: File.new(file_path))
      response = @img.save_with_response
    end
    File.delete(file_path)                                  # FIXME: bug!!!!!
    redirect_to dispatch_stack_index_path, response
  end
  
  private
    def check_img?(file_path)
      return false if file_path.scan(/.jpg$|.jpeg$|.gif$|.png$/).blank?
      file = File.open(file_path.to_s,'rb')
      data = file.read(9)
      file.close()
      return data[0,4] == GIF || data[0,4] == JPEG || data[0,4] == PNG
    end
end