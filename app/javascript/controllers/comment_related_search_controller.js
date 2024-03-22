import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="comment-related-search"
export default class extends Controller {
  static targets = ["userNameField", "bodyField", "searchBtn"]

  connect() {
  }

  startFullSearch() {
    this.userNameFieldTarget.value = '';
    this.bodyFieldTarget.value = '';
    this.searchBtnTarget.click();
  }
}
