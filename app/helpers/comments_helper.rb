module CommentsHelper
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

  def comments_id
    @root_comment ? "comment-#{@root_comment.id}-comments" : "comments"
  end

  def comment_status_text(status)
    return "" if status.blank?
    I18n.t("activerecord.enums.comment.status.#{status}")
  end

  def comment_form_path(comment)
    comment&.persisted? ? edit_form_comment_path(comment) : new_form_comment_path
  end

  def cancel_comment_form_path
    if @project
      cancel_form_project_comments_path(@project)
    elsif @activity
      cancel_form_activity_comments_path(@activity)
    elsif @task
      cancel_form_task_comments_path(@task)
    end
  end

  def show_comment_path(comment)
    if @project
      project_comment_path(@project, comment)
    elsif @activity
      activity_comment_path(@activity, comment)
    elsif @task
      task_comment_path(@task, comment)
    end
  end

  def delete_comment_path(comment)
    if @project
      project_comment_path(@project, comment)
    elsif @activity
      activity_comment_path(@activity, comment)
    elsif @task
      task_comment_path(@task, comment)
    end
  end

  def new_comment_reply_path(reply_to)
    if @project
      project_comment_new_reply_path(@project, reply_to)
    elsif @activity
      activity_comment_new_reply_path(@activity, reply_to)
    elsif @task
      task_comment_new_reply_path(@task, reply_to)
    end
  end

  private

  def new_form_comment_path
    if @project
      new_project_comment_path(@project)
    elsif @activity
      new_activity_comment_path(@activity)
    elsif @task
      new_task_comment_path(@task)
    end
  end

  def edit_form_comment_path(comment)
    if @project
      edit_project_comment_path(@project, comment)
    elsif @activity
      edit_activity_comment_path(@activity, comment)
    elsif @task
      edit_task_comment_path(@task, comment)
    elsif @reply_to
      edit_comment_reply_path(@reply_to)
    end
  end
end
