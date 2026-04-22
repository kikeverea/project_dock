import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static targets = [ 'item' ]

  connect() {
    console.log("'New Item' controller connected")
  }

  showForm(e) {
    const button = e.currentTarget

    button.classList.add('d-none')
    this.itemTarget.classList.replace('d-none', 'd-flex')
  }
}
