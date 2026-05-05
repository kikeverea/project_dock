import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { modalId: String, action: String, object: Object }

  connect() {
    console.log("'Modal' controller connected", 'action:', this.actionValue)

    const modal = document.getElementById(this.modalIdValue)
    console.log('modal', modal)

    if (!modal) return

    this.closeHandler = () => this.hide(modal)
    this.overlayClickHandler = (e) => { if (e.target === modal) this.hide(modal) }

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
    this.createBackdrop()

    modal.classList.add("show")
    modal.querySelectorAll("[data-dismiss='modal']").forEach(btn => btn.addEventListener("click", this.closeHandler))
    modal.addEventListener("click", this.overlayClickHandler)
  }

  createBackdrop() {
    this.backdrop = document.createElement("div")
    this.backdrop.className = "modal-backdrop"
    this.backdrop.id = `${this.modalIdValue}-backdrop`

    document.body.appendChild(this.backdrop)
    document.body.style.overflow = "hidden"

    this.backdrop.addEventListener("click", this.closeHandler)
  }

  getBackdrop() {
    return this.backdrop || document.getElementById(`${this.modalIdValue}-backdrop`)
  }

  hide(modal) {
    modal.classList.remove("show")
    modal.removeEventListener("click", this.overlayClickHandler)

    this.hideBackdrop()
    document.body.style.overflow = ""
  }

  hideBackdrop() {
    this.getBackdrop().remove()
    this.backdrop = null
  }

  disconnect() {
    this.element.parentElement.replaceChildren()
  }
}
