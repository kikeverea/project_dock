import DropzoneController from './dropzone_controller'

export default class extends DropzoneController {
  static values = { url: String, acceptedFiles: String, uploadedFile: Object }
  static targets = [ 'fileInput', 'removeButton' ]

  connect() {
    super.connect(this.acceptedFilesValue)
    console.log("'Upload Files' controller connected")

    this.uploadMessage = document.querySelector('.dz-message.needsclick')

    if (this.hasUploadedFile())
      this.addUploadedFile()


    this.dropzone.on('addedfile', file => this.handleFileAdded(file))
    this.dropzone.on('removedfile', () => this.handleFileRemoved())
    this.dropzone.on('success', (_file, res) => Turbo.renderStreamMessage(res))
  }

  hasUploadedFile() {
    return this.uploadedFileValue.url
  }

  addUploadedFile() {
    const { url, name } = this.uploadedFileValue

    this.mockFile = {
      name: name || "current_file",
      accepted: true
    }

    this.dropzone.displayExistingFile(this.mockFile, url)

    this.uploadMessage.classList.add('hidden')
    this.dropzone.options.maxFiles = 1
  }

  async handleFileAdded(file) {
    this.clearQueue(file)

    // wait for file resolution
    setTimeout(() => {
      if (file.status === 'error')
        this.showErrorIcon(true)
      else if (this.urlValue)
        this.processQueue()
      else if (this.fileInputTarget)
        this.transferFile(file)
    }, 0)

    this.uploadMessage.classList.add('hidden')
    this.removeButtonTarget.classList.remove('hidden')

    const errorIcon = document.querySelector('.dz-error-mark')

    if (errorIcon)
      errorIcon.style.display = 'none'
  }

  transferFile(file) {
    const transfer = new DataTransfer()
    transfer.items.add(file)
    this.fileInputTarget.files = transfer.files
  }

  async handleFileRemoved() {
    if (this.fileInputTarget) this.fileInputTarget.files = new DataTransfer().files
  }

  removeFile(_e) {
    this.dropzone.removeAllFiles(true)
    this.uploadMessage.classList.remove('hidden')
    this.removeButtonTarget.classList.add('hidden')

    if (this.mockFile)
      this.dropzone.removeFile(this.mockFile)
  }

  clearQueue(lastFileAdded) {
    this.dropzone.files.forEach(file => {
      if (file !== lastFileAdded)
        this.dropzone.removeFile(file)
    })

    if (this.mockFile)
      this.dropzone.removeFile(this.mockFile)
  }

  showSpinner() {
    const spinnerContainer = document.querySelector('.dz-image')
    const spinner = document.createElement('span')
    spinner.classList.add('spinner-border', 'text-primary')

    spinnerContainer.replaceChildren(spinner)
  }
}
