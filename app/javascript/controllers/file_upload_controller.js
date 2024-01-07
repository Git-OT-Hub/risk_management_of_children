import { Controller } from "@hotwired/stimulus";
import { DirectUpload } from "@rails/activestorage";

export default class extends Controller {
  static targets = ['fileInput', 'hiddenFields', 'previews', 'validationImages'];

  connect() {
    this.fileInputTarget.addEventListener('change', this.handleFileChange.bind(this));
  }

  handleFileChange(event) {
    const files = event.target.files;

    Array.from(files).forEach(file => {
      const uploader = new DirectUpload(file, '/rails/active_storage/direct_uploads');

      uploader.create((error, blob) => {
        if (error) {
          console.error(error);
        } else {
          const fileName = blob.filename;
          const signedId = blob.signed_id;
          this.addHiddenField(signedId);
          this.addPreview(signedId, fileName);
          this.resetFileField();
        }
      });
    });
  }

  addHiddenField(signedId) {
    const hiddenFields = this.hiddenFieldsTarget;
    const hiddenField = document.createElement('input');
    hiddenField.type = 'hidden';
    hiddenField.name = 'post[images][]';
    hiddenField.value = signedId;
    hiddenFields.appendChild(hiddenField);
  }

  addPreview(signedId, fileName) {
    const previews = this.previewsTarget;
    const previewDiv = document.createElement('div');
    previewDiv.classList.add('image-preview', 'mb-4');
    previewDiv.dataset.signedId = signedId;
    const previewImage = document.createElement('img');
    previewImage.src = `/rails/active_storage/blobs/${signedId}/download`;
    previewImage.classList.add('img-fluid', 'rounded-4', 'mb-2');

    const fileNameParagraph = document.createElement('p');
    fileNameParagraph.textContent = fileName;

    const cancelButton = document.createElement('button');
    cancelButton.textContent = '削除';
    cancelButton.type = 'button';
    cancelButton.classList.add("btn", "btn-danger", "rounded-pill", "mb-4");
    cancelButton.addEventListener('click', () => this.removePreview(signedId));

    previewDiv.appendChild(previewImage);
    previewDiv.appendChild(fileNameParagraph);
    previewDiv.appendChild(cancelButton);
    previews.appendChild(previewDiv);
  }

  removePreview(signedId) {
    const previews = this.previewsTarget;
    const hiddenFields = this.hiddenFieldsTarget;

    const previewToRemove = previews.querySelector(`[data-signed-id="${signedId}"]`);
    if (previewToRemove) {
      previewToRemove.remove();
    }

    const hiddenFieldToRemove = hiddenFields.querySelector(`input[value="${signedId}"]`);
    if (hiddenFieldToRemove) {
      hiddenFieldToRemove.remove();
    }
  }

  resetFileField() {
    this.fileInputTarget.value = ''; 
  }

  deleteImage(event) {
    event.preventDefault();
    const targetIndex = event.target.dataset.index;
    const targetElement = this.validationImagesTarget.querySelector(`[data-index="${targetIndex}"]`);

    if (targetElement) {
      targetElement.remove();
    }
  }
}
