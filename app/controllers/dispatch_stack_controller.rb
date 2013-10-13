class DispatchStackController < ApplicationController
  layout "back_end"

  IMG_LAST_DIR = 'tmp'
  IMG_TMP_DIR = Rails.root.join("public","#{IMG_LAST_DIR}") # TODO: bad path
  GIF = "GIF8"
  JPEG = "\xff\xd8\xff\xe0"
  PNG = "\x89\x50\x4e\x47"

  DIR_NOT_FOUND = "Dir not found"

  # TODO: may be new fake model or something ???
  # TODO: !!!! can't add tags
  # TODO: rename actions !!!!
  # TODO: refactor me !!!!

  def images_from_dir 
    redirect_to dispatch_imgs_path, { alert: "Dir not found" } unless IMG_TMP_DIR.exist? 
    
    Dir.new(IMG_TMP_DIR).to_a.each do |file|
      if check_img?("#{IMG_TMP_DIR}/#{file}")
        @img = "/#{IMG_LAST_DIR}/#{file}"
        break
      end
    end
    @tags = Tag.order("name ASC").all
  end

  # TODO: !!!! can't add tags
  # TODO: !!!! tags: [tags]
  def saving_from_dir
    file = File.open(File.join(IMG_TMP_DIR, File.basename(params[:image]))) 
    if params[:button] == "accept"
      @img = Image.new(image: file)
      @img.rename_image!
      response = @img.save_with_response
    end
    File.delete(file) # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! when deny -> error
    redirect_to stack_path, response
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