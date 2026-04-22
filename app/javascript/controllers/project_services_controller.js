import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static targets = [ 'value', 'checkbox', 'sendError']
  static values = { projectId: String }
  static outlets = [ 'toast' ]

  connect() {
    console.log("'Project service_invoices' controller connected", this.projectIdValue)

    this.services = []
  }

  selectPendingServices(e) {
    const checkbox = e.currentTarget

    this.services = checkbox.checked
      ? this.checkboxTargets
          .filter(checkbox => checkbox.dataset.sent === 'false')
          .map(checkbox => (checkbox.checked = true, checkbox))
          .map(checkbox => checkbox.dataset.id)
      : (this.checkboxTargets.forEach(cb => { cb.checked = false; }), []);

    this.valueTarget.value = JSON.stringify(this.services)
  }

  selectService(e) {
    const checkbox = e.currentTarget

    const id = checkbox.dataset.id

    this.services = checkbox.checked
      ? [ ...this.services, id ]
      : this.services.filter(service => service !== id)

    this.valueTarget.value = JSON.stringify(this.services)
  }

  submitForm(e) {
    e.preventDefault()

    if (this.services.length)
      Turbo.navigator.submitForm(this.element)
    else {
      this.sendErrorTarget.style.opacity = 1
      setTimeout(() => this.sendErrorTarget.style.opacity = 0, 3000)
    }
  }

  changeBillingMethod(e) {
    const select = e.currentTarget
    const id = select.dataset.id
    const payload = { service: { billing_method: select.value }}

    this.send(id, payload, 'Tipo facturación actualizado')
  }

  changeInvoiceNumber(e) {
    const input = e.currentTarget
    const id = input.dataset.id
    const payload = { service: { invoice_number: input.value }}

    clearTimeout(this.invoiceNumberDebounce)

    this.invoiceNumberDebounce = setTimeout(() => this.send(id, payload, 'Número factura actualizado'), 500)
  }

  changeJobInvoiceNumber(e) {
    const input = e.currentTarget
    const id = input.dataset.id
    const serviceId = input.dataset.serviceId
    const payload = { service_job: { invoice_number: input.value }}

    clearTimeout(this.jobInvoiceNumberDebounce)

    this.jobInvoiceNumberDebounce =
      setTimeout(() => this.sendJob(id, serviceId, payload, 'Número factura actualizado'), 500)
  }

  send(id, payload, message) {
    this.sendRequest(`/projects/${this.projectIdValue}/services/${id}`, payload, message)
  }

  sendJob(id, serviceId, payload, message) {
    this.sendRequest(`/projects/${this.projectIdValue}/services/${serviceId}/service_jobs/${id}`, payload, message)
  }

  sendRequest(url, payload, message) {
    fetch(url, {
      method: 'PUT',
      headers: {
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content'),
        'Content-Type': 'application/json',
        'Accept': 'text/vnd.turbo-stream.html, text/html, application/xhtml+xml'
      },
      body: JSON.stringify(payload),
    })
    .then(response => response.ok)
    .then(() => {
      if (this.hasToastOutlet) this.toastOutlet.show(message)
    })
  }
}
