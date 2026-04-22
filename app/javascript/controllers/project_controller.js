import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static targets = [ 'maintenanceCancellationMotive' ]

  connect() {
    console.log("'Project' controller connected")
  }

  maintenanceChange(e) {
    console.log('called')
    const select = e.currentTarget

    if (select.value === 'paused')
      this.maintenanceCancellationMotiveTarget.classList.remove('d-none')
    else
      this.maintenanceCancellationMotiveTarget.classList.add('d-none')
  }
}
