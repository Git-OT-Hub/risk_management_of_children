import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  
  static targets = ["start_diagnosis", "previous_button", "next_button", "submit_button", "error_message", ...Array.from({length: 15}, (_, i) => `question_${i + 1}`)];
    
  currentQuestion = 1;

  connect() {
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

  updateActiveLabels() {
    const labels = this[`question_${this.currentQuestion}Target`].querySelectorAll('label');
    const currentQuestionRadioButtons = this[`question_${this.currentQuestion}Target`].querySelectorAll('input[type="radio"]');
    let selectedRadioButton = null;

    currentQuestionRadioButtons.forEach((radio) => {
      if (radio.checked) {
        selectedRadioButton = radio;
      }
    });

    labels.forEach((label) => {
      if (label.getAttribute('for') === selectedRadioButton.getAttribute('id')) {
        label.classList.add('active');
      } else {
        label.classList.remove('active');
      }
    });
  }

  nextQuestion() {
    const currentQuestionRadioButtons = this[`question_${this.currentQuestion}Target`].querySelectorAll('input[type="radio"]');
    let hasSelectedRadioButton = false;

    currentQuestionRadioButtons.forEach((radio) => {
      if (radio.checked) {
        hasSelectedRadioButton = true;
      }
    });

    if (!hasSelectedRadioButton) {
      this.error_messageTarget.classList.remove("visually-hidden");
      return;
    } else {
      this.error_messageTarget.classList.add("visually-hidden");
    }

    this[`question_${this.currentQuestion}Target`].classList.add("visually-hidden");
    this.currentQuestion++;
    this[`question_${this.currentQuestion}Target`].classList.remove("visually-hidden");

    this.updateButtonVisibility();
  }

  previousQuestion() {
    this[`question_${this.currentQuestion}Target`].classList.add("visually-hidden");
    this.currentQuestion--;
    this[`question_${this.currentQuestion}Target`].classList.remove("visually-hidden");

    this.error_messageTarget.classList.add("visually-hidden");
    this.updateButtonVisibility();
  }

  submitQuestions(event) {
    const currentQuestionRadioButtons = this[`question_${this.currentQuestion}Target`].querySelectorAll('input[type="radio"]');
    let hasSelectedRadioButton = false;

    currentQuestionRadioButtons.forEach((radio) => {
      if (radio.checked) {
        hasSelectedRadioButton = true;
      }
    });

    if (!hasSelectedRadioButton) {
      this.error_messageTarget.classList.remove("visually-hidden");
      event.preventDefault();
      return;
    } else {
      this.error_messageTarget.classList.add("visually-hidden");
    }
  }
}
