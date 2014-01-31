module ApplicationHelper

  # TODO: tests

  def alert_notifier
    response = content_tag(:div, nil, class: "clear-legacy")
    response += content_tag(:div, flash[:notice], class: "notice") if flash[:notice].present?
    response += content_tag(:div, flash[:alert], class: "alert") if flash[:alert].present?
    response
  end

  def sort_only_by(array, title)
    array.sort_by!{ |e| e.send(title.to_sym) }.reverse if array.present?
    array
  end

  def join_by(array, title, amount = nil)
    return '' unless array.present?
    rezult = array[0...amount] if amount
    rezult.collect{  |t| t.send(title.to_sym) }.join(", ")
  end

  # === Attributes
  # * +tags+ array of Tags objects
  # * +classes+ array of strings
  # === Yields
  # yield recieve tag element and class element, that couting by count of tag usages
  def tag_cloud(tags, classes)
    max = tags.sort_by(&:count).last.count
    max = 1 if max.zero?
    tags.each do |tag|
      index = tag.count.to_f / max * (classes.size - 1)
      yield tag, classes[index.round]
    end
  end

  def sortable(column, title=nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, { sort: column, direction: direction }, class: css_class
  end

end
