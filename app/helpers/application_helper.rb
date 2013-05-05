module ApplicationHelper

  def alert_notifier
    response = content_tag(:div, nil, class: "clear")
    response += content_tag(:div, flash[:notice], class: "notice") if flash[:notice].present?
    response += content_tag(:div, flash[:alert], class: "alert") if flash[:alert].present?
    response
  end

end
