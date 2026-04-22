import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.menu = this.element.parentElement.querySelector(".dropdown-menu")
    const dismiss = this.menu.querySelector("[data-dismiss=menu]")

    this.ignoreBlurCallback = () => this.ignoreBlur = true

    for (const menuItem of this.menu.children)
      menuItem.addEventListener("mousedown", this.ignoreBlurCallback)

    if (dismiss)
      dismiss.addEventListener("click", () => this.hide())
  }

  disconnect() {
    for (const menuItem of this.menu.children)
      menuItem.removeEventListener("mousedown", this.ignoreBlurCallback)
  }

  toggle() {
    this.menu.classList.toggle("show")
  }

  hide() {
    this.menu.classList.remove("show")
  }

  handleBlur() {
    if (this.ignoreBlur) {
      this.ignoreBlur = false
      return
    }

    this.hide()
  }
}
