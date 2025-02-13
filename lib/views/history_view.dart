import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/common.dart';
import '../viewmodels/savings_viewmodel.dart';
import '../models/savings_model.dart';
import '../widgets/pie_chart.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  int selectedYear = DateTime.now().year;

  @override
  Widget build(BuildContext context) {
    final savingsViewModel = Provider.of<SavingsViewModel>(context);

    List<int> availableYears = List.generate(
      DateTime.now().year - 2000 + 1,
          (index) => 2000 + index,
    ).reversed.toList();

    final List<WithdrawalModel> filteredHistory = savingsViewModel.history
        .where((withdrawal) => withdrawal.year == selectedYear)
        .toList();

    double compABalance = 0.0;
    double compBBalance = 0.0;

    for (var withdrawal in filteredHistory) {
      if (withdrawal.amount > 0) {
        compABalance += withdrawal.amount / 2;
        compBBalance += withdrawal.amount / 2;
      } else if (withdrawal.withdrawn > 0) {
        if (withdrawal.fromCompA) {
          compABalance -= withdrawal.withdrawn;
        } else {
          compBBalance -= withdrawal.withdrawn;
        }
      }
    }

    double totalDeposit = filteredHistory.fold(0, (sum, withdrawal) => sum + withdrawal.amount);
    double totalWithdrawal = filteredHistory.fold(0, (sum, withdrawal) => sum + withdrawal.withdrawn);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: DropdownButton<int>(
                        value: selectedYear,
                        onChanged: (int? newValue) {
                          if (newValue != null) {
                            setState(() {
                              selectedYear = newValue;
                            });
                          }
                        },
                        items: availableYears.map((year) {
                          return DropdownMenuItem<int>(
                            value: year,
                            child: Text(
                              "Year ${year.toString()}",
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          );
                        }).toList(),
                        dropdownColor: AppColors.primaryBlue,
                        iconEnabledColor: Colors.white,
                        underline: SizedBox(),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  filteredHistory.isEmpty ? Container() :
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 150,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primaryBlue, AppColors.primaryGreen], // Define gradient colors
                        begin: Alignment.topCenter,  // Start position
                        end: Alignment.bottomCenter, // End position
                      ),
                      borderRadius: BorderRadius.circular(10), // Optional rounded corners
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 15),
                        Text(
                          "Total Savings",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        Text(
                          "\₹${(compABalance + compBBalance).toStringAsFixed(2)}",
                          style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  "CompA Balance\n\₹${compABalance.toStringAsFixed(2)}",
                                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                                  textAlign: TextAlign.center
                              ),
                              Text(
                                  "CompB Balance\n\₹${compBBalance.toStringAsFixed(2)}",
                                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                                  textAlign: TextAlign.center
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  filteredHistory.isEmpty ? Container() : _buildSavingsPieChart((compABalance + compBBalance), totalWithdrawal)
                ],
              ),
            ),

            ///  Bottom Container with History List
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primaryBlue, AppColors.primaryGreen],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Saving History", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                      SizedBox(height: 10),
                      Expanded(
                        child: filteredHistory.isEmpty
                            ? Center(child: Text("No savings found for $selectedYear", style: TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.w600),))
                            : ListView.builder(
                          itemCount: filteredHistory.length,
                          itemBuilder: (context, index) {
                            final withdrawal = filteredHistory[index];
                            return _buildWithdrawCard(withdrawal);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSavingsPieChart(double totalDeposit, double totalWithdrawal) {
    return PieChartWithLegend(
      dataMap: {
        "Savings": totalDeposit,
        "Withdrawal": totalWithdrawal,
      },
      colorList: [AppColors.primaryGreen, AppColors.withdrawal],
      chartSize: 150,
      percentageBackgroundColor: AppColors.primaryBlue,
      legendItems: [
        LegendItem(color: AppColors.primaryGreen, label: "Savings"),
        LegendItem(color: AppColors.withdrawal, label: "Withdrawal"),
      ],
    );
  }

  Widget _buildWithdrawCard(WithdrawalModel withdrawal) {
    bool isDeposit = withdrawal.amount > 0;
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 70,
            decoration: BoxDecoration(
              color: isDeposit ? Color(0xFF599655) : Colors.red,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left Section: Title
                  Text(
                    withdrawal.title,
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  ),
                  // Right Section: Amount
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (withdrawal.amount > 0)
                        Text(
                          "+ ₹${withdrawal.amount.toStringAsFixed(2)}",
                          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                      if (withdrawal.withdrawn > 0)
                        Text(
                          "- ₹${withdrawal.withdrawn.toStringAsFixed(2)}",
                          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                      if (withdrawal.withdrawn > 0)
                        Text(
                          "From ${withdrawal.fromCompA ? "CompA" : "CompB"}",
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}