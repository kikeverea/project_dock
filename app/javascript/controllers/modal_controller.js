import { Controller } from "@hotwired/stimulus"
export default class extends Controller {

  static values = { modalId: String, action: String, object: Object }
  static outlets = [ 'select2' ]

  connect() {
    console.log("'Modal' controller connected")

    const modalElement = document.getElementById(this.modalIdValue)
    const modal = bootstrap.Modal.getOrCreateInstance(modalElement)

    switch (this.actionValue) {
      case 'show':
      case 'open':
        modal.show()
        break

      case 'hide':
      case 'close':
        modal.hide()
        break

      default:
        throw new Error(`Unknown action value: ${this.actionValue}`)
    }
  }

  select2OutletConnected(outlet) {
    if ('id' in this.objectValue) {
      const { id, name } = this.objectValue
      outlet.addAndSelectItem(id, name || id)
    }
  }

  disconnect() {
    this.element.parentElement.replaceChildren()
  }
}
