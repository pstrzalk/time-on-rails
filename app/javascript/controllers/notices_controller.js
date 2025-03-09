import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    setTimeout(this.hide.bind(this), 4000);
  }

  hide() {
    this.element.classList.remove('absolute');
    this.element.classList.add('hidden');
  }
}
