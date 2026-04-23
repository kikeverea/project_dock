import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static values = { markPaidUrl: String }
  static targets = [ 'markPaidButtons' ]

  connect() {
    console.log("'Payments' controller connected")

    this.selectedPayments = []
  }

  selectPayment(e) {
    const checkbox = e.currentTarget
    const selected = checkbox.checked
    const paymentId = checkbox.dataset.paymentId

    this.selectedPayments = selected
      ? [...this.selectedPayments, paymentId ]
      : this.selectedPayments.filter(id => id !== paymentId)

    this.showButtons(!!this.selectedPayments.length)
  }

  showButtons(show) {
    if (show)
      this.markPaidButtonsTarget.classList.replace('hidden', 'flex')
    else
      this.markPaidButtonsTarget.classList.replace('flex', 'hidden')
  }

  markPaymentsPaid(_e) {
   this.sendPayments(true)
  }

  markPaymentsNotPaid(_e) {
   this.sendPayments(false)
  }

  sendPayments(paid) {
    fetch(this.markPaidUrlValue, {
      method: 'PUT',
      headers: {
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content'),
        'Content-Type': 'application/json',
        'Accept': 'text/vnd.turbo-stream.html, text/html, application/xhtml+xml'
      },
      body: JSON.stringify({
        payments: this.selectedPayments,
        status: paid ? 'paid' : 'unpaid'
      }),
    })
    .then(response => response.ok && response.text())
    .then(text => Turbo.renderStreamMessage(text))
    .finally(() => {
      this.showButtons(false)
      this.selectedPayments.length = 0
    })
  }
}
