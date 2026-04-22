import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("'Alert' controller connected")
  }

  dismiss() {
    this.element.remove()
  }
}
