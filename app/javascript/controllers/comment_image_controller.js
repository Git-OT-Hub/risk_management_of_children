import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "preview", "deleteButton"]

  connect() {
    // Connect時に画像が存在するか確認して表示を切り替える
    this.togglePreview();
  }

  preview() {
    let input = this.inputTarget;
    let preview = this.previewTarget;
    let deleteButton = this.deleteButtonTarget;
    let file = input.files[0];
    let reader = new FileReader();

    reader.onloadend = function () {
      preview.src = reader.result;
      deleteButton.style.display = "inline"; // プレビューがある場合、削除ボタンを表示
    };

    if (file) {
      reader.readAsDataURL(file);
    } else {
      preview.src = "";
      deleteButton.style.display = "none"; // プレビューがない場合、削除ボタンを非表示
      // プレビューがない場合、no_image.pngを再表示
      let noImage = document.querySelector("[data-comment-image-target='preview']");
      noImage.src = "/assets/no_image.png"; // パスは実際のパスに合わせて変更してください
    }
  }

  delete() {
    let input = this.inputTarget;
    let preview = this.previewTarget;
    let deleteButton = this.deleteButtonTarget;

    input.value = ""; // inputファイルをクリア
    preview.src = ""; // プレビューをクリア
    deleteButton.style.display = "none"; // 削除ボタンを非表示
    // プレビューがない場合、no_image.pngを再表示
    let noImage = document.querySelector("[data-comment-image-target='preview']");
    noImage.src = "/assets/no_image.png"; // パスは実際のパスに合わせて変更してください
  }

  togglePreview() {
    // 初期表示時に画像が存在するか確認して表示を切り替える
    if (this.inputTarget.files.length > 0) {
      this.preview();
    }
  }
}
