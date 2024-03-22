import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="focus-comment"
export default class extends Controller {
  static targets = ["focusObject"];

  connect() {
  }

  startFocusComment() {
    const previousFocusedElement = document.querySelector(`.card.shadow-lg.border.border-danger-subtle.border-5[data-focus-comment-target="focusObject"]`);
    if (previousFocusedElement) {
      previousFocusedElement.classList.remove("border", "border-danger-subtle", "border-5");
    }

    const focusId = event.currentTarget.dataset.focusId;
    const targetElement = document.querySelector(`[data-focus-comment-target="focusObject"][data-focus-id="${focusId}"]`);
    
    if (targetElement) {
      targetElement.scrollIntoView({ behavior: 'smooth', block: 'center', inline: 'start' });
      targetElement.classList.add("border", "border-danger-subtle", "border-5");
    }
  }
}
