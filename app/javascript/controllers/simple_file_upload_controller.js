import DropzoneController from "./dropzone_controller"

export default class extends DropzoneController {
  static values = { url: String, source: String, isPublic: Boolean, isClient: Boolean, acceptedFiles: String }

  connect() {
    super.connect(this.acceptedFilesValue, this.sourceValue)
    // console.log("'Simple files upload' controller connected")

    this.uploadMessage = document.querySelector('.dz-message.needsclick')

    this.dropzone.on('addedfile', file => this.handleFileAdded(file))
    this.dropzone.on('success', (_file, res) => Turbo.renderStreamMessage(res))
  }

  async handleFileAdded(file) {
    this.clearQueue(file)

    // wait for file resolution
    setTimeout(() => {
      if (file.status === 'error')
        this.showErrorIcon(true)
      else {
        this.uploadFile()
      }
    }, 0)

    this.uploadMessage.classList.add('d-none')

    const errorIcon = document.querySelector('.dz-error-mark')

    if (errorIcon)
      errorIcon.style.display = 'none'
  }

  clearQueue(lastFileAdded) {
    this.dropzone.files.forEach(file => {
      if (file !== lastFileAdded) {
        this.dropzone.removeFile(file)
      }
    })
  }

  async uploadFile() {

    if (this.isPublicValue) {

      const title = this.isClientValue
        ? 'Documento compartido'
        : 'Documento público'

      const message = this.isClientValue
        ? 'Este documento será visible sólo para Kik Balanga y no será compartido con terceros'
        : 'Este documento será visible desde el área de clientes. ¿Deseas continuar?'

      const res = await Swal.fire({
        titleText: title,
        text: message,
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
        this.processQueue()
    }
    else this.processQueue()
  }
}
