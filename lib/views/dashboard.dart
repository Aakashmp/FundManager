import 'package:flutter/material.dart';
import 'package:fund_manager/utils/common.dart';
import 'package:provider/provider.dart';
import '../viewmodels/savings_viewmodel.dart';
import '../widgets/pie_chart.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<SavingsViewModel>(
          builder: (context, savingsViewModel, child) {
            return SafeArea(
              child: Column(
                children: [
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
                          "\₹${savingsViewModel.compABalance + savingsViewModel.compBBalance}",
                          style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "compA Balance\n\₹${savingsViewModel.compABalance}",
                                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                                  textAlign: TextAlign.center
                              ),
                              Text(
                                "compB Balance\n\₹${savingsViewModel.compBBalance}",
                                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                                  textAlign: TextAlign.center
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: savingsViewModel.compABalance + savingsViewModel.compBBalance == 0 ? Container() : //chartView(savingsViewModel.compABalance + savingsViewModel.compBBalance, savingsViewModel.compABalance, "compA Balance")
                  chartView(savingsViewModel.compABalance + savingsViewModel.compBBalance, savingsViewModel.compABalance, savingsViewModel.compAWithdrawals, "compA Withdrawal")
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: savingsViewModel.compABalance + savingsViewModel.compBBalance == 0 ? Container() : //chartView(savingsViewModel.compABalance + savingsViewModel.compBBalance, savingsViewModel.compBBalance, "compB Balance"),
                    chartView(savingsViewModel.compABalance + savingsViewModel.compBBalance, savingsViewModel.compBBalance, savingsViewModel.compBWithdrawals, "compB Withdrawal")
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
