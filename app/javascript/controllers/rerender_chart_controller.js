import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log('connected chart controller stimulus yayy');
    console.log("chartValue: " + this.chartValue);

    let raw_data = document.getElementById('chart-controller').getAttribute('data-chart-value')

    if(raw_data == '') { return }

    let data = JSON.parse(raw_data);
    console.log(data);

    if(data != null) {
      let chart_1 = Chartkick.charts["chart-1"];
      chart_1.updateData(data.column_chart)

      let chart_2 = Chartkick.charts["chart-2"];
      chart_2.updateData(data.pie_chart)
    }
  }
}
