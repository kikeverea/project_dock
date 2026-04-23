import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static targets = [ 'searchInput', 'indicator', 'perPage' ]
  static values = [ 'ransackQuery', 'page', 'perPage' ]

  connect() {
    console.log("'Ransack' controller connected")

    this.sendSearchRequest = this.debounce(() => this.sendRansack())
    this.form = this.element

    if (this.ransackQueryValue)
      this.searchInputTarget.focus()
  }

  search() {
    this.indicatorTarget.classList.remove('hidden')
    this.sendSearchRequest()
  }

  debounce(func) {
    let timeout
    return () => {
      clearTimeout(timeout)
      timeout = setTimeout(func, 300)
    }
  }

  setItemsPerPage(perPage) {
    this.perPageTarget.value = perPage
    this.form.requestSubmit()
  }

  sendRansack() {
    this.form.requestSubmit()
    setTimeout(() => this.indicatorTarget.classList.add('hidden'), 100)
  }

  exportExcel() {
    const params = new URLSearchParams();

    for (const [key, value] of new FormData(this.form).entries()) {
      if (!value || value instanceof File)
        continue;

      params.append(key, value);
    }

    window.location.href = `${this.form.action}.xlsx?${params.toString()}`
  }
}
