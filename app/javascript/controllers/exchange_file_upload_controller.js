import DropzoneController from "./dropzone_controller"

export default class extends DropzoneController {
  static values = { url: String, acceptedFiles: String }

  connect() {
    super.connect(this.acceptedFilesValue)
    console.log("'Exchange File Upload' controller connected", this.urlValue)

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
      else
        this.processQueue()
    }, 0)

    this.uploadMessage.classList.add('hidden')

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

  showSpinner() {
    const spinnerContainer = document.querySelector('.dz-image')
    const spinner = document.createElement('span')
    spinner.classList.add('spinner-border', 'text-primary')

    spinnerContainer.replaceChildren(spinner)
  }
}
