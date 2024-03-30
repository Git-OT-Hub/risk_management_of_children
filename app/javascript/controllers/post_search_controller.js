import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="post-search"
export default class extends Controller {
  static targets = ["userNameField", "postTitleField", "postBodyField", "postInfoField", "postCategoryField", "postMeritField", "postDemeritField", "postCommentsField", "searchBtn"]

  connect() {
  }

  startFullSearch() {
    this.userNameFieldTarget.value = '';
    this.postTitleFieldTarget.value = '';
    this.postBodyFieldTarget.value = '';
    this.postInfoFieldTarget.value = '';
    this.postCategoryFieldTarget.value = '';
    this.postMeritFieldTarget.value = '';
    this.postDemeritFieldTarget.value = '';
    this.postCommentsFieldTarget.value = '';
    this.searchBtnTarget.click();
  }
}
