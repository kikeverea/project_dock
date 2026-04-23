import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static targets = [ 'item' ]

  connect() {
    console.log("'New Item' controller connected")
  }

  showForm(e) {
    const button = e.currentTarget

    button.classList.add('hidden')
    this.itemTarget.classList.replace('hidden', 'flex')
  }
}
