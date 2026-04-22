import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  connect() {
    console.log("'Filter by user' controller connected")
  }

  toggleFilter(e) {
    const checkbox = e.currentTarget
    const spinner = checkbox.parentElement.querySelector('.spinner-border')
    const checked = checkbox.checked
    const filter = checked ? 'user' : 'all'
    const url = `${checkbox.dataset.url}?show=${filter}`

    spinner.classList.remove('d-none')
    checkbox.classList.add('d-none')

    fetch(url, {
      headers: {'Accept': 'text/vnd.turbo-stream.html, text/html, application/xhtml+xml'},
    })
    .then(response => response.ok && response.text())
    .then(text => {
      spinner.classList.add('d-none')
      checkbox.classList.remove('d-none')
      Turbo.renderStreamMessage(text)
    })
  }
}
