module TaskCommentsHelper
  def comment_status_color(status)
    case status
    when "pending"
      "pending"
    when "seen"
      "info"
    when "replied"
      "success"
    else
      "dark"
    end
  end

  def comment_status_text(status)
    return "" if status.blank?
    I18n.t("activerecord.enums.comment.status.#{status}")
  end
end
