class DispatchStackController < ApplicationController
  layout "back_end"

  IMG_LAST_DIR = 'tmp'
  IMG_TMP_DIR = Rails.root.join('public', "#{IMG_LAST_DIR}")
  DIR_NOT_FOUND = "Dir not found"

  GIF = "gif8"
  JPEG = "\xff\xd8\xff\xe0"
  PNG = "\x89\x50\x4e\x47"

  before_filter :authenticate_admin!
  before_filter :add_warns, only: [:index]

  # TODO: may_be new fake model or something for DispatchStackController ???

  def index
    if IMG_TMP_DIR.exist?
      images = Dir["#{IMG_TMP_DIR}/*"].select { |e| check_img?(e) }
      unless images.empty?
        @img = "#{IMG_LAST_DIR}/#{File.basename(images.first)}"
        @tags = Tag.order("name ASC").all
      end
    else
      redirect_to dispatch_imgs_path, { alert: "Dir not found or empty" }
    end
  end

  def create
    response = {}
    file_path = params[:image] ? Rails.root.join("#{IMG_TMP_DIR}", File.basename(params[:image])) : nil
    if params[:button] == "accept"
      @img = Image.new(image: File.new(file_path), tag_ids: params[:tag_ids], warn_id: params[:warn_id])
      response = @img.save_with_response
    end
    File.delete(file_path) unless response.has_key? :alert
    redirect_to dispatch_stack_index_path, response
  end

  private
    def check_img?(file_path)
      return false if file_path.scan(/.jpg$|.jpeg$|.gif$|.png$/).blank?
      file = File.open(file_path.to_s)
      data = file.read(9)
      file.close
      head = data[0,4].downcase
      return head.casecmp(GIF).to_i.zero? || head.casecmp(JPEG).to_i.zero? || head.casecmp(PNG).to_i.zero?
    end
end
