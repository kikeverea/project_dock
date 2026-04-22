import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static targets = ["addProposal", "newProposal"]

  connect() {
    console.log("'Proposals' controller connected")
  }

  showNewProposal() {
    this.newProposalTarget.classList.remove('d-none')
    this.addProposalTarget.classList.add('d-none')
  }

}
