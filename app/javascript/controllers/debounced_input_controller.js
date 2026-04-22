import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static targets = [ 'field', 'icon' ]
  static values = { uploadUrl: String, attribute: String }

  connect() {
    console.log("'Debounced input controller' controller connected")

    this.blockSave = this.protectedViewValue

    this.autoSubmit()
  }

  autoSubmit() {
    let timeout

    this.fieldTarget.addEventListener('input', e => {
      const input = e.currentTarget
      clearTimeout(timeout)

      timeout = setTimeout(() => {

        fetch(this.uploadUrlValue, {
          method: 'PUT',
          headers: {
            'Content-Type': 'application/json',
            'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
          },
          body: JSON.stringify({ [this.attributeValue]: input.value })
        })
        .then(response => {
          if (response.ok) {
            this.showSaved()
            setTimeout(() => this.hideFeedback(), 2000)
          }
          else this.showError()
        })
      }, 850)

    })
  }

  showLoading() {
    this.iconTarget.classList.remove('fa-circle-xmark', 'text-success', 'text-danger')
    this.iconTarget.classList.add('fa-spinner', 'text-primary')
  }

  showSaved() {
    this.iconTarget.classList.remove('fa-spinner', 'text-primary')
    this.iconTarget.classList.add('fa-floppy-disk', 'text-success')
  }

  showError() {
    this.iconTarget.classList.remove('fa-spinner', 'text-primary')
    this.iconTarget.classList.add('fa-circle-xmark', 'text-danger')
  }

  hideFeedback() {
    this.iconTarget.classList.remove('fa-spinner', 'fa-circle-xmark', 'fa-floppy-disk')
  }
}
