import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static targets = [ 'template', 'emailsContainer' ]

  connect() {
    console.log("'Emails' controller connected")

    this.index = this.emailsContainerTarget.childElementCount
  }

  addEmailRow() {
    const newEmailRowHTML = this.templateTarget.innerHTML.replace(/__INDEX__/g, this.index)
    this.emailsContainerTarget.insertAdjacentHTML("beforeend", newEmailRowHTML)

    this.index++
  }

  removeEmail(e) {
    console.log('here')
    const deleteButton = e.currentTarget
    const emailRow = deleteButton.parentElement
    const destroyInput = emailRow.querySelector('input[name*=_destroy]')

    destroyInput.value = "1"
    emailRow.classList.add('hidden')
    this.index--
  }
}
