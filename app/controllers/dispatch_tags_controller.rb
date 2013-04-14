class DispatchTagsController < ApplicationController
  #filters
  before_filter :find_tag, except: [:index, :new, :create] 

  def index
    @tags = Tag.order("id DESC").page(current_page)
  end

  def new
    @tag = Tag.new
  end

  def create
    @tag = Tag.new(name: params[:tag])
    redirect_to_index @tag.save, "Add"  #private def redirect_to_index action, note 
  end 
  
  def update 
    @tag.name = params[:tag]
    redirect_to_index @tag.save, "Edit" #private def redirect_to_index action, note 
  end

  def destroy
    redirect_to_index @tag.destroy, "Delet" #make it cute
                        #private def redirect_to_index action, note 
  end

  private
    def find_tag 
      @tag = Tag.find(params[:id])
    end

    #get redirection to index page with notification about success of action 
    def redirect_to_index action, note 
      if action 
        redirect_to dispatch_tags_path, notice: "Tag successfully "+note.to_s+"ed."
      else 
        redirect_to dispatch_tags_path, notice: "Somthing bad with tag "+note.to_s+"ing."
      end
    end
end
