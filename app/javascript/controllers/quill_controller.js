import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static values = { content: String }
  static targets = [ 'quill', 'value' ]

  connect() {
    // console.log("'Quill' controller connected")

    const quill = new Quill(this.quillTarget, {
      theme: 'snow',
      modules: {
        toolbar: [
          [{ 'color': [] }, { 'background': [] }],
          [{ 'list': 'ordered' }, { 'list': 'bullet' }],
          ['bold', 'italic', 'underline'],
        ]
      }
    })

    quill.root.innerHTML = this.contentValue
    quill.on('text-change', () => this.valueTarget.value = quill.root.innerHTML)
  }
}
