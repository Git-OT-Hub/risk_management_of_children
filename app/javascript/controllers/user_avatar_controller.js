import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "preview", "hiddenField"]

  connect() {
    // Connect時に画像が存在するか確認して表示を切り替える
    this.togglePreview();
  }

  preview() {
    let input = this.inputTarget;
    let preview = this.previewTarget;
    let file = input.files[0];
    let reader = new FileReader();

    reader.onloadend = function () {
      preview.src = reader.result;
    };

    if (file) {
      reader.readAsDataURL(file);
    } else {
      preview.src = "";
      // プレビューがない場合、no_image.pngを再表示
      let noImage = document.querySelector("[data-user-avatar-target='preview']");
      noImage.src = "/assets/no_image.png";
    }
  }

  delete() {
    let input = this.inputTarget;
    let preview = this.previewTarget;
    let hiddenField = this.hiddenFieldTarget;
    if (hiddenField && hiddenField.value !== undefined) {
      hiddenField.value = "";
    }
    input.value = "";
    preview.src = "";
    // プレビューがない場合、no_image.pngを再表示
    let noImage = document.querySelector("[data-user-avatar-target='preview']");
    noImage.src = "/assets/no_image.png";
  }

  togglePreview() {
    // 初期表示時に画像が存在するか確認して表示を切り替える
    if (this.inputTarget.files.length > 0) {
      this.preview();
    }
  }

  hiddenClear() {
    // クリック時に hiddenField の値をクリアする
    this.hiddenFieldTarget.value = "";
  }

  checkForExistingImage(event) {
    // 画像が既に添付されている場合はアラートを表示し、ファイルの選択をキャンセルする
    if (this.hiddenFieldTarget.value !== "") {
      alert("画像を先に削除してください。");
      event.preventDefault();
    }
  }
}
