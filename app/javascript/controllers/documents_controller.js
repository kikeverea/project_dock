import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static targets = [ 'actionButtons' ]
  static values = { clientAccessUrl: String, deleteUrl: String }

  connect() {
    console.log("'Documents' controller connected")

    this.selectedDocuments = []
  }

  checkDocument(e) {
    const checkbox = e.currentTarget
    const documentId = checkbox.dataset.documentId

    this.selectedDocuments = checkbox.checked
      ? [ ...this.selectedDocuments, documentId]
      : this.selectedDocuments.filter(id => id !== documentId)

    this.showActionButtons(!!this.selectedDocuments.length)
  }

  showActionButtons(show) {
    if (show)
      this.actionButtonsTarget.classList.replace('hidden', 'flex')
    else
      this.actionButtonsTarget.classList.replace('flex', 'hidden')
  }

  async deleteDocuments() {
    const res = await Swal.fire({
      titleText: '¿Estás seguro que deseas eliminar estos documentos?',
      text: 'Esta acción es irreversible',
      icon: "error",
      showCancelButton: true,
      reverseButtons: true,
      confirmButtonText: 'Eliminar',
      cancelButtonText: 'Cancelar',
      customClass: {
        confirmButton: "btn btn-danger",
        cancelButton: "btn btn-secondary",
      }
    })

    if (res.isConfirmed)
      this.sendSelectedDocuments(this.deleteUrlValue, 'DELETE')
  }

  async giveAccess() {

    const multiple = this.selectedDocuments.length > 1
    const title = multiple ? 'Documentos público' : 'Documento público'
    const text = multiple
      ? 'Estos documentos serán visibles'
      : 'Este documento será visible'

    const res = await Swal.fire({
      titleText: title,
      text: `${text} desde el área de clientes. ¿Deseas continuar?`,
      icon: "info",
      showCancelButton: true,
      reverseButtons: true,
      confirmButtonText: 'Enviar',
      cancelButtonText: 'Cancelar',
      customClass: {
        confirmButton: "btn btn-info",
        cancelButton: "btn btn-secondary",
      }
    })

    if (res.isConfirmed)
      this.sendSelectedDocuments(this.clientAccessUrlValue, 'PUT', { public: true })
  }

  async removeAccess() {
    this.sendSelectedDocuments(this.clientAccessUrlValue, 'PUT', { public: false })
  }

  sendSelectedDocuments(path, method="GET", args) {
    fetch(path, {
      method: method,
      headers: {
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content'),
        'Content-Type': 'application/json',
        'Accept': 'text/vnd.turbo-stream.html, text/html, application/xhtml+xml'
      },
      body: method === 'GET' ? null : JSON.stringify({ documents: this.selectedDocuments, ...args })
    })
    .then(response => response.ok && response.text())
    .then(text => Turbo.renderStreamMessage(text))
  }
}
