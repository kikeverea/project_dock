import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ 'content', 'icon' ]
  static values = { expandWidth: String }

  toggle() {
    const expanded = this.contentTarget.classList.toggle('hidden')
    this.iconTarget.classList.toggle('text-sky-600', !expanded)

    if (this.hasExpandWidthValue) {

    }

  }
}
