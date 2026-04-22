import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static outlets = [ 'ransack' ]

  connect() {
    // console.log("'Paginator' controller connected")
  }

  setPerPage(e) {
    const select = e.currentTarget
    this.ransackOutlet.setItemsPerPage(select.value)
  }
}
