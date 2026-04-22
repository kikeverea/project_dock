import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static values = { uploadUrl: String, content: String, attribute: String, protectedView: Boolean, small: Boolean }
  static targets = [ 'quill', 'saveMessage', 'saveMessageIcon', 'editModeWarning', 'dragAnchor' ]

  connect() {
    // console.log("'Text Editor' controller connected")

    this.quill = new Quill(this.quillTarget, {
      theme: 'snow',
      modules: {
        toolbar: [
          [{ 'header': '1' }, { 'header': '2' }, { 'header': '3' }, { 'font': [] }],
          [{ 'size': ['small', false, 'large', 'huge'] }],
          [{ 'color': [] }, { 'background': [] }],
          [{ 'list': 'ordered' }, { 'list': 'bullet' }],
          ['bold', 'italic', 'underline'],
          ['link'],
          [{ 'align': [] }],
        ]
      }
    })

    this.quill.root.innerHTML = this.contentValue || ''

    this.blockSave = this.protectedViewValue

    if (this.hasDragAnchorTarget)
      this.listenToResize()

    this.autoSave(this.quill)
  }

  listenToResize() {
    this.quilContainer = this.dragAnchorTarget.parentElement

    this.dragAnchorTarget.addEventListener('pointerdown', (e) => {
      e.preventDefault()

      this.dragAnchorTarget.setPointerCapture(e.pointerId)
      this.drag = { y: e.clientY, startHeight: this.quilContainer.offsetHeight }
    })

    this.dragAnchorTarget.addEventListener('pointermove', (e) => {
      if (!this.drag) return

      const delta = e.clientY - this.drag.y
      this.quilContainer.style.height = `${Math.max(this.drag.startHeight + delta, 150)}px`
    })

    this.dragAnchorTarget.addEventListener('pointerup', (e) => {
      this.drag = null
      this.dragAnchorTarget.releasePointerCapture(e.pointerId)
    })
  }

  disconnect() {
    this.quill.on('text-change', () => {})
  }

  autoSave(quill) {
    if (!this.uploadUrlValue || !this.attributeValue)
      return

    let timeoutId

    quill.on('text-change', () => {

      if (this.blockSave)
        return

      clearTimeout(timeoutId)

      timeoutId = setTimeout(() => {
        const content = quill.root.innerHTML

        this.showLoading()

        fetch(`${this.uploadUrlValue}.json`, {
          method: 'PUT',
          headers: {
            'Content-Type': 'application/json',
            'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
          },
          body: JSON.stringify({ [this.attributeValue]: content })
        })
        .then(response => {
          if (response.ok) {
            this.showSaved()
            setTimeout(() => this.hideFeedback(), 2000)
          }
          else this.showError()
        })
      },
      850)
    })
  }

  enableEdit(e) {
    const button = e.currentTarget

    button.classList.add('d-none')
    this.editModeWarningTarget.classList.remove('d-none')

    this.blockSave = false
  }

  showLoading() {
    if (!this.smallValue) {
      this.saveMessageTarget.classList.remove('text-danger', 'text-success')
      this.saveMessageTarget.textContent = 'Guardando'
      this.saveMessageTarget.classList.add('text-primary')
    }

    this.saveMessageIconTarget.classList.remove('fa-circle-xmark', 'text-danger', 'text-success')
    this.saveMessageIconTarget.classList.add('fa-spinner', 'text-primary')
  }

  showSaved() {
    if (!this.smallValue) {
      this.saveMessageTarget.textContent = 'Cambios guardados!'
      this.saveMessageTarget.classList.add('text-success')
    }

    this.saveMessageIconTarget.classList.remove('fa-spinner', 'text-primary')
    this.saveMessageIconTarget.classList.add('fa-floppy-disk', 'text-success')
  }

  showError() {
    if (!this.smallValue) {
      this.saveMessageTarget.textContent = 'Cambios sin guardar'
      this.saveMessageTarget.classList.add('text-danger')
    }

    this.saveMessageIconTarget.classList.remove('fa-spinner', 'text-primary')
    this.saveMessageIconTarget.classList.add('fa-circle-xmark', 'text-danger')
  }

  hideFeedback() {
    if (!this.smallValue)
      this.saveMessageTarget.textContent = ''

    this.saveMessageIconTarget.classList.remove('fa-spinner', 'fa-circle-xmark', 'fa-floppy-disk')
  }
}
