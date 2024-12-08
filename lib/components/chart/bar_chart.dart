import 'package:flutter/material.dart';
import 'package:tracking_app_v1/models/chart_data.dart';
import 'package:fl_chart/fl_chart.dart';

class SumBarChart extends StatefulWidget {
  SumBarChart({super.key});

  @override
  State<SumBarChart> createState() => _SumBarChartState();
}

class _SumBarChartState extends State<SumBarChart> {
  List<ChartData> dataPoints = [];
  final _scollController = ScrollController();

  double barWidth = 20;
  double dataGap = 15;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) => scollToEnd(),
    );
  }

  //calc max for upper limit graph
  double calculateMax() {
    double max = 500;

    // widget.monthlySummary.sort();

    // max = widget.monthlySummary.last * 1.05;

    // if (max < 500) return 500;

    return max;
  }

  //initialize chart data
  void initializeBarData() {
    // dataPoints = List.generate(
    //   widget.monthlySummary.length,
    //   (index) => ChartData(x: index, y: widget.monthlySummary[index]),
    // );
  }

  void scollToEnd() {
    _scollController.animateTo(_scollController.position.maxScrollExtent,
        duration: Duration(seconds: 1), curve: Curves.fastOutSlowIn);
  }

  Widget _buildBottomTitles(double value, TitleMeta meta) {
    const textStyle = TextStyle(
        color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 14);

    String text;

    switch (value.toInt() % 12) {
      case 0:
        text = 'Jan';
        break;
      case 1:
        text = 'Feb';
        break;
      case 2:
        text = 'Mar';
        break;
      case 3:
        text = 'Apr';
        break;
      case 4:
        text = 'May';
        break;
      case 5:
        text = 'Jun';
        break;
      case 6:
        text = 'Jul';
        break;
      case 7:
        text = 'Aug';
        break;
      case 8:
        text = 'Sep';
        break;
      case 9:
        text = 'Oct';
        break;
      case 10:
        text = 'Nov';
        break;
      case 11:
        text = 'Dec';
        break;
      default:
        throw new Exception("Invalid month value.");
    }

    return SideTitleWidget(
        child: Text(
          text,
          style: textStyle,
        ),
        axisSide: meta.axisSide);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scollController,
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
        child: SizedBox(
          height: MediaQuery.of(context).size.width/5,
          width:
              MediaQuery.of(context).size.width*0.90,
              // barWidth * dataPoints.length + dataGap * (dataPoints.length - 1),
          child: BarChart(BarChartData(
            // maxY: calculateMax(),
            maxY: 500,
            minY: 0,
            // gridData: const FlGridData(show: false),
            // borderData: FlBorderData(show: false),
            // titlesData: FlTitlesData(
            //   show: true,
            //   topTitles: const AxisTitles(
            //       sideTitles: const SideTitles(showTitles: false)),
            //   leftTitles:
            //       const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            //   rightTitles:
            //       const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            //   bottomTitles: AxisTitles(
            //       sideTitles: SideTitles(
            //           reservedSize: 24,
            //           showTitles: true,
            //           getTitlesWidget: _buildBottomTitles))
            // ),
            // barGroups: dataPoints
            //     .map(
            //       (data) => BarChartGroupData(x: data.x, barRods: [
            //         BarChartRodData(
            //             toY: data.y,
            //             width: 30,
            //             borderRadius: BorderRadius.circular(4),
            //             color: Colors.grey.shade800,
            //             backDrawRodData: BackgroundBarChartRodData(
            //                 show: true,
            //                 // toY: calculateMax(),
            //                 toY: 500,
            //                 color: Colors.grey[200]))
            //       ]),
            //     )
            //     .toList(),
            alignment: BarChartAlignment.center,
            groupsSpace: dataGap,
          )),
        ),
      ),
    );
  }
}
