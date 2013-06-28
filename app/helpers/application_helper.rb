module ApplicationHelper

  def alert_notifier
    response = content_tag(:div, nil, class: "clear")
    response += content_tag(:div, flash[:notice], class: "notice") if flash[:notice].present?
    response += content_tag(:div, flash[:alert], class: "alert") if flash[:alert].present?
    response
  end


  # def meta_title(title = nil)
  #   title_content = APP_CONFIG['default_pre_title'] + ' | '
  #   title_content += title.present? ? title : APP_CONFIG['default_title']
  #   content_for :title, title_content
  # end

  # def meta_keywords(keywords = nil)
  #   keywords_content = keywords.present? ? keywords : APP_CONFIG['default_keywords']
  #   content_for :keywords, keywords_content
  # end

  # def meta_description(description = nil)
  #   description_content = description.present? ? description : APP_CONFIG['default_description']
  #   content_for :description, description_content
  # end

end
