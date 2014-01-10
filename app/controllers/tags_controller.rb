class TagsController < ApplicationController

  before_filter :find_tag, only: [:show]

  # TODO: image search also by list of tags

  def index
    @tags = Tag.page(current_page)
  end

  def show
    @imgs = @cur_tag.images.includes(:tags).page(current_page)
    @tags = get_uniq_tags_from(@imgs, @cur_tag) if @imgs.present?
    @warns = Warn.all
  end

  # TODO: tests
  # TODO: check replacing income query!!!
  # TODO: exept chooosen
  def autocomplete_search
    term = params["term"].split(/,\s*/).last.strip
    tag_names = Tag.where("name REGEXP ?", term).select(:name).map(&:name)
    # fail tag_names.inspect
    render :json => tag_names
  end

  # TODO: tests
  def search
    search_tags = params["search_query"].strip.chomp(",").split(/,\s*/)
    @cur_tags = Tag.where(name: search_tags)
    @imgs = Image.includes(:tags).where(tags: { name: search_tags }).page(current_page)
    @tags = get_uniq_tags_from(@imgs)
    @warns = Warn.all
  end

  private
    def find_tag
      @cur_tag = Tag.find_by_id(params[:id])
      redirect_to tags_path, Tag.not_found unless @cur_tag
    end

end
