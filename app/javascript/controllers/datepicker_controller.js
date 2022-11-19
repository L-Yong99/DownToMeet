import { Controller } from "@hotwired/stimulus";
import flatpickr from "flatpickr";

// Connects to data-controller="datepicker"
export default class extends Controller {
  static targets = ["datePicker", "dateSubmit", "dateForm"];
  // static values = { dateset: String }
  /**
   * the connect function
   * @see flatpickrInit
   */
  connect() {
    // console.log(datesetValue)
    this.flatpickrInit();
  }

  /**
   * initialise the flatpicker instance
   */
  flatpickrInit() {
    const dateArrayFormat = this.datesArray();

    this.fp = flatpickr(this.datePickerTarget, {
      inline: "true",

      onChange: function (selectedDates, dateStr, instance) {
        const searchSubmitEl = document.querySelector("#search-submit");
        searchSubmitEl.click();
      },

      onDayCreate: function (dObj, dStr, fp, dayElem) {
        if (dateArrayFormat.indexOf(+dayElem.dateObj) !== -1) {
          dayElem.className += " has-action";
        }
      },
    }); // flatpickr

    this.selectDate();
  }

  selectDate() {
    const hiddenValueEl = document.querySelector("#hidden-date");
    this.fp.setDate(hiddenValueEl.value);
  }

  datesArray() {
    const hiddenValueSDEl = document.querySelector("#hidden-setDate");
    const dateArray = JSON.parse(hiddenValueSDEl.value);

    const dateArrayFormat = dateArray.map((date) => {
      const date_split = date.split("-");
      return Date.parse(
        new Date(+date_split[0], +date_split[1] - 1, +date_split[2])
      );
    });
    return dateArrayFormat;
  }

  disconnect() {
    this.fp.destroy();
  }
}
