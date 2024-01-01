import { Controller } from "@hotwired/stimulus"

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
      this.createPreview(file, previews);
    }
  }

  createPreview(file, previews) {
    let reader = new FileReader();
    let controller = this;

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

      let cancelButton = document.createElement("button");
      cancelButton.textContent = "取り消し";
      cancelButton.classList.add("btn", "btn-danger", "mb-2");
      cancelButton.addEventListener("click", function () {
        previewContainer.remove();
        controller.removeFileFromInput(file);
      });

      previewContainer.appendChild(cancelButton);

      previews.appendChild(previewContainer);
    };

    if (file) {
      reader.readAsDataURL(file);
    }
  }

  removeFileFromInput(file) {
    let input = this.inputTarget;
    let files = Array.from(input.files);
    let newFiles = files.filter(f => f !== file);

    let newTransfer = new DataTransfer();

    newFiles.forEach(f => newTransfer.items.add(f));

    input.files = newTransfer.files;
  }
}
