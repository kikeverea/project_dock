module ActivityTasksHelper

  def task_status_badge(task)
    color = task.pending? ? "bg-gray-100" : "bg-green-500"
    text_color = task.pending? ? "text-gray-700" : "text-white"

    "<span class='inline-flex items-center rounded-lg #{color} px-2 py-1 text-xs font-medium #{text_color}'>
      #{task.status_text.downcase}
    </span>".html_safe
  end

end
