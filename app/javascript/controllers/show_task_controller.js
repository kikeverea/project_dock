import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static values = { taskId: Number }

  connect() {
    // console.log("'Show task' controller connected", this.taskIdValue)
  }

  showEdit() {
    const modalElement = document.getElementById('task-show-modal')

    modalElement.addEventListener(
      "hidden.bs.modal",
      () => this.requestEdit(),
      { once: true }
    )

    this.modal = bootstrap.Modal.getOrCreateInstance(modalElement)
    this.modal.hide()
  }

  requestEdit() {
    fetch(`/tasks/${this.taskIdValue}/edit`, {
      method: 'GET',
      follow: 'manual',
      headers: {
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content'),
        'Accept': 'text/vnd.turbo-stream.html, text/html, application/xhtml+xml'
      }
    })
    .then(response => response.text())
    .then(turbo => Turbo.renderStreamMessage(turbo))
  }
}
