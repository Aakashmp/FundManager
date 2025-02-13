import 'package:flutter/material.dart';
import 'package:fund_manager/utils/common.dart';
import 'package:provider/provider.dart';
import '../viewmodels/savings_viewmodel.dart';
import '../viewmodels/tab_viewmodel.dart';
import '../widgets/custom_button.dart';
import '../widgets/input_field.dart';

class SavingsEntryScreen extends StatefulWidget {
  @override
  _SavingsEntryScreenState createState() => _SavingsEntryScreenState();
}

class _SavingsEntryScreenState extends State<SavingsEntryScreen> {
  final TextEditingController savingsController = TextEditingController();
  bool _isSubmitEnabled = false;

  @override
  void initState() {
    super.initState();
    savingsController.addListener(_validateFields);
  }

  @override
  void dispose() {
    savingsController.removeListener(_validateFields);
    savingsController.dispose();
    super.dispose();
  }

  /// Validate input and enable/disable the button
  void _validateFields() {
    setState(() {
      _isSubmitEnabled = savingsController.text.trim().isNotEmpty &&
          (double.tryParse(savingsController.text.trim()) ?? 0) > 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final savingsViewModel = Provider.of<SavingsViewModel>(context, listen: false);
    final tabViewModel = Provider.of<TabViewModel>(context, listen: false);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 40.0, left: 16.0, right: 16.0, bottom: 26),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomTextField(
                  controller: savingsController,
                  labelText: "Enter your annual savings",
                  keyboardType: TextInputType.number,
                  onChanged: (value) => _validateFields(),
                ),
                SizedBox(height: 10),
                Text(
                  'Your annual savings will split into compA and compB.',
                  style: TextStyle(fontSize: 13.0, color: Colors.grey),
                ),
                Spacer(),
                customTextButton(
                  context: context,
                  text: "Submit",
                  onPressed: () {
                    if (_isSubmitEnabled) {
                      final amount = double.tryParse(savingsController.text) ?? 0;

                      if (amount <= 0) {
                        UIHelpers.showSnackbar(context, "Please enter a valid savings amount.", color: Colors.grey);
                        return;
                      }

                      //  Add Savings Logic
                      savingsViewModel.addOrUpdateSavings(amount);
                      savingsController.clear();
                      FocusManager.instance.primaryFocus?.unfocus();
                      UIHelpers.showSnackbar(context, "Savings added successfully!", color: Colors.green);

                      // Switch to Home tab
                      tabViewModel.changeTab(0);

                      // Disable button after submission
                      setState(() {
                        _isSubmitEnabled = false;
                      });
                    } else {
                      return;
                    }
                  },
                  gradientColors: _isSubmitEnabled
                      ? [AppColors.primaryBlue, AppColors.primaryGreen]
                      : [Colors.grey, Colors.grey],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

