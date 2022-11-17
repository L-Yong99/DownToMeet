import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr";

// Connects to data-controller="datepicker"
export default class extends Controller {

  static targets = ["datePicker"]

  connect() {

    console.log('Date picker controller')
    const myInput = this.datePickerTarget;
    console.log(myInput)
    this.fp = flatpickr(myInput,{inline:"true"});  // flatpickr

  }
}
