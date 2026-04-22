import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static targets = [ 'removeFilters', 'startDateISO','endDateISO' ]

  connect() {
    // console.log("'Table Filter' controller connected")
  }

  showRemoveFilters() {
    const inputs = this.element.querySelectorAll('input, select')

    const hasFilter = Array
      .from(inputs)
      .some(input => input.type === 'checkbox' ? input.checked : !!input.value)

    if (hasFilter)
      this.removeFiltersTarget.classList.remove('d-none')
    else
      this.removeFiltersTarget.classList.add('d-none')
  }

  showRemoveFilterIndicator(e) {
    const button = e.currentTarget

    const closeIcon = button.querySelector('.close-icon')
    const indicator = button.querySelector('.indicator')

    closeIcon.classList.add('d-none')
    indicator.classList.remove('d-none')
  }

  startDateChange (e) {
    const date = e.currentTarget.value

    this.startDateISOTarget.value = date ? new Date(date).toISOString() : ""
  }

  endDateChange (e) {
    const dateValue = e.currentTarget.value

    const date = new Date(dateValue)
    date.setHours(23, 59, 59, 999)

    this.endDateISOTarget.value = date.toISOString()
  }
}
