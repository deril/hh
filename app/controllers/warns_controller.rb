class WarnsController < ApplicationController
  before_action :add_warns, only: [:show]

  def show
    @warn = Warn.find_by(id: params[:id])
    redirect_to root_url, flash: { alert: 'Warn not found' } and return unless @warn

    @imgs = @warn.images.page(current_page)
    @tags = get_uniq_tags_from(@imgs) if @imgs.present?
  end
end
