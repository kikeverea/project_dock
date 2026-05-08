import Tooltip from "./tooltip_controller"

export default class extends Tooltip {

  static values = {
    model: String,
    modelGender: String,
    itemName: String,
    message: String,
    reversible: Boolean,
    reversibleMessage: String,
    actionName: String,
    method: String,
    showTooltip: Boolean,
  }

  connect() {
    super.connect(!this.showTooltipValue)
    // console.log("Controller 'Delete button' connected")

    this.element.addEventListener("click", e => this.deleteAction(e))
    this.element.dataset.turbo = 'false'
  }

  async deleteAction(e) {
    e.preventDefault()

    let message

    if (this.messageValue)
      message = this.messageValue
    else if (this.modelValue)
      message = `¿Estás seguro de que deseas ${this.actionNameValue || 'eliminar'} ${this.modelGenderValue.toLowerCase() === 'f' ? 'esta' : 'este'} ${this.modelValue}?`
    else if (this.itemNameValue)
      message = `¿Estás seguro de que deseas ${this.actionNameValue || 'eliminar'} '${this.itemNameValue}?'`
    else
      message = '¿Estás seguro?'

    const actionName = this.actionNameValue || 'eliminar'
    const confirmButtonLabel = `${actionName[0].toUpperCase()}${actionName.substring(1)}`
    const cancelButtonLabel = confirmButtonLabel === 'Cancelar' ? 'Cerrar' : 'Cancelar'

    const res = await Swal.fire({
      titleText: message,
      text: this.reversibleValue ? null : this.reversibleMessageValue || 'Esta acción es irreversible',
      icon: "error",
      showCancelButton: true,
      reverseButtons: true,
      confirmButtonText: confirmButtonLabel,
      cancelButtonText: cancelButtonLabel,
      customClass: {
        confirmButton: "btn btn-danger",
        cancelButton: "btn btn-secondary",
      }
    })

    if (res.isConfirmed) {

      console.log('href', this.element.href)
      console.log('action', this.element.parentElement.action)

      fetch(this.element.href || this.element.parentElement.action, {
        method: this.methodValue || 'DELETE',
        follow: 'manual',
        headers: {
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content'),
          'Accept': 'text/vnd.turbo-stream.html, text/html, application/xhtml+xml'
        }
      })
      .then(response => {
        if (response.redirected)
          window.location.href = response.url
        else {
          response.text().then(html => {
            Turbo.renderStreamMessage(html)
          })
        }
      })
    }
  }
}
