class Dispatch::StackController < ApplicationController
  layout "back_end"

  IMG_LAST_DIR = 'tmp'
  IMG_TMP_DIR = Rails.root.join('public', "#{IMG_LAST_DIR}")
  DIR_NOT_FOUND = "Dir not found"

  GIF = "gif8"
  JPEG = "\xff\xd8\xff\xe0"
  PNG = "\x89\x50\x4e\x47"

  before_action :hh_authenticate_admin!
  before_action :add_all_warns, only: [:index]

  def index
    if IMG_TMP_DIR.exist?
      images = Dir["#{IMG_TMP_DIR}/*"].sort.select { |e| check_img?(e) }
      unless images.empty?
        @img = Image.new
        @img_f = "#{IMG_LAST_DIR}/#{File.basename(images.first)}"
        @tags = Tag.order("name ASC")
      end
    else
      redirect_to dispatch_imgs_path, { alert: "Dir not found" }
    end
  end

  def create
    response = {}
    permited_params = image_params
    file_path = permited_params[:image] ? Rails.root.join("#{IMG_TMP_DIR}", File.basename(permited_params[:image])) : nil
    if params[:button] == "accept"
      @img = Image.new(image: File.new(file_path), tag_ids: permited_params[:tag_ids], warn_id: permited_params[:warn_id])
      response = @img.save_with_response
    end
    File.delete(file_path) unless response.has_key? :alert
    redirect_to dispatch_stack_index_path, response
  end

  private
    def check_img?(file_path)
      return false if file_path.scan(/.jpg$|.jpeg$|.gif$|.png$/).blank?
      head = File.open(file_path.to_s) {|file| file.read(9)[0,4].downcase }
      return head.casecmp(GIF).to_i.zero? || head.casecmp(JPEG).to_i.zero? || head.casecmp(PNG).to_i.zero?
    end

    def image_params
      params.fetch(:image, {}).permit(:image, :warn_id, tag_ids: [])
    end
end
