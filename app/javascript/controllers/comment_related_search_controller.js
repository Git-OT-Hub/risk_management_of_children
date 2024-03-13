import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="comment-related-search"
export default class extends Controller {
  static targets = ["userNameField", "bodyField", "searchBtn"]

  connect() {
    this.endPage();
  }

  startFullSearch() {
    this.userNameFieldTarget.value = '';
    this.bodyFieldTarget.value = '';
    this.searchBtnTarget.click();
  }

  endPage() {
    window.scrollTo({ top: document.body.scrollHeight, behavior: 'smooth' });
  }
}
