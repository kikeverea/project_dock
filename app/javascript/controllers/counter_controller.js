import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static values = { count: Number, limits: Array }
  static targets = [ 'value', 'count' ]

  connect() {
    // console.log("'Counter' controller connected")

    this.value = this.countValue
    this.setValue(this.value)

    this.min = this.limitsValue[0]
    this.max = this.limitsValue[1]
  }

  listenToCountChanges(listener) {
    this.listener = listener
    // listener(this.value)
  }

  increment() {
    if (this.max !== null && this.value + 1 > this.max)
      return

    this.setValue(++this.value)
  }

  decrement() {
    if (this.min !== null && this.value - 1 < this.min)
      return

    this.setValue(--this.value)
  }

  setValue(value) {
    this.valueTarget.value = value
    this.countTarget.textContent = value
    this.listener && this.listener(value)
  }

  getId() {
    return this.element.id
  }
}
