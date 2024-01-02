// app/javascript/controllers/search_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    this.element.addEventListener("input", () => {
      clearTimeout(this.timeout);
      this.timeout = setTimeout(() => {
        this.element.requestSubmit();
      }, 500); // 500ミリ秒のデバウンス時間
    });
  }
}
