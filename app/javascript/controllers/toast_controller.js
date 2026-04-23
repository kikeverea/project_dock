import { Controller } from '@hotwired/stimulus'

export default class extends Controller {

  static targets = [ 'message' ]
  static values = { delay: Number, manual: Boolean }

  connect() {
    console.log("'Toast' controller connected")
    if (!this.manualValue)
      this.show()
  }

  show(message = '') {
    if (message) this.messageTarget.textContent = message

    this.element.style.display = 'flex'
    requestAnimationFrame(() => this.element.classList.add('show'))

    this.hideTimeout = setTimeout(() => this.hide(), this.delayValue || 2500)
  }

  hide() {
    clearTimeout(this.hideTimeout)
    this.element.classList.remove('show')
    this.element.addEventListener('transitionend',
      () => { this.element.style.display = 'none'},
      { once: true }
    )
  }

  disconnect() {
    clearTimeout(this.hideTimeout)
  }
}
