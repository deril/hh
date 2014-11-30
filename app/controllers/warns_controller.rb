class WarnsController < ApplicationController

  before_action :find_current_warn, only: [:show]
  before_action :add_warns,         only: [:show]

  def show
    @imgs = @cur_warn.images.page(current_page)
    @tags = get_uniq_tags_from(@imgs) if @imgs.present?
  end

  private
    def find_current_warn
      @cur_warn = Warn.find_by(id: params[:id])
      redirect_to root_url, flash: { alert: 'Warn not found' } unless @cur_warn
    end

end
