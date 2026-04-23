import DropzoneController from "./dropzone_controller"

export default class extends DropzoneController {
  static values = {
    documentGroup: String,
    uploadButton: String,
    fileNameInput: String,
    removeFileButton: String,
    publicFileInput: String,
    publicFileWarning: Array
  }

  connect() {
    super.connect()
    // console.log("'Upload Files' controller connected")

    this.nameInput = document.getElementById(this.fileNameInputValue)
    this.uploadButton = document.getElementById(this.uploadButtonValue)
    this.uploadMessage = document.querySelector('.dz-message.needsclick')
    this.removeFileButton = document.getElementById(this.removeFileButtonValue)

    this.uploadButton.addEventListener('click', () => this.uploadFile())
    this.removeFileButton.addEventListener('click', () => this.removeFile())

    const publicFileInputEl = document.getElementById(this.publicFileInputValue)

    if (publicFileInputEl) {
      this.publicFileInput = publicFileInputEl
      const isClientZone = this.publicFileInput.type === 'hidden'
      this.isPublic = isClientZone || this.publicFileInput.checked

      if (!isClientZone)
        this.listenToPublicFlagChanges()
    }

    this.dropzone.on('addedfile', file => this.handleFileAdded(file))
    this.dropzone.on('removedfile', () => this.setUploadDisabled(true))
    this.dropzone.on('sending', (_file, _xhr, formData) => this.setDataForUpload(formData))
    this.dropzone.on('error', () => this.setUploadDisabled(true))
  }

  listenToPublicFlagChanges() {
    this.publicFileInput.addEventListener('change', e => {
      this.isPublic = e.currentTarget.checked
      this.setAcceptedFiles(this.isPublic ? 'image/*,.pdf,' : 'all')
      this.reValidateFiles()
    })
  }

  reValidateFiles() {
    this.dropzone.files.slice().forEach(file => {
      this.dropzone.removeFile(file)
      this.dropzone.addFile(file)
    })
  }

  async uploadFile() {

    if (this.isPublic && this.publicFileWarningValue?.length) {

      const [title, warning] = this.publicFileWarningValue

      const res = await Swal.fire({
        titleText: title || 'Documento Público',
        text: warning || 'Vas a subir un documento público. ¿Deseas continuar?',
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

  handleFileAdded(file) {

    // wait for file resolution
    setTimeout(() => {
      if (file.status === 'error')
        this.showErrorIcon(true)

      else {
        this.showFeedbackIcon(file.type)
        this.nameInput.value = file.name.slice(0, file.name.lastIndexOf('.'))
      }
    }, 0)

    this.uploadMessage.classList.add('hidden')
    this.removeFileButton.classList.remove('hidden')
    this.setUploadDisabled(false)

    const errorIcon = document.querySelector('.dz-error-mark')

    if (errorIcon)
      errorIcon.style.display = 'none'
  }

  // Override
  showSpinner() {
    const spinnerContainer = document.querySelector('.dz-image')
    const spinner = document.createElement('span')
    spinner.classList.add('spinner-border', 'text-primary')

    spinnerContainer.replaceChildren(spinner)
    this.uploadButton.querySelector('.spinner-border').classList.remove('hidden')
    this.setUploadDisabled(true)
  }

  setUploadDisabled(disabled) {
    if (disabled)
      this.uploadButton.classList.add('disabled')
    else
      this.uploadButton.classList.remove('disabled')
  }

  showFeedbackIcon(type) {
    const [icon, iconColor] = this.getFeedBackIcon(type)

    if (!icon)
      return

    const imageContainer = document.querySelector('.dz-image')
    const iconElement = document.createElement('i')
    iconElement.classList.add('fa-solid', `fa-${icon}`, 'fs-3x', `text-${iconColor}`, `${iconColor ? 'opacity-75' : ''}`)

    imageContainer.replaceChildren(iconElement)
  }

  getFeedBackIcon(fileType) {
    const type = fileType.toLowerCase()

    const isPdf = type.includes('pdf')
    const isDoc = type.includes('document')
    const isExcel = type.includes("excel") || type.includes("csv") || type.includes("sheet")
    const isPowerPoint = type.includes("ppt") || type.includes("presentation")
    const isImage = type.includes('image')


    if (isPdf)
      return ['file-pdf', 'danger']

    else if (isPowerPoint)
      return ['file-powerpoint', 'orange']

    else if (isExcel)
      return ['file-excel', 'success']

    else if (isDoc)
      return ['file-word', 'primary']

    else if (isImage)
      return []

    else
      return ['file', 'gray-600']
  }

  setDataForUpload(formData) {
    const name = this.nameInput.value

    formData.append('name', name)
    formData.append('document_group_id', this.documentGroupValue)
    if (this.isPublic !== undefined)
      formData.append('public', this.isPublic)
  }

  removeFile() {
    this.dropzone.removeAllFiles(true)    // true = cancel uploads in progress
    this.showErrorIcon(false)

    this.nameInput.value = ''
    this.uploadMessage.classList.remove('hidden')
    this.removeFileButton.classList.add('hidden')
  }
}
