import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static targets = [ 'searchItem' ]

  connect() {
    // console.log("'Search' controller connected")
    this.searchValues = this.parseValues(this.searchItemTargets)
  }

  parseValues(items) {
    return items.reduce((values, item) => {
      const searchValue = JSON.parse(item.dataset.searchValue)
      const id = item.dataset.id

      values[id] = searchValue
      return values
    },
    {})
  }

  searchItems(e) {
    const input = e.currentTarget
    const search = input.value

    if (search)
      this.filterItems(search)

    else
      this.showAllItems()
  }

  filterItems(search) {
    for (const item of this.searchItemTargets) {
      const searchValue = this.searchValues[item.dataset.id]

      const matchesSearch = Object.values(searchValue).some(value =>
        value.toLowerCase().includes(search.toLowerCase()))

      if (matchesSearch)
        item.classList.remove('d-none')
      else
        item.classList.add('d-none')
    }
  }

  showAllItems() {
    for (const item of this.searchItemTargets) {
      item.classList.remove('d-none')
    }
  }
}

