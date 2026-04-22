import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  connect() {
    // console.log("'Hue Bee' controller connected")

    new Huebee(this.element)
  }
}