import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:ctmap/data/type.dart';
import 'package:ctmap/assets/colors/colors.dart';

enum DataMode {
  level,
  cause,
}

class CustomBarChart extends StatelessWidget {
  final DataMode dataMode;
  final List<AccidentData> accidentDataList;

  const CustomBarChart(
      {Key? key, required this.dataMode, required this.accidentDataList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barTouchData: barTouchData,
        titlesData: titlesData,
        borderData: borderData,
        barGroups:
            dataMode == DataMode.level ? barGroupsByLevel : barGroupsByCause,
        gridData: FlGridData(
          show: true,
          horizontalInterval: 10,
          drawVerticalLine: false,
        ),
        alignment: BarChartAlignment.spaceAround,
        maxY: 100,
      ),
    );
  }

  List<BarChartGroupData> get barGroupsByLevel {
    List<int> uniqueLevels =
        accidentDataList.map((accident) => accident.level).toSet().toList();
    uniqueLevels.sort();

    final List<BarChartGroupData> groups = [];

    uniqueLevels.forEach((level) {
      final levelAccidents = accidentDataList
          .where((accident) => accident.level == level)
          .toList();
      final List<BarChartRodData> rods = [];

      rods.add(
        BarChartRodData(
          toY: levelAccidents.length.toDouble(),
          color: Colors.blueAccent,
          width: 16,
          borderRadius: BorderRadius.zero,
        ),
      );

      groups.add(
        BarChartGroupData(
          x: level.toInt(),
          barRods: rods,
          showingTooltipIndicators: const [0],
        ),
      );
    });

    return groups;
  }

  List<BarChartGroupData> get barGroupsByCause {
    List<int> uniqueCauses =
        accidentDataList.map((accident) => accident.cause).toSet().toList();
    uniqueCauses.sort();
    final List<BarChartGroupData> groups = [];

    uniqueCauses.forEach((cause) {
      final causeAccidents = accidentDataList
          .where((accident) => accident.cause == cause)
          .toList();
      final List<BarChartRodData> rods = [];

      rods.add(
        BarChartRodData(
          toY: causeAccidents.length.toDouble(),
          color: Colors.blueAccent,
          width: 16,
          borderRadius: BorderRadius.zero,
        ),
      );

      groups.add(
        BarChartGroupData(
          x: cause.toInt(),
          barRods: rods,
          showingTooltipIndicators: const [0],
        ),
      );
    });

    return groups;
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: true,
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
            return BarTooltipItem(
              rod.toY.toInt().toString(),
              TextStyle(color: AppColors.red, fontSize: 10),
            );
          },
        ),
      );

  Widget getTitles(double value, TitleMeta meta) {
    final style = TextStyle(
      color: AppColors.primaryBlack,
      fontWeight: FontWeight.w400,
      fontSize: 8,
    );
    String text;
    if (dataMode == DataMode.level) {
      switch (value.toInt()) {
        case 1:
          text = 'Mức 1';
          break;
        case 2:
          text = 'Mức 2';
          break;
        case 3:
          text = 'Mức 3';
          break;
        case 4:
          text = 'Mức 4';
          break;
        case 5:
          text = 'Mức 5';
          break;
        default:
          text = '';
          break;
      }
    } else {
      switch (value.toInt()) {
        case 1:
          text = 'Rượu/bia';
          break;
        case 2:
          text = 'Tốc độ';
          break;
        case 3:
          text = 'PTGT';
          break;
        case 4:
          text = 'Thời tiết';
          break;
        case 5:
          text = 'CSHT';
          break;
        case 6:
          text = 'Khác';
          break;
        default:
          text = '';
          break;
      }
    }

    return RotatedBox(
      quarterTurns: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children:
            text.split('\n').map((line) => Text(line, style: style)).toList(),
      ),
    );
  }

  Widget customTitleWidget(double value, TitleMeta meta) {
    return Text(
      value.toInt().toString(),
      style: TextStyle(
        color: AppColors.primaryBlack,
        fontSize: 10,
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
            interval: 10,
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
}
