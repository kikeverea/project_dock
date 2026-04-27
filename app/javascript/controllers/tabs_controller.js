import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  switch(event) {
    event.preventDefault()

    const link = event.currentTarget
    const targetId = link.getAttribute("href")?.replace("#", "")
    if (!targetId) return

    this.element.querySelectorAll(".nav-link").forEach(l => l.classList.remove("active"))
    link.classList.add("active")

    this.element.querySelectorAll(".tab-pane").forEach(p => p.classList.remove("show", "active"))
    const pane = this.element.querySelector(`#${targetId}`)

    if (pane) {
      pane.classList.add("active")
      requestAnimationFrame(() => pane.classList.add("show"))
    }
  }
}
