import { Controller } from "@hotwired/stimulus";
import { DirectUpload } from "@rails/activestorage";

export default class extends Controller {
  static targets = ['fileInput', 'hiddenFields', 'previews', 'validationImages'];

  connect() {
    this.fileInputTarget.addEventListener('change', this.handleFileChange.bind(this));
  }

  handleFileChange(event) {
    const files = event.target.files;

    // 枚数制限を超える場合はアラートを表示して中止
    const currentPreviewsCount = this.previewsTarget.children.length;
    const currentValidationImagesCount = this.validationImagesTarget.children.length;
    const newFileCount = files.length;
    const totalCount = currentPreviewsCount + currentValidationImagesCount + newFileCount
    if (totalCount > 4) {
      alert("画像は 4枚以下 にしてください。");
      this.fileInputTarget.value = '';
      return;
    }

    const allowExtensions = /\.(jpeg|jpg|png|gif)$/i;
    // 5MBを超える画像が添付されている場合または、許可さえていない拡張子が含まれる場合、アラートを表示して中止
    for (let i = 0; i < files.length; i++) {
      if (files[i].size > 5 * 1024 * 1024) {
        alert("5MBを超える画像が添付されています。");
        this.fileInputTarget.value = '';
        return;
      }

      if (!files[i].name.match(allowExtensions)) {
        alert("ファイル形式が jpeg, jpg, png, gif 以外のファイルは、添付できません。");
        this.fileInputTarget.value = '';
        return;
      }
    }

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
    previewDiv.classList.add('col-12', 'col-sm-5', 'image-preview', 'rounded', 'shadow-lg', 'p-3');
    previewDiv.dataset.signedId = signedId;
    const previewImage = document.createElement('img');
    previewImage.src = `/rails/active_storage/blobs/${signedId}/download`;
    previewImage.classList.add('img-fluid', 'rounded', 'shadow-lg', 'mb-2');

    const fileNameParagraph = document.createElement('p');
    fileNameParagraph.classList.add('text-break', 'fs-6', 'mb-1');
    fileNameParagraph.textContent = fileName;

    const cancelButton = document.createElement('button');
    cancelButton.textContent = '削除';
    cancelButton.type = 'button';
    cancelButton.classList.add("btn", "btn-danger", "rounded-pill", "float-end", 'shadow-lg');
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
