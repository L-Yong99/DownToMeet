import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr";

// Connects to data-controller="datepicker"
export default class extends Controller {

  static targets = ["datePicker"]

  /**
   * the connect function
   * @see flatpickrInit
   */
  connect() {
    this.flatpickrInit()


    // console.log('Date picker controller')
    // const myInput = this.datePickerTarget;
    // console.log(this.datePickerTarget)

  }

  /**
   * initialise the flatpicker instance
   */
  flatpickrInit() {
    this.fp = flatpickr(this.datePickerTarget, {inline:"true"});  // flatpickr
  }

  disconnect() {
    this.fp.destroy()
  }
}
