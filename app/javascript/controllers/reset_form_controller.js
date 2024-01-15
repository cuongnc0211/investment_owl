import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log('connected stimulus yayy');
  }

  reset() {
    this.element.reset();
  }
}
