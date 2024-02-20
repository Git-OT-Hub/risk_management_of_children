import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  
  static targets = ["start_diagnosis", "previous_button", "next_button", "submit_button", "all_questions", ...Array.from({length: 15}, (_, i) => `question_${i + 1}`)];
    
  currentQuestion = 1;

  connect() {
    this.addRadioListeners();
  }

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

  addRadioListeners() {
    this.all_questionsTargets.forEach((question) => {
      const radioButtons = question.querySelectorAll('input[type="radio"]');
      radioButtons.forEach((radio) => {
        radio.addEventListener('change', () => {
          this.updateActiveLabels(question, radio);
        });
      });
    });
  }

  updateActiveLabels(question, selectedRadio) {
    const labels = question.querySelectorAll('label');
    labels.forEach((label) => {
      if (label.getAttribute('for') === selectedRadio.getAttribute('id')) {
        label.classList.add('active');
      } else {
        label.classList.remove('active');
      }
    });
  }
}
