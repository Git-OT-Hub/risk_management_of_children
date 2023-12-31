import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="previews"
export default class extends Controller {
  static targets = ["input", "previews"]

  connect() {
  }

  preview() {
    let input = this.inputTarget;
    let previews = this.previewsTarget;
    let files = input.files;

    previews.innerHTML = "";

    for (let i = 0; i < files.length; i++) {
      let file = files[i];
      let reader = new FileReader();

      reader.onloadend = function () {
        let img = document.createElement("img");
        img.src = reader.result;
        img.classList.add("img-fluid", "rounded-4");

        let previewContainer = document.createElement("div");
        previewContainer.classList.add("image-preview", "mb-4");
        previewContainer.appendChild(img);

        let fileNameElement = document.createElement("p");
        fileNameElement.textContent = file.name;
        previewContainer.appendChild(fileNameElement);

        previews.appendChild(previewContainer);
      };

      if (file) {
        reader.readAsDataURL(file);
      }
    }
  }
}
