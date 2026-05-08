import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ 'content', 'icon' ]
  static values = { autoExpand: Boolean }

  connect() {
    console.log("'Expanded' controller connected")

    this.target = this.hasContentTarget ? this.contentTarget : this.element
    const isCollapsed = this.target.classList.contains('hidden')

    if (this.autoExpandValue && isCollapsed)
      requestAnimationFrame(() => this.toggle())
  }

  toggle() {
    const expanded = this.target.classList.toggle('hidden')
    this.iconTarget.classList.toggle('text-sky-600', !expanded)
  }
}
