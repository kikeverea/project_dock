import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("'Tooltip' controller connected")

    this.text = this.element.getAttribute("title")
    if (!this.text) return

    // Suppress the native browser tooltip
    this.element.removeAttribute("title")
    this.element.setAttribute("data-tooltip", this.text)

    this.showCallback = () => this.show()
    this.hideCallback = () => this.hide()

    this.element.addEventListener("mouseenter", this.showCallback)
    this.element.addEventListener("mouseleave", this.hideCallback)
  }

  disconnect() {
    this.hide()
    this.element.removeEventListener("mouseenter", this.showCallback)
    this.element.removeEventListener("mouseleave", this.hideCallback)
  }

  show() {
    this.tooltip = document.createElement("div")
    this.tooltip.textContent = this.text
    this.tooltip.className = "pointer-events-none fixed z-[9999] px-4 py-2 text-sm bg-white text-gray-800 rounded shadow whitespace-nowrap"

    document.body.appendChild(this.tooltip)
    this.position()
  }

  hide() {
    this.tooltip?.remove()
    this.tooltip = null
  }

  position() {
    const rect = this.element.getBoundingClientRect()
    const tip  = this.tooltip.getBoundingClientRect()

    let top  = rect.top - tip.height - 6
    let left = rect.left + (rect.width - tip.width) / 2

    // Flip to bottom if it would go off the top of the viewport
    if (top < 0) top = rect.bottom + 6

    this.tooltip.style.top  = `${top}px`
    this.tooltip.style.left = `${Math.max(4, left)}px`
  }
}
