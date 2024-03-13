import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = []

  connect() {
    
  }

  topPage() {
    window.scrollTo({ top: 0, behavior: 'smooth' });
  }

  endPage() {
    window.scrollTo({ top: document.body.scrollHeight, behavior: 'smooth' });
  }
}
