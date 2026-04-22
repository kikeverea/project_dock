import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static values = { item: Object }
  static outlets = ['select2']

  connect() {
    console.log("'Add to select2' controller connected'")
  }

  select2OutletConnected(select2) {
    select2.onItemCreated(this.itemValue)
  }
}
