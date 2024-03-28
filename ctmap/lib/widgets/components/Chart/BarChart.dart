import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/widgets.dart';
import 'package:ctmap/assets/colors/colors.dart';
import 'package:ctmap/assets/icons/icons.dart';

class CustomBarChart extends StatelessWidget {
  const CustomBarChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BarChart(BarChartData(
      barTouchData: barTouchData,
      titlesData: titlesData,
      borderData: borderData,
      barGroups: barGroups,
      gridData: FlGridData(
          show: true, horizontalInterval: 5, drawVerticalLine: false),
      alignment: BarChartAlignment.spaceAround,
      maxY: 45,
    ));
  }
}

BarTouchData get barTouchData => BarTouchData(
    enabled: false,
    touchTooltipData: BarTouchTooltipData(
        tooltipBgColor: Colors.transparent,
        tooltipPadding: EdgeInsets.zero,
        tooltipMargin: 0,
        getTooltipItem: (
          BarChartGroupData group,
          int groupIndex,
          BarChartRodData rod,
          int rodIndex,
        ) {
          return BarTooltipItem(rod.toY.toInt().toString(),
              const TextStyle(color: AppColors.red, fontSize: 10));
        }));

Widget getTitles(double value, TitleMeta meta) {
  final style = TextStyle(
    color: AppColors.primaryBlack,
    fontWeight: FontWeight.w400,
    fontSize: 8,
  );
  String text;
  switch (value.toInt()) {
    case 0:
      text = 'Mức 1';
      break;
    case 1:
      text = 'Mức 2';
      break;
    case 2:
      text = 'Mức 3';
      break;
    case 3:
      text = 'Mức 4';
      break;
    case 4:
      text = 'Mức 5';
      break;
    default:
      text = '';
      break;
  }

  return SideTitleWidget(
    axisSide: meta.axisSide,
    space: 4,
    child: Text(text, style: style),
  );
}

Widget customTitleWidget(double value, TitleMeta meta) {
  return Text(
    value.toInt().toString(),
    style: TextStyle(
      color: AppColors.primaryBlack,
      fontSize: 10, // Điều chỉnh cỡ chữ ở đây
    ),
  );
}
FlTitlesData get titlesData => FlTitlesData(
      show: true,
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          getTitlesWidget: getTitles,
        ),
      ),
      leftTitles: AxisTitles(
        axisNameSize: 5,
        sideTitles: SideTitles(
          showTitles: true,
          interval: 5,
          getTitlesWidget: customTitleWidget,
        ),
      ),
      topTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      rightTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
    );

FlBorderData get borderData => FlBorderData(
      show: true,
      border: Border(
        bottom: BorderSide(color: Colors.black, width: 1),
        left: BorderSide(color: Colors.black, width: 1),
      ),
    );

LinearGradient get _barGradient => LinearGradient(
      colors: [
        Colors.blueAccent,
        Colors.redAccent,
      ],
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
    );

List<BarChartGroupData> get barGroups => [
      BarChartGroupData(
        x: 0,
        barRods: [
          BarChartRodData(
            toY: 8,
            color: Colors.blueAccent,
            width: 16,
            borderRadius: BorderRadius.zero,
          )
        ],
        showingTooltipIndicators: [0],
      ),
      BarChartGroupData(
        x: 1,
        barRods: [
          BarChartRodData(
            toY: 10,
            color: Colors.blueAccent,
            width: 16,
            borderRadius: BorderRadius.zero,
          )
        ],
        showingTooltipIndicators: [0],
      ),
      BarChartGroupData(
        x: 2,
        barRods: [
          BarChartRodData(
            toY: 15,
            color: Colors.blueAccent,
            width: 16,
            borderRadius: BorderRadius.zero,
          )
        ],
        showingTooltipIndicators: [0],
      ),
      BarChartGroupData(
        x: 3,
        barRods: [
          BarChartRodData(
            toY: 16,
            color: Colors.blueAccent,
            width: 16,
            borderRadius: BorderRadius.zero,
          )
        ],
        showingTooltipIndicators: [0],
      ),
      BarChartGroupData(
        x: 4,
        barRods: [
          BarChartRodData(
            toY: 10,
            color: Colors.blueAccent,
            width: 16,
            borderRadius: BorderRadius.zero,
          )
        ],
        showingTooltipIndicators: [0],
      ),
    ];

class BarChartSample extends StatefulWidget {
  const BarChartSample({Key? key}) : super(key: key);

  @override
  State<BarChartSample> createState() => _BarChartSampleState();
}

class _BarChartSampleState extends State<BarChartSample> {
  @override
  Widget build(BuildContext context) {
    return const AspectRatio(aspectRatio: 1.6, child: CustomBarChart());
  }
}
