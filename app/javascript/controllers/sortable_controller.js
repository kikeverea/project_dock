import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static values = { updateOrderUrl: String, modelName: String }
  static targets = [ 'itemsContainer' ]
  static outlets = [ 'toast' ]

  connect() {
    console.log("'Orderable' controller connected")
    this.initSortable()
  }

  toastOutletConnected(toast) {
    this.toast = toast
  }

  initSortable() {
    const sortableContainer = this.itemsContainerTarget

    const draggable = new Draggable.Sortable(sortableContainer, {
      draggable: '.draggable',
      handle: '.draggable .draggable-handle',
      distance: 10, // distance in px before a drag starts. Differentiates a drag form a click
      classes: {
        mirror: 'table-draggable-mirror'
      }
    })

    draggable.on('sortable:stop', () => {
      const itemIds =
        Array
          .from(this.itemsContainerTarget.children)
          .filter(item => !item.classList.contains('draggable--original') && !item.classList.contains('table-draggable-mirror'))
          .map(item => item.dataset.id)

      this.updateItemsOrder(itemIds)
    })
  }

  updateItemsOrder(items) {
    fetch(this.updateOrderUrlValue, {
      method: 'PUT',
      body: JSON.stringify({ [this.modelNameValue]: items }),
      headers: {
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content'),
        'Content-Type': 'application/json',
        'Accept': 'text/vnd.turbo-stream.html, text/html, application/xhtml+xml'
      }
    })
    .then(response => response.ok && response.json())
    .then(json => json?.ok && this.toast.show())
  }
}
