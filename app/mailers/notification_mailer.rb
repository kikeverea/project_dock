class NotificationMailer < ApplicationMailer
  default from: "Notificaciones <soporte@innobing.es>"

  def send_task_notification(task, to)
    @task = task
    @project = task.project

    mail(
      to: to.email,
      subject: "Tarea asignada - #{task.name}"
    )
  end

  def send_invoice_notification(project, to)
    @project = project

    mail(
      to: to.email,
      subject: "Aviso de facturación - #{project.name}"
    )
  end

  def send_invoice_number_notification(project, to)
    @project = project

    mail(
      to: to.email,
      subject: "Número de factura actualizado - #{project.name}"
    )
  end

  def send_project_notification(project, to)
    @project = project

    mail(
      to: to.email,
      subject: "Proyecto asignado - #{project.name}"
    )
  end
end
