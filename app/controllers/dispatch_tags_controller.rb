class DispatchTagsController < ApplicationController
  layout "back_end"
  before_filter :find_tag, only: [:update, :destroy, :edit] 

  def index
    @tags = Tag.order("name ASC").page(current_page)
  end

  def new
    @tag = Tag.new
  end

  def create
    @tag = Tag.new(name: params[:tag].downcase.gsub(/ +/,'_'))
    redirect_to_index @tag.save, "Add"
  end 
  
  def edit
  end

  def update 
    @tag.name = params[:tag].downcase.gsub(/ +/,'_')
    redirect_to_index @tag.save, "Edit"
  end

  def destroy
    redirect_to_index @tag.destroy, "Delet" 
  end

  private
    def find_tag 
      @tag = Tag.find(params[:id])
    end

    # TODO: make it better
    #get redirection to index page with notification about success of action 
    def redirect_to_index action, note 
      if action 
        redirect_to dispatch_tags_path, notice: "Tag successfully "+note.to_s+"ed."
      else 
        redirect_to dispatch_tags_path, notice: "Somthing bad with tag "+note.to_s+"ing."
      end
    end
end
