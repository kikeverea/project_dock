import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static targets = [ 'item' ]
  static values = { searchAttributes: Array }

  connect() {
    console.log("'Search collection' controller connected")

    this.items = this.parse(this.itemTargets)
  }

  parse(items) {
    return Array.from(items).reduce((items, item) => {
      const content = JSON.parse(item.dataset.content)
      return { ...items, [content.id]: content }
    }, {})
  }

  search(e) {
    const input = e.currentTarget
    const search = input.value

    if (search)
      this.filter(search)
    else
      this.showAll()
  }

  filter(search) {
    for (const item of this.itemTargets) {
      const content = this.items[item.dataset.id]

      let matches

      for (const attribute of this.searchAttributesValue) {
        matches = content[attribute].toLowerCase().includes(search.toLowerCase())

        if (matches) break
      }

      if (matches)
        item.classList.remove('hidden')
      else
        item.classList.add('hidden')
    }
  }

  showAll() {
    for (const item of this.itemTargets) {
      item.classList.remove('hidden')
    }
  }
}
