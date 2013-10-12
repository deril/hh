class DispatchStackController < ApplicationController
  layout "back_end"

  IMG_LAST_DIR = 'tmp'
  IMG_TMP_DIR = Rails.root.join("public","#{IMG_LAST_DIR}") # TODO: bad path


  # TODO: if no dir ????
  def images_from_dir  
    # fail "hi"
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
    File.delete(file) # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! when deny -> error
    redirect_to stack_path, response
  end
  
  private
    def check_img?(file_path)
      return false if file_path.scan(/.jpg$|.jpeg$|.gif$|.png$/) == []
      file = File.open("#{IMG_TMP_DIR}/#{file_path}",'rb')
      data = file.read(9)
      file.close()
      return data[0,4] == "GIF8" || data[0,4] == "\xff\xd8\xff\xe0" || data[0,4] == "\x89\x50\x4e\x47"
    end
end