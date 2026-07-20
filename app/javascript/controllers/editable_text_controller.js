import Toast from "./toast_controller"

const SUCCESS_COLOR = "text-green-600"
const SUCCESS_ICON = "fa-check-circle"
const FAIL_COLOR = "text-red-600"
const FAIL_ICON = "fa-exclamation-circle"
const EDITING_LIGHT = "text-blue-400"
const EDITING_DARK = "text-blue-700"

export default class extends Toast {
  static targets = ['input', 'editing', 'feedback']
  static values = { submitUrl: String, method: String, rowCharCount: Number }

  connect() {
    console.log("'Editable text' controller connected")

    this.inputTarget.addEventListener('input', () => {
      const rows = Math.ceil(this.inputTarget.value.length / parseFloat(this.rowCharCountValue))
      this.inputTarget.rows = Math.max(rows, 1)
    })

    this.inputTarget.addEventListener('focus', () => {
      this.#startEditing()
    })

    this.currentValue = this.inputTarget.value
  }

  submit(e) {
    e.preventDefault()

    if (!this.editing)
      return

    this.#stopEditing()

    const value = this.inputTarget.value

    if (value === this.currentValue)
      return

    fetch(this.submitUrlValue, {
      method: this.methodValue || 'PUT',
      headers: {
        'Accept': 'application/json',
        "Content-Type": "application/x-www-form-urlencoded",
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
      },
      body: new URLSearchParams({
        [this.inputTarget.name]: value
      })
    })
    .then(response => {
      if (response.ok)
        this.#showMessage('success')
      else
        this.#showMessage('fail')
    })
    .finally(() => {
      this.currentValue = null
    })
  }

  #showMessage(type) {
    const success = type === 'success'
    const text = this.feedbackTarget.querySelector('span')
    const icon = this.feedbackTarget.querySelector('i')

    this.feedbackTarget.classList.add(success ? SUCCESS_COLOR : FAIL_COLOR)
    this.feedbackTarget.classList.remove(success ? FAIL_COLOR : SUCCESS_COLOR)

    icon.classList.add(success ? SUCCESS_ICON : FAIL_ICON)
    icon.classList.remove(success ? FAIL_ICON : SUCCESS_ICON)

    text.textContent = success ? 'Cambios guardados' : 'Error al guardar'

    this.#showBriefly(this.feedbackTarget)
  }

  #startEditing() {
    this.editing = true
    this.currentValue = this.inputTarget.value

    this.editingTarget.classList.remove('hidden')
    this.editingTarget.classList.add('block')

    this.#blink(this.editingTarget)
  }

  #stopEditing() {
    this.editing = false
    this.inputTarget.blur()

    clearInterval(this.editingIntervalId)
    this.editingTarget.classList.remove(EDITING_DARK, EDITING_LIGHT, 'block')
    this.editingTarget.classList.add(EDITING_DARK, 'hidden')
  }

  #blink(element) {
    let dark = true

    this.editingIntervalId = setInterval(() => {
      element.classList.remove(dark ? EDITING_DARK : EDITING_LIGHT)
      element.classList.add(dark ? EDITING_LIGHT : EDITING_DARK)
      dark = !dark
    }, 700)
  }

  #showBriefly(element) {
    element.style.display = 'block'
    setTimeout(() => element.style.display = 'none', 2000)
  }
}
