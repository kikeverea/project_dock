import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  connect() {
    console.log("'Blink' controller connected")
    this.blink()
  }

  blink() {
    this.timeout = setTimeout(() => {
      this.element.classList.toggle('invisible')
      this.blink()
    }, 800)
  }

  disconnect() {
    clearTimeout(this.timeout)
  }
}
