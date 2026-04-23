import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static targets = ["addProposal", "newProposal"]

  connect() {
    console.log("'Proposals' controller connected")
  }

  showNewProposal() {
    this.newProposalTarget.classList.remove('hidden')
    this.addProposalTarget.classList.add('hidden')
  }

}
