module ApplicationHelper
  
  # TODO: tests

  def alert_notifier
    response = content_tag(:div, nil, class: "clear-legacy")
    response += content_tag(:div, flash[:notice], class: "notice") if flash[:notice].present?
    response += content_tag(:div, flash[:alert], class: "alert") if flash[:alert].present?
    response
  end

  def sort_only_by(array, title)
    array.sort_by { |e| e.send(title.to_sym) }.reverse
  end

  def join_by(array, title, amount = nil)
    rezult = array[0...amount] if amount
    rezult.collect{  |t| t.send(title.to_sym) }.join(", ")
  end

end
