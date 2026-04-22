import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static values = { start: String, end: String }
  static targets = [ 'dateRange', 'startInput', 'endInput' ]

  connect() {
    console.log("'Date range' controller connected", 'start: ', this.startValue, 'end: ', this.endValue)

    $(this.dateRangeTarget).daterangepicker({
      "locale": {
        "format": "DD-MM-YYYY",
        "separator": " – ",
        "applyLabel": "Seleccionar",
        "cancelLabel": "Cancelar",
        "fromLabel": "Desde",
        "toLabel": "A",
        "customRangeLabel": "Custom",
        "weekLabel": "W",
        "daysOfWeek": [
          "Do",
          "Lu",
          "Ma",
          "Mi",
          "Ju",
          "Vi",
          "Sa"
        ],
        "monthNames": [
          "Enero",
          "Febrero",
          "Marzo",
          "Abril",
          "Mayo",
          "Junio",
          "Julio",
          "Agosto",
          "Septiembre",
          "Octubre",
          "Noviembre",
          "Diciembre"
        ],
        "firstDay": 1
      },
      startDate: this.startValue,
      endDate: this.endValue,
    })

    $(this.element).on('apply.daterangepicker', (e, picker) => {
      this.startInputTarget.value = picker.startDate.format('YYYY-MM-DD')
      this.endInputTarget.value = picker.endDate.format('YYYY-MM-DD')
    })
  }
}
