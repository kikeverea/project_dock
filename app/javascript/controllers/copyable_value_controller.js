import { Controller } from "@hotwired/stimulus"


export default class extends Controller {
  static values = { content: String, shortFeedback: Boolean }
  static targets = [ 'copiedMessage' ]

  connect() {
    this.icon = this.element.querySelector('i')
  }

  copyValue() {
    console.log('copy value!', this.contentValue)
    navigator.clipboard.writeText(this.contentValue).then(() => {
      this.showCopiedMessage()
    })
    .catch(err => {
      console.error('Failed to copy to clipboard: ', err)
    })
  }

  hoverIn() {
    this.mouseIn = true
    this.showCopyIcon()
  }

  hoverOut() {
    this.mouseIn = false
    this.hideCopyIcon()
  }

  showCopyIcon(immediate) {
    if (immediate)
      this.icon.classList.remove('hidden')

    else
      this.icon.classList.add('visible')
  }

  hideCopyIcon(immediate) {
    if (immediate)
      this.icon.classList.add('hidden')

    else
      this.icon.classList.remove('visible')
  }

  showCopiedMessage() {

    if (this.shortFeedbackValue)
      this.copiedMessageTarget.classList.add('visible')

    else
      this.copiedMessageTarget.classList.remove('hidden')

    this.hideCopyIcon('immediate')

    setTimeout(() => {
      if (this.shortFeedbackValue)
        this.copiedMessageTarget.classList.remove('visible')

      else
        this.copiedMessageTarget.classList.add('hidden')

      this.showCopyIcon('immediate')
    }, 1000)
  }
}
