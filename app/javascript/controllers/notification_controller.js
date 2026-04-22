import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  connect() {
    console.log("'Notification' controller connected")

    this.timeout = setTimeout(() => this.removeFromScreen(), 5000)
  }

  removeFromScreen() {
    clearTimeout(this.timeout)

    const notification = this.element

    notification.addEventListener("animationend", () => notification.classList.add("collapse"), { once: true })
    notification.addEventListener("transitionend", () => notification.remove(), { once: true })

    notification.classList.add("hide")
  }
}

