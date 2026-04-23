import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { modalId: String, action: String, object: Object }
  static outlets = [ 'select2' ]

  connect() {
    const modal = document.getElementById(this.modalIdValue)
    if (!modal) return

    switch (this.actionValue) {
      case 'show':
      case 'open':
        this.show(modal)
        break
      case 'hide':
      case 'close':
        this.hide(modal)
        break
      default:
        throw new Error(`Unknown modal action: ${this.actionValue}`)
    }
  }

  show(modal) {
    this.backdrop = document.createElement("div")
    this.backdrop.className = "modal-backdrop"
    document.body.appendChild(this.backdrop)
    document.body.style.overflow = "hidden"

    modal.classList.add("show")

    this.closeHandler = () => this.hide(modal)
    this.overlayClickHandler = (e) => { if (e.target === modal) this.hide(modal) }
    modal.querySelectorAll("[data-bs-dismiss='modal']").forEach(btn =>
      btn.addEventListener("click", this.closeHandler)
    )
    modal.addEventListener("click", this.overlayClickHandler)
    this.backdrop.addEventListener("click", this.closeHandler)
  }

  hide(modal) {
    modal.classList.remove("show")
    modal.removeEventListener("click", this.overlayClickHandler)
    this.backdrop?.remove()
    this.backdrop = null
    document.body.style.overflow = ""
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
