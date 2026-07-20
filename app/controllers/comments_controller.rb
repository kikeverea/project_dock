class CommentsController < ApplicationController
  include Toast

  before_action :set_task
  before_action :set_activity
  before_action :set_project
  before_action :set_root_comment
  before_action :set_comment, except: %i[ new create cancel_form ]

  def new
    @reply_to = Comment.find(params[:comment_id]) if params[:comment_id]

    @comment = @reply_to ?
      @reply_to.comments.new :
      new_comment

    if @project
      render "components/turbo_modal_content", locals: {
        channel: :comment,
        partial: "comments/form"
      }
    else
      refresh_comments(new_comment: @reply_to.nil?)
    end
  end

  def show
    refresh_comment
  end

  def edit
    refresh_comment(edit: true)
  end

  def cancel_form
    refresh_comments
  end

  def create
    reply_to = Comment.find(params[:comment_id]) if params[:comment_id]

    @comment = reply_to ?
      reply_to.comments.new(comment_params) :
      new_comment(comment_params)

    if @comment.save
      if @project
        render "components/turbo_modal_content", locals: {
          channel: :comment,
          action: :hide,
          replace: { id: "work-units", partial: "projects/work_units" }
        }
      else
        refresh_comments
      end
    else
      refresh_comments(new_comment: true)
    end
  end

  def update
    if @comment.update(comment_params)
      refresh_comments
    else
      refresh_comments(new_comment: true)
    end
  end

  def destroy
    @comment.destroy!
    refresh_comments
  end

  private

  def comments_id
    @root_comment ? "comment-#{@root_comment.id}-comments" : "comments"
  end

  def refresh_comments(new_comment: false)
    render turbo_stream: turbo_stream.replace(
      comments_id,
      partial: "comments/timeline",
      locals: {
        new_comment: new_comment,
        comments: @root_comment ? @root_comment.comments : @comments,
      }
    )
  end

  def refresh_comment(edit: false)
    render turbo_stream: turbo_stream.replace(
      "comment-#{@comment.id}",
      partial: "comments/comment",
      locals: { edit: edit }
    )
  end

  def new_comment(params={})
    if @activity
      @activity.comments.new(params)
    elsif @project
      @project.comments.new(params)
    elsif @task
      @task.comments.new(params)
    else
      Comment.new
    end
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def set_task
    return if params[:task_id].blank?
    @task = Task.find(params[:task_id])
    @comments = @task.comments
  end

  def set_project
    return if params[:project_id].blank?
    @project = Project.find(params[:project_id])
    @comments = @project.comments
  end

  def set_activity
    return if params[:activity_id].blank?
    @activity = Activity.find(params[:activity_id])
    @comments = @activity.comments
  end

  def set_root_comment
    @root_comment = Comment.find(params[:root_comment_id]) if params[:root_comment_id].present?
  end

  def comment_params
    params.expect(comment: [
      :title,
      :content,
      :acknowledged_at,
      :completed_at,
      :completed_by_id
    ])
  end
end