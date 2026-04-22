import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static values = {
    title: String,
    chart: String,
    chartName: String,
    category: String,
    type: String,
    model: String,
    displayName: String,
    current: Number,
    width: Number,
    height: Number,
    yearSelect: String,
    year: String,
    rangeStart: String,
    rangeEnd: String,
    changeYearUrl: String,
    changeRangeUrl: String,
    series: Array,
    seriesColors: Array,
    categories: Array,
    categoryLabels: Array,
  }

  connect() {
    console.log("'Apex chart' controller connected", this.seriesColorsValue)

    this.currencyFormatter = new Intl.NumberFormat('it-ES', {
      style: 'currency',
      currency: 'EUR',
      minimumFractionDigits: 2,
      maximumFractionDigits: 2
    })

    this.yearSelect = document.getElementById(this.yearSelectValue)
    this.rangeStart = document.getElementById(this.rangeStartValue)
    this.rangeEnd = document.getElementById(this.rangeEndValue)

    this.yearSelect?.addEventListener('change', e => this.changeYear(e))
    this.rangeStart?.addEventListener('change', () => this.changeRange(this.rangeStart.value, this.rangeEnd.value))
    this.rangeEnd?.addEventListener('change', () => this.changeRange(this.rangeStart.value, this.rangeEnd.value))

    const buildOptions = this.buildOptionsFor(this.typeValue)

    this.chart = new ApexCharts(this.element, buildOptions)
    this.chart.render()
  }

  changeRange (start, end) {
    console.log('change range', start, end)
    if (!this.changeRangeUrlValue)
      return

    this.sendQuery(this.changeRangeUrlValue, { title: this.titleValue, category: this.categoryValue, start, end })
  }

  changeYear(e) {
    console.log('change year', e.currentTarget.value)
    if (!this.changeYearUrlValue)
      return

    const select = e.currentTarget

    this.sendQuery(this.changeYearUrlValue, { title: this.titleValue, category: this.categoryValue, year: select.value })
  }

  sendQuery(url, params) {
    const queryParams = Object
      .entries(params)
      .reduce((params, [key, value]) =>
        `${params}&${key}=${value}`,
        `model=${this.modelValue}&target=${this.element.parentElement.id}&chart=${this.chartValue}&name=${this.chartNameValue}`)

    fetch(`${url}?${queryParams}`, {
      method: 'GET',
      headers: {
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content'),
        'Accept': 'text/vnd.turbo-stream.html, text/html, application/xhtml+xml'
      }
    })
    .then(response => response.ok && response.text())
    .then(text => {
      Turbo.renderStreamMessage(text)
    })
  }

  buildOptionsFor(type) {

    const toolbarConfig = this.buildToolbarOptions({
      year: this.yearValue,
      rangeStart: this.rangeStartValue,
      rangeEnd: this.rangeEndValue
    })

    switch (type) {
      case 'line':
        return this.lineChartOptions(toolbarConfig)
      case 'columns':
        return this.barChartOptions(toolbarConfig)
      case 'bar':
        return this.barChartOptions(toolbarConfig, true)
      case 'radialBar':
        return this.radialChartOptions(toolbarConfig)
    }
  }

  buildToolbarOptions({ year, rangeStart, rangeEnd}) {
    if (!year || !rangeStart || !rangeEnd)
      return {}

    const title = this.titleValue.toLowerCase().replaceAll(/[\s-]/g, '_')

    const date = year
      ? year
      : `${this.formatDate(rangeStart)}_${this.formatDate(rangeEnd)}`

    return {
      toolbar: {
        export: {
          csv: {
            filename: `${title}__${date}`
          },
          png: {
            filename: `${title}__${date}`
          },
        }
      }
    }
  }

  lineChartOptions(toolbarConfig) {
    return {
      series: this.seriesValue,
      colors: this.seriesColorsValue,
      chart: {
        ...toolbarConfig,
        type: 'line',
        height: this.heightValue || 300,
        zoom: {
          enabled: false
        },
      },
      title: {
        text: this.titleValue,
        align: 'left'
      },
      dataLabels: {
        enabled: false
      },
      stroke: {
        width: 2,
        curve: 'smooth',
      },
      markers: {
        size: 0,
        hover: {
          sizeOffset: 6
        }
      },
      xaxis: {
        categories: this.categoriesValue,
      },
      xAxisLabels: this.categoryLabelsValue,
      yaxis: {
        title: {
          text: this.titleize(this.displayNameValue)
        }
      },
      grid: {
        borderColor: '#f1f1f1',
      },
      tooltip: {
        x: {
          formatter: function (value, opts) {
            const index = opts.dataPointIndex
            return opts.w.config.xAxisLabels[index] || value
          }
        }
      }
    }
  }

  barChartOptions(toolbarConfig, horizontal) {
    return {
      series: this.seriesValue,
      colors: this.seriesColorsValue,
      chart: {
        ...toolbarConfig,
        type: 'bar',
        height: this.heightValue || 300
      },
      title: {
        text: `${this.titleValue}`,
        align: 'left'
      },
      plotOptions: {
        bar: {
          horizontal: horizontal,
          columnWidth: '55%',
          borderRadius: 5,
          borderRadiusApplication: 'end'
        },
      },
      dataLabels: {
        enabled: false
      },
      stroke: {
        show: true,
        width: 2,
        colors: ['transparent']
      },
      xaxis: {
        categories: this.categoriesValue,
        labels: {
          formatter: (category) => category.length > 15 ? category.slice(0, 15) + '…' : category
        }
      },
      xAxisLabels: this.categoryLabelsValue,
      yaxis: {
        title: {
          text: this.titleize(this.displayNameValue)
        }
      },
      fill: {
        opacity: 1
      },
      tooltip: {
        x: {
          formatter: function (value, opts) {
            const index = opts.dataPointIndex
            return opts.w.config.xAxisLabels[index] || value
          }
        }
      }
    }
  }

  radialChartOptions() {
    return {
      chart: {
        height: this.heightValue || 100,
        width: this.heightValue || 100,
        type: this.typeValue,
        sparkline: {
          enabled: true
        }
      },
      series: this.series || this.seriesValue,
      plotOptions: {
        radialBar: {
          hollow: {
            size: '50%'
          },
          track: {
            background: '#f2f2f2',
            strokeWidth: '100%'
          },
          dataLabels: {
            name: {
              show: false
            },
            value: {
              fontSize: '14px',
              offsetY: 5,
              show: true,
              color: "#A0A3A9",
              formatter: function (val) {
                return val + '%';
              }
            }
          }
        }
      },
      colors: ['#0ab39c'],
      stroke: {
        lineCap: 'round'
      }
    }
  }

  setValue(value) {
    this.series = [value]
    this.chart?.updateSeries(this.series)
  }

  titleize(str) {
    if (!str)
      return str

    return `${str.charAt(0).toUpperCase()}${str.slice(1)}`
  }

  formatDate(date) {
    return new Date(date).toLocaleDateString('es-ES').replaceAll('/', '-')
  }

  longWeekday(weekday) {
    switch (weekday) {
      case 'Mon':
        return 'Monday'
      case 'Tue':
        return 'Tuesday'
      case 'Wed':
        return 'Wednesday'
      case 'Thu':
        return 'Thursday'
      case 'Fri':
        return 'Friday'
      case 'Sat':
        return 'Saturday'
      case 'Sun':
        return 'Sunday'
    }
  }
}
