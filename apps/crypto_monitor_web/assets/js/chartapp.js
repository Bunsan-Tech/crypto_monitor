export class ChartApp {
  constructor(series1,series2) {
    this.series1 = []
    this.series2 = []
    this.chart = new CanvasJS.Chart("chartContainer", {
        title: {
          text: "Crypto Currency",
          fontSize: 30
        },
        zoomEnabled: true,
        zoomType: "y",
        animationEnabled: true,
        axisX: {
          gridColor: "Silver",
          tickColor: "silver",
          valueFormatString: "hh:mm:ss"
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
          name: "ETH",
          markerType: "square",
          color: "#F08080",
          dataPoints: this.series1
        },
        {
          type: "line",
          showInLegend: true,
          name: "BTC",
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

  updateSeries1 (value) {
		this.series1.push(
      { x: new Date(), y: value });
		this.chart.render();    
  };
  
  updateSeries2 (value) {
		this.series2.push(
      { x: new Date(), y: value });
		this.chart.render();    
	};

  render(){
    this.chart.render();
  }
};
