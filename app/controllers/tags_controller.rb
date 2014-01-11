class TagsController < ApplicationController

  before_filter :find_tag, only: [:show]

  # TODO: image search also by list of tags

  def index
    @tags = Tag.all
  end

  def show
    @imgs = @cur_tag.images.includes(:tags).page(current_page)
    @tags = get_uniq_tags_from(@imgs, @cur_tag) if @imgs.present?
    @warns = Warn.all
  end

  def autocomplete_search
    return render :json => [] unless params[:term].present?

    all_terms = params[:term].split(/,\s*/) 
    last_term = all_terms.pop.strip
    tag_names = Tag.where("name REGEXP ?", last_term).select(:name).map(&:name)
    render :json => tag_names - all_terms
  end

  def search
    return redirect_to images_path, { alert: "Searching error." } unless params["search_query"]

    @search_tags = params[:search_query].strip.chomp(",").split(/,\s*/)
    @cur_tags = Tag.where(name: @search_tags)
    @imgs = Image.includes(:tags).where(tags: { name: @search_tags }).page(current_page)
    @tags = get_uniq_tags_from(@imgs)
    @warns = Warn.all
  end

  private
    def find_tag
      @cur_tag = Tag.find_by_id(params[:id])
      redirect_to tags_path, Tag.not_found unless @cur_tag
    end

end
