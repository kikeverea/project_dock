import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static targets = [ 'template', 'numbersContainer' ]

  connect() {
    console.log("'Phone Numbers' controller connected")

    this.index = this.numbersContainerTarget.childElementCount
  }

  addPhoneNumberRow() {
    const newPhoneNumberRowHTML = this.templateTarget.innerHTML.replace(/__INDEX__/g, this.index)
    this.numbersContainerTarget.insertAdjacentHTML("beforeend", newPhoneNumberRowHTML)
    this.index++
  }

  removePhoneNumber(e) {
    const deleteButton = e.currentTarget
    const phoneNumberRow = deleteButton.parentElement
    const destroyInput = phoneNumberRow.querySelector('input[name*=_destroy]')

    destroyInput.value = "1"
    phoneNumberRow.classList.add('d-none')
    this.index--
  }
}