import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]

  connect() {
    console.log("'Context Menu controller' connected!")
    this.closeHandler = () => this.close()
  }

  open(event) {
    event.preventDefault()

    if (!this.hasMenuTarget) return

    const menu = this.menuTarget
    menu.style.position = "fixed"
    menu.style.left = `${event.clientX}px`
    menu.style.top = `${event.clientY}px`

    menu.classList.add("show")

    document.addEventListener("click", this.closeHandler, { once: true })
  }

  close() {
    this.menuTarget.classList.remove("show")
  }
}
