class TagsController < ApplicationController

  before_action :find_tag,      only: [:show]
  before_action :add_all_warns, only: [:show, :search]

  def index
    @tags = Tag.all.load()
  end

  def show
    @imgs = @cur_tag.images.page(current_page)
    @tags = get_uniq_tags_from(@imgs, @cur_tag) if @imgs.present?
  end

  def autocomplete_search
    term = prepare_term(params[:term])
    render json: term.blank? ? [] : define_tags_except(term)
  end

  def search
    return redirect_to images_path, { alert: "Searching error." } unless params[:search_query]

    @search_tags = prepare_search_query(params[:search_query])
    @cur_tags = Tag.where(name: @search_tags)
    @imgs = Image.joins(:tags).where(tags: { name: @search_tags }).page(current_page)
    @tags = get_uniq_tags_from(@imgs)
  end

  private
    def define_tags_except(tags_str)
      all_terms = tags_str.split(', ')
      last_term = all_terms.pop
      tag_names = Tag.where("name REGEXP ?", last_term).pluck(:name)
      tag_names - all_terms
    end

    def prepare_term(term)
      term ? term.strip.gsub(/\s+/,' ') : ''
    end

    def prepare_search_query(term)
      term.strip.chomp(",").split(/,\s*/)
    end

    def find_tag
      @cur_tag = Tag.find_by(id: params[:id])
      redirect_to tags_path, { alert: "Can't find such Tag." } unless @cur_tag
    end

end
