class Dispatch::TagsController < ApplicationController
  layout "back_end"
  before_action :authenticate_admin!
  before_action :find_tag, only: [:update, :destroy, :edit]
  helper_method :sort_column, :sort_direction

  def index
    @tags = Tag.order(sort_column + " " + sort_direction).page(current_page)
  end

  def new
    @tag = Tag.new
    @groups = Group.all
    @tag.group_id = @groups.first.id
  end

  def create
    @tag = Tag.new(tag_params)
    if @tag.save
      redirect_to dispatch_tags_path, notice: 'Tag was successfully created'
    else
      render :new
    end
  end

  def edit
    @groups = Group.all
  end

  def update
    if @tag.update(tag_params)
      redirect_to dispatch_tags_path, notice: 'Tag was successfully updated'
    else
      render :edit
    end
  end

  def destroy
    response = @tag.destroy_with_response
    redirect_to dispatch_tags_path, response
  end

  private
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

    def tag_params
      params.fetch(:tag, {}).permit(:name, :tag_id, :group_id)
    end
end
