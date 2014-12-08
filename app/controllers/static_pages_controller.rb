class StaticPagesController < ApplicationController

  def about
  end

  def robots
    respond_to :text
  end

end
