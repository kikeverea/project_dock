import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static values = { url: String, maxFiles: Number, type: String, disableAutoUpload: Boolean }
  static targets = [ 'value' ]

  connect(acceptedFiles, source) {
    console.log("'Dropzone' controller connected")

    this.source = source || 'documents'
    const maxFiles = this.maxFilesValue || 1

    const invalidFileMessage = acceptedFiles
      ? `No puedes subir archivos tipo. Permitidos: ${this.extractFileType(acceptedFiles).toUpperCase()}`
      : 'No puedes subir archivos públicos de este tipo. Permitidos: imágenes y PDF'

    const disableAutoUpload = this.disableAutoUploadValue || !this.urlValue

    this.dropzone = new Dropzone(this.element, {
      url: this.urlValue || "#",
      autoProcessQueue: !disableAutoUpload,
      headers: {
        'Accept': 'text/vnd.turbo-stream.html, text/html, application/xhtml+xml',
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').getAttribute('content')
      },
      acceptedFiles: acceptedFiles || null,
      paramName: "file",
      maxFiles: maxFiles,
      thumbnailWidth: null,
      thumbnailHeight: null,
      dictInvalidFileType: invalidFileMessage,
      init: function () {
        if (maxFiles === 1) {
          this.on('maxfilesexceeded', function (file) {
            this.removeAllFiles()
            this.addFile(file) // add the new one
          })
        }
      }
    })

    this.dropzone.on('success', (file, response) => {
      if (this.hasValueTarget)
        this.valueTarget.value = response.path

      Turbo.renderStreamMessage(response)
    })
  }

  extractFileType(mimeType) {
    const mimeEnd = mimeType.indexOf('/') !== -1
      ? mimeType.indexOf('/')
      : mimeType.indexOf('.')

    return mimeType.substring(mimeEnd + 1)
  }

  setAcceptedFiles(types) {
    this.dropzone.options.acceptedFiles = types === 'all' ? null : types;
  }

  openFileBrowser() {
    this.element.click()
  }

  processQueue() {
    if (this.dropzone.getAcceptedFiles().length) {
      this.dropzone.processQueue()

      this.showSpinner()
    }
  }

  showSpinner() {
    const spinnerContainer = document.querySelector('.dz-image')
    const spinner = document.createElement('span')
    spinner.classList.add('spinner-border', 'text-primary')

    spinnerContainer.replaceChildren(spinner)
  }

  redirect() {
    const params = new URLSearchParams({ target: this.source })
    window.location.href = `${window.location.pathname}?${params.toString()}`
  }

  showErrorIcon(show) {
    const imageThumb = document.querySelector('.dz-image')

    if (imageThumb)
      imageThumb.style.display = show ? 'none' : 'block'

    document.querySelector('.dz-error-mark').style.display = show ? 'block' : 'none'
  }
}