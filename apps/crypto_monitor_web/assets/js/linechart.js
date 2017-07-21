export class ChartApp {
  constructor(x,y) {
    this.x = x
    this.y = y
  }

  print_scren(){
    console.log('Testing' + this.x)
  }
};

function PrintSomething() {
  console.log('Testing')
}

var series1 = [
          { x: new Date(2010, 0, 3), y: 650 },
          { x: new Date(2010, 0, 5), y: 700 },
          { x: new Date(2010, 0, 7), y: 710 },
          { x: new Date(2010, 0, 9), y: 658 },
          { x: new Date(2010, 0, 11), y: 734 },
          { x: new Date(2010, 0, 13), y: 963 },
          { x: new Date(2010, 0, 15), y: 847 },
          { x: new Date(2010, 0, 17), y: 853 },
          { x: new Date(2010, 0, 19), y: 869 },
          { x: new Date(2010, 0, 21), y: 943 },
          { x: new Date(2010, 0, 23), y: 970 }
          ]

    var series2 = [
          { x: new Date(2010, 0, 3), y: 510 },
          { x: new Date(2010, 0, 5), y: 560 },
          { x: new Date(2010, 0, 7), y: 540 },
          { x: new Date(2010, 0, 9), y: 558 },
          { x: new Date(2010, 0, 11), y: 544 },
          { x: new Date(2010, 0, 13), y: 693 },
          { x: new Date(2010, 0, 15), y: 657 },
          { x: new Date(2010, 0, 17), y: 663 },
          { x: new Date(2010, 0, 19), y: 639 },
          { x: new Date(2010, 0, 21), y: 673 },
          { x: new Date(2010, 0, 23), y: 660 }
          ]

    function loadChart () {
      console.log('Testing')
      var chart = new CanvasJS.Chart("chartContainer", {
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
          dataPoints: series1
        },
        {
          type: "line",
          showInLegend: true,
          name: "ETH",
          color: "#20B2AA",
          lineThickness: 2,
          dataPoints: series2
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

      chart.render();
    }

    window.onload = loadChart;
