class DispatchTagsController < ApplicationController
  layout "back_end"
  before_filter :find_tag, only: [:update, :destroy, :edit] 

  def index
    @tags = Tag.order("name ASC").page(current_page)
  end

  def new
    @tag = Tag.new()
  end

  def create
    @tag = Tag.new(name: trim_n_underscore(params[:tag]))
    response = @tag.save_with_response
    redirect_to dispatch_tags_path, response
  end 
  
  def edit
  end

  def update 
    @tag.name = trim_n_underscore(params[:tag])
    response = @tag.save_with_response
    redirect_to dispatch_tags_path, response
  end

  def destroy
    response = @tag.destroy_with_response
    redirect_to dispatch_tags_path, response
  end

  private
    def trim_n_underscore str
      str.blank? ? nil : str.strip.downcase.gsub(/\s+/,'_') 
    end

    def find_tag  
      @tag = Tag.find_by_id(params[:id])
      redirect_to dispatch_tags_path, Tag.not_found unless @tag
    end
end
