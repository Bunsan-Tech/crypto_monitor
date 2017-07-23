export class ChartApp {
  constructor(series1,series2) {
    this.series1 = series1
    this.series2 = series2
    this.chart = new CanvasJS.Chart("chartContainer", {
        title: {
          text: "Crypto Currency",
          fontSize: 30
        },
        animationEnabled: true,
        axisX: {
          gridColor: "Silver",
          tickColor: "silver",
          valueFormatString: "DD/MMM"
        },
        toolTip: {
          shared: true
        },
        theme: "theme2",
        axisY: {
          gridColor: "Silver",
          tickColor: "silver"
        },
        legend: {
          verticalAlign: "center",
          horizontalAlign: "right"
        },
        data: [
        {
          type: "line",
          showInLegend: true,
          lineThickness: 2,
          name: "BTC",
          markerType: "square",
          color: "#F08080",
          dataPoints: this.series1
        },
        {
          type: "line",
          showInLegend: true,
          name: "ETH",
          color: "#20B2AA",
          lineThickness: 2,
          dataPoints: this.series2
        }
        ],
        legend: {
          cursor: "pointer",
          itemclick: function (e) {
            if (typeof (e.dataSeries.visible) === "undefined" || e.dataSeries.visible) {
              e.dataSeries.visible = false;
            }
            else {
              e.dataSeries.visible = true;
            }
            chart.render();
          }
        }
      });
  }

  updateSeries1 () {
		this.series1.push(
      { x: new Date(2010, 0, 24), y: 500 });
		this.chart.render();    
	};

  render(){
    this.chart.render();
  }
};
