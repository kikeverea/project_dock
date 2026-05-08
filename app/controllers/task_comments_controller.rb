class TaskCommentsController < ApplicationController
  include Toast

  before_action :set_task
  before_action :set_comment, except: %i[ index new create ]
  before_action :set_activity

  def index
    refresh_comments
  end

  def new
    @comment = TaskComment.new(parent_comment_id: params[:parent_comment_id])
    @reply_to = TaskComment.find(params[:parent_comment_id]) if params[:parent_comment_id]
    refresh_comments(new_comment: @reply_to.nil?)
  end

  def show
    refresh_comment
  end

  def edit
    refresh_comment(edit: true)
  end

  def cancel_edit
    refresh_comments
  end

  def create
    @comment = @task.comments.build(comment_params)

    if @comment.save!
      refresh_comments
    else
      refresh_comments(show_form: true)
    end
  end

  def update
    if @comment.update(comment_params)
      refresh_comments
    else
      refresh_comments(show_form: true)
    end
  end

  def destroy
    @comment.destroy!
    refresh_comments
  end

  private

  def refresh_comments(new_comment: false)
    render turbo_stream: turbo_stream.replace(
      "task-comments",
      partial: "task_comments/timeline",
      locals: { new_comment: new_comment }
    )
  end

  def refresh_comment(edit: false)
    render turbo_stream: turbo_stream.replace(
      edit ? "comment-#{@comment.id}" : "comment-#{@comment.id}-form",
      partial: edit ? "task_comments/form" : "task_comments/task_comment",
      locals: { edit: edit }
    )
  end

  def set_comment
    @comment = TaskComment.find(params[:id])
    @task ||= @comment.task
  end

  def set_task
    @task = Task.find(params[:task_id]) if params[:task_id]
  end

  def set_activity
    @activity = @task&.activity
  end

  def comment_params
    params.expect(task_comment: [:user_id, :lead_id, :activity_id, :status, :content, :parent_comment_id]).merge({ user_id: Current.user.id })
  end
end