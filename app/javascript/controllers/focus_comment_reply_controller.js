import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="focus-comment-reply"
export default class extends Controller {
  static targets = ["focusObject"];

  connect() {
  }

  startFocusReply() {
    const previousFocusedElement = document.querySelector(`.card.border.border-danger-subtle.border-5[data-focus-comment-reply-target="focusObject"]`);
    if (previousFocusedElement) {
      previousFocusedElement.classList.remove("border", "border-danger-subtle", "border-5");
    }

    const parentId = event.currentTarget.dataset.parentId;
    const targetElement = document.querySelector(`[data-focus-comment-reply-target="focusObject"][data-parent-id="${parentId}"]`);
    
    if (targetElement) {
      targetElement.scrollIntoView({ behavior: 'smooth', block: 'center', inline: 'start' });
      targetElement.classList.add("border", "border-danger-subtle", "border-5");
    }
  }
}
