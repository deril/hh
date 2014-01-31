class DispatchTagsController < ApplicationController
  layout "back_end"
  before_filter :authenticate_admin!
  before_filter :find_tag, only: [:update, :destroy, :edit] 
  helper_method :sort_column, :sort_direction

  def index
    @tags = Tag.order(sort_column + " " + sort_direction).page(current_page)
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
      @tag = Tag.find_by(id: params[:id])
      redirect_to dispatch_tags_path, Tag.not_found unless @tag
    end

    def sort_column
      Tag.column_names.include?(params[:sort]) ? params[:sort] : "name"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end
end
