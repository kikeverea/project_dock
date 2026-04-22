import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static values = { message: String }

  connect() {
    console.log("'Loading button' controller connected")

    const spinner = document.createElement('span')
    spinner.classList.add('spinner-border', 'spinner-border-sm')

    this.clickListener = () => {
      this.element.prepend(spinner)
      this.element.textContent = this.messageValue || "Espera..."
    }

    this.element.addEventListener('click', this.clickListener)
  }

  disconnect() {
    this.element.removeEventListener('click', this.clickListener)
  }
}
