class DispatchStackController < ApplicationController
  layout "back_end"

  IMG_LAST_DIR = 'tmp'
  IMG_TMP_DIR = Rails.root.join('app', 'assets', 'images', "#{IMG_LAST_DIR}")
  GIF = "gif8"
  JPEG = "\xff\xd8\xff\xe0"
  PNG = "\x89\x50\x4e\x47"

  DIR_NOT_FOUND = "Dir not found"

  # TODO: may be new fake model or something for DispatchStackController ???

  # TODO: !!!! can't add tags
  # TODO: rename actions !!!!

  def index
    if IMG_TMP_DIR.exist? && file = Dir["#{IMG_TMP_DIR}/*.{jpg,jpeg,png,gif}"].first
      @img = "#{IMG_LAST_DIR}/#{File.basename(file)}" if check_img?(file)
      @tags = Tag.order("name ASC").all
    else 
      redirect_to dispatch_imgs_path, { alert: "Dir not found or empty" }
    end
  end

  # TODO: !!!! can't add tags
  # TODO: !!!! tags: [tags]
  def create
    response = {}
    file_path = params[:image] ? Rails.root.join("#{IMG_TMP_DIR}", File.basename(params[:image])) : nil
    if params[:button] == "accept"
      @img = Image.new(image: File.new(file_path), tag_ids: params[:tag_ids])
      response = @img.save_with_response
    end
    File.delete(file_path) unless response.has_key? :alert
    redirect_to dispatch_stack_index_path, response
  end

  private
    def check_img?(file_path)
      file = File.open(file_path.to_s)
      data = file.read(9)
      file.close
      head = data[0,4].downcase
      return head.casecmp(GIF).to_i.zero? || head.casecmp(JPEG).to_i.zero? || head.casecmp(PNG).to_i.zero?
    end
end
