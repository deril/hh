class Dispatch::GroupsController < ApplicationController
  layout "back_end"
  before_action :hh_authenticate_admin!
  before_action :set_group, only: [:update, :destroy, :edit]
  helper_method :sort_column, :sort_direction

  def index
    @groups = Group.order(:name)
  end

  def new
    @group = Group.new
    @tags = Tag.all
  end

  def create
    @group = Group.new(group_params)
    if @group.save
      redirect_to dispatch_groups_path, notice: 'Group was successfully created'
    else
      render :new
    end
  end

  def edit
    @tags = Tag.all
  end

  def update
    if @group.update(group_params)
      redirect_to dispatch_groups_path, notice: 'Group was successfully updated'
    else
      render :edit
    end
  end

  def destroy
    @group.destroy
    redirect_to dispatch_groups_path, notice: 'Group was successfully deleted'
  end

  private
    def set_group
      @group = Group.find_by(id: params[:id])
      redirect_to dispatch_groups_path, alert: 'Cannot find such group' unless @group
    end

    def group_params
      params.fetch(:group, {}).permit(:name, :group_id, tag_ids: [])
    end
end
