import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static targets = [ 'startDate', 'endDate', 'startDateError', 'endDateError' ]
  static values = { submitId: String }

  connect() {
    console.log("'Date Group' controller connected")

    this.errors = 0
  }

  setStartDate(e) {
    const startDate = Date.parse(e.currentTarget.value)
    const endDate = this.getDate(this.endDateTarget)

    if (!endDate)
      this.endDateTarget.value = e.currentTarget.value

    this.validateDates(startDate, endDate|| startDate)
  }

  setEndDate(e) {
    const endDate = Date.parse(e.currentTarget.value)
    const startDate = this.getDate(this.startDateTarget)

    if (!startDate) {
      this.startDateTarget.value = e.currentTarget.value
      return
    }

    this.validateDates(startDate || endDate, endDate)
  }

  validateDates(startDate, endDate) {

    if (startDate < Date.now())
      this.showError(this.startDateErrorTarget, 'No puede ser en el pasado')
    else if (startDate > endDate)
      this.showError(this.startDateErrorTarget, 'No puede ser mayor que la fecha final')
    else
      this.hideError(this.startDateErrorTarget)

    if (endDate < startDate)
      this.showError(this.endDateErrorTarget, 'No puede ser menor que la fecha inicial')
    else
      this.hideError(this.endDateErrorTarget)
  }

  showError(target, error) {
    target.classList.replace('d-none', 'd-block')
    target.textContent = error
    this.errors++
    this.getSubmit().classList.add('disabled')
  }

  hideError(target) {
    target.classList.replace('d-block', 'd-none')

    if (--this.errors === 0)
      this.getSubmit().classList.remove('disabled')
  }

  getSubmit() {
    return document.getElementById(this.submitIdValue)
  }

  getDate(target) {
    const date = target.value
    return date ? Date.parse(date) : null
  }
}
