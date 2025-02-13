import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import '../utils/common.dart';

class PieChartWithLegend extends StatelessWidget {
  final Map<String, double> dataMap;
  final List<Color> colorList;
  final double chartSize;
  final List<LegendItem> legendItems;
  final Color percentageBackgroundColor;

  const PieChartWithLegend({
    Key? key,
    required this.dataMap,
    required this.colorList,
    required this.legendItems,
    this.chartSize = 150,
    this.percentageBackgroundColor = Colors.transparent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Pie Chart
        Container(
          height: chartSize,
          width: chartSize,
          child: PieChart(
            dataMap: dataMap,
            colorList: colorList,
            chartType: ChartType.ring,
            chartValuesOptions: ChartValuesOptions(
              showChartValuesInPercentage: true,
              showChartValuesOutside: false,
              chartValueBackgroundColor: percentageBackgroundColor,
            ),
            legendOptions: LegendOptions(showLegends: false),
          ),
        ),

        SizedBox(width: 20),

        // Custom Legend List
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: legendItems.map((item) => _buildLegendItem(item)).toList(),
        ),
      ],
    );
  }

  Widget _buildLegendItem(LegendItem item) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: item.color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 8),
        Text(
          item.label,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class LegendItem {
  final Color color;
  final String label;

  LegendItem({required this.color, required this.label});
}

// Widget chartView(double saving, double balance, String label) {
//   return LayoutBuilder(
//     builder: (context, constraints) {
//       double chartSize = constraints.maxWidth * 0.5;
//       return PieChartWithLegend(
//         dataMap: {
//           "Savings": saving,
//           "${label}": balance,
//         },
//         chartSize: chartSize,
//         colorList: [AppColors.primaryGreen, AppColors.primaryBlue],
//         percentageBackgroundColor: AppColors.primaryBlue,
//         legendItems: [
//           LegendItem(color: AppColors.primaryGreen, label: "Total Savings"),
//           LegendItem(color: AppColors.primaryBlue, label: label),
//         ],
//       );
//     },
//   );
// }

Widget chartView(double totalSavings, double componentBalance, double totalWithdrawals, String label) {
  // total amount (savings + withdrawals) for the component
  double totalAmount = componentBalance + totalWithdrawals;

  double savingsPercentage = totalAmount > 0 ? (componentBalance / totalAmount) * 100 : 0;
  double withdrawalPercentage = totalAmount > 0 ? (totalWithdrawals / totalAmount) * 100 : 0;

  Map<String, double> dataMap = {
    "Savings": savingsPercentage,
    "${label}": withdrawalPercentage,
  };

  List<Color> colorList = [AppColors.primaryGreen, AppColors.withdrawal];

  return LayoutBuilder(
    builder: (context, constraints) {
      double chartSize = constraints.maxWidth * 0.5;
      return PieChartWithLegend(
        dataMap: dataMap,
        chartSize: chartSize,
        colorList: colorList,
        percentageBackgroundColor: AppColors.primaryBlue,
        legendItems: [
          LegendItem(color: AppColors.primaryGreen, label: "Savings"),
          LegendItem(color: AppColors.withdrawal, label: label),
        ],
      );
    },
  );
}
