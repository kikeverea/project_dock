import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static targets = [
    'availableItemsContainer',
    'selectedItemsContainer',
    'noAvailableItemsMessage',
    'noSelectedItemsMessage',
    'value'
  ]

  connect() {
    console.log("'Pick List Controller' connected")

    this.state = {
      availableItems: Array
        .from(this.availableItemsContainerTarget.children)
        .map(item =>
          !item.classList.contains('empty-message') &&
          item.dataset.selected !== 'true' &&
          [item.id, item.dataset.name])
        .filter(item => !!item),
      selectedItems: Array
        .from(this.selectedItemsContainerTarget.children)
        .map(item =>
          !item.classList.contains('empty-message') &&
          item.dataset.selected === 'true' &&
          [item.id, item.dataset.name])
        .filter(item => !!item)
    }

    this.updateDOM()

    if (this.changeListener)
      this.changeListener.setSelectedItems([...this.state.selectedItems])
  }

  listenToItemChanges(listener) {
    this.changeListener = listener

    if (this.state)
      this.changeListener.setSelectedItems([...this.state.selectedItems])
  }

  updateDOM() {
    for (const item of this.availableItemsContainerTarget.children) {
      const show = this.findInAvailable(item)
      this.showElement(item, show && !this.findInSelected(item))
    }

    for (const item of this.selectedItemsContainerTarget.children) {
      const show = this.findInSelected(item)
      this.showElement(item, show, true)
    }

    this.valueTarget.value = JSON.stringify(this.state.selectedItems)

    this.showElement(this.noAvailableItemsMessageTarget, this.state.availableItems.length === 0)
    this.showElement(this.noSelectedItemsMessageTarget, this.state.selectedItems.length === 0)
  }

  searchAvailable(e) {
    const input = e.target

    this.state.availableItemsFilter = input.value
    this.updateDOM()
  }

  searchSelected(e) {
    const input = e.target

    this.state.selectedItemsFilter = input.value
    this.updateDOM()
  }

  moveToOpposite(e) {
    const item = e.currentTarget

    console.log('selected', this.state.selectedItems)
    console.log('wrong?', this.state.availableItems.filter(([id]) => this.state.availableItems.includes(id)))

    const inAvailable = this.state.availableItems.find(([itemId]) => {
      console.log('finding', itemId)
      return item.id === itemId
    })

    console.log('inAvailable', inAvailable)

    if (inAvailable)
      this.moveToSelected(item)
    else
      this.moveToAvailable(item)

    this.changeListener.setSelectedItems([...this.state.selectedItems])
  }

  moveToSelected(item) {
    console.log('moveToSelected', item)
    this.state.availableItems = this.state.availableItems.filter(([itemId]) => itemId !== item.id)
    this.state.selectedItems.push([item.id, item.dataset.name])
    this.updateDOM()
  }

  moveToAvailable(item) {
    this.state.selectedItems = this.state.selectedItems.filter(([itemId]) => itemId !== item.id)
    this.state.availableItems.push([item.id, item.dataset.name])
    this.updateDOM()
  }

  findInAvailable(item) {
    return this.state.availableItems.find(([itemId]) => {
      const inAvailable = item.id === itemId
      const passesFilter = !this.state.availableItemsFilter || item.textContent.toLowerCase().includes(this.state.availableItemsFilter.toLowerCase())

      return inAvailable && passesFilter
    })
  }

  findInSelected(item) {
    return this.state.selectedItems.find(([itemId]) => {
      const inSelected = item.id === itemId
      const passesFilter = !this.state.selectedItemsFilter || item.dataset.name.toLowerCase().includes(this.state.selectedItemsFilter.toLowerCase())

      return inSelected && passesFilter
    })
  }

  showElement (item, show, selected) {
    if (show) {
      item.classList.remove('d-none')
      item.classList.add('d-flex')
      item.dataset.selected = selected
    }
    else {
      item.classList.add('d-none')
      item.classList.remove('d-flex')
      item.dataset.selected = !selected
    }
  }
}