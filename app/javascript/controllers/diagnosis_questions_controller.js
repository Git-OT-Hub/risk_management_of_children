import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  
  static targets = ["start_diagnosis", "previous_button", "next_button", "submit_button", ...Array.from({length: 15}, (_, i) => `question_${i + 1}`)];
    
  connect() {
  }

  currentQuestion = 1;

  startDiagnosis() {
    this.start_diagnosisTarget.classList.add("visually-hidden");
    this[`question_${this.currentQuestion}Target`].classList.remove("visually-hidden");
    this.updateButtonVisibility();
  }

  updateButtonVisibility() {
    this.previous_buttonTarget.classList.toggle("visually-hidden", this.currentQuestion <= 1);
    this.next_buttonTarget.classList.toggle("visually-hidden", this.currentQuestion >= 15);
    this.submit_buttonTarget.classList.toggle("visually-hidden", this.currentQuestion !== 15);
  }
}
