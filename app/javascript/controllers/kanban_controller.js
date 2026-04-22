import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static targets = [ 'board', 'column' ]
  static outlets = [ 'toast' ]
  static values = { params: Object }

  connect(onCardMoved) {
    // console.log("'Kanban' controller connected", this.paramsValue)

    this.initSortable(onCardMoved)

    this.boardTarget.addEventListener('mousedown', (e) => this.grab(e))
    this.boardTarget.addEventListener('mouseleave', (e) => this.letGo(e))
    this.boardTarget.addEventListener('mouseup', (e) => this.letGo(e))
    this.boardTarget.addEventListener('mousemove', (e) => this.drag(e))

    this.currentUser = this.paramsValue.current_user
  }

  toastOutletConnected(toast) {
    this.toast = toast
  }

  initSortable(onCardMoved) {
    const sortableContainers = this.columnTargets

    const draggable = new Draggable.Sortable(sortableContainers, {
      draggable: '.draggable',
      distance: 10,
    })

    draggable.on('sortable:stop', (event) => {
      const container = event.newContainer
      const card = container.children[event.newIndex + 1]

      const column = container.dataset.column
      const item = card.dataset.item

      onCardMoved(item, column)
    })
  }

  toggleFilter(e) {
    const checkbox = e.currentTarget
    const spinner = checkbox.parentElement.querySelector('.spinner-border')
    const checked = checkbox.checked

    spinner.classList.remove('d-none')
    checkbox.classList.add('d-none')

    const baseUrl = `${checkbox.dataset.url}`
    const queryParams = this.queryParams({ userId: checked ? this.currentUser : null })

    fetch(`${baseUrl}${queryParams}`, {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content'),
        'Accept': 'text/vnd.turbo-stream.html, text/html, application/xhtml+xml'
      }
    })
    .then(response => response.ok && response.text())
    .then(text => Turbo.renderStreamMessage(text))
  }

  grab(e) {
    e.preventDefault()
    document.documentElement.classList.add('no-select')

    this.grabbing = true
    this.startX = e.pageX - this.boardTarget.offsetLeft
    this.scrollLeft = this.boardTarget.scrollLeft

    this.boardTarget.classList.add('active')
    this.boardTarget.style.cursor = 'grabbing'
  }

  letGo() {
    this.grabbing = false
    this.boardTarget.style.cursor = 'grab'

    document.documentElement.classList.remove('no-select')
  }

  drag(e) {
    if (!this.grabbing)
      return

    e.preventDefault()

    const x = e.pageX - this.boardTarget.offsetLeft
    const walkX = x - this.startX
    this.boardTarget.scrollLeft = this.scrollLeft - walkX
  }
}
