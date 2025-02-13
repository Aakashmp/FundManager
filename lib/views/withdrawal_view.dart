import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/common.dart';
import '../viewmodels/savings_viewmodel.dart';
import '../widgets/custom_button.dart';
import '../widgets/input_field.dart';

class WithdrawalScreen extends StatefulWidget {
  @override
  _WithdrawalScreenState createState() => _WithdrawalScreenState();
}

class _WithdrawalScreenState extends State<WithdrawalScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  bool _isCompASelected = true;
  double? _selectedAmount;
  bool _isWithdrawEnabled = false;
  final List<double> _quickAmounts = [100, 200, 500, 1000, 2000, 5000, 10000];

  @override
  void initState() {
    super.initState();
    _amountController.addListener(_validateFields);
    _titleController.addListener(_validateFields);
  }

  @override
  void dispose() {
    _amountController.removeListener(_validateFields);
    _titleController.removeListener(_validateFields);
    _amountController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  /// Validate fields and enable/disable button
  void _validateFields() {
    String title = _titleController.text.trim();
    String amountText = _amountController.text.trim();

    setState(() {
      _isWithdrawEnabled = title.isNotEmpty && (amountText.isNotEmpty || _selectedAmount != null);
    });
  }

  @override
  Widget build(BuildContext context) {
    final savingsViewModel = Provider.of<SavingsViewModel>(context);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        //  Current Balance Display
                          Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [AppColors.primaryBlue, AppColors.primaryGreen],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.circular(10), // Optional rounded corners
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
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
                            ),
                          ),
                          SizedBox(height: 20),
                          savingsViewModel.compABalance + savingsViewModel.compBBalance == 0 ? Center(child: Text("No Savings"),) : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Select Component (CompA or CompB)
                              Text(
                                "Withdraw From:",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: RadioListTile<bool>(
                                      title: Text("CompA"),
                                      value: true,
                                      groupValue: _isCompASelected,
                                      activeColor: AppColors.primaryBlue,
                                      onChanged: (value) {
                                        setState(() {
                                          _isCompASelected = value!;
                                        });
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: RadioListTile<bool>(
                                      title: Text("CompB"),
                                      value: false,
                                      groupValue: _isCompASelected,
                                      activeColor: AppColors.primaryBlue,
                                      onChanged: (value) {
                                        setState(() {
                                          _isCompASelected = value!;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),

                              //  Withdrawal Title Input
                              CustomTextField(
                                  controller: _titleController,
                                  labelText:"Enter Withdrawal Title",
                                  keyboardType: TextInputType.name,
                                  onChanged: (value) {
                                    _validateFields();
                                  }
                              ),
                              SizedBox(height: 20),

                              // Amount Input Field
                              CustomTextField(
                                controller: _amountController,
                                labelText: "Enter Withdrawal Amount",
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedAmount = null;
                                  });
                                  _validateFields();
                                },
                              ),
                              SizedBox(height: 20),

                              //  Quick Selection Buttons
                              Text(
                                "Or select withdrawal money",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              SizedBox(height: 10),
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: _quickAmounts.map((amount) {
                                  bool isSelected = _selectedAmount == amount;

                                  return ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        FocusManager.instance.primaryFocus?.unfocus();
                                        if (isSelected) {
                                          _selectedAmount = null;
                                          _amountController.clear();
                                        } else {
                                          _selectedAmount = amount;
                                          _amountController.text = amount.toString();
                                        }
                                        _validateFields();
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: isSelected ? AppColors.primaryBlue : Colors.white,
                                      foregroundColor: isSelected ? Colors.white : Colors.black,
                                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    ),
                                    child: Text("\₹$amount"),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    )
                ),
                savingsViewModel.compABalance + savingsViewModel.compBBalance == 0 ? Container() : SafeArea(child:
                Padding(padding: EdgeInsets.symmetric(vertical: 10),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: customTextButton(
                      context: context,
                      text: "Withdraw",
                      onPressed: () {
                        if (_isWithdrawEnabled) {
                          double? amount = double.tryParse(_amountController.text);
                          String title = _titleController.text.trim();

                          if (title.isEmpty) {
                            UIHelpers.showSnackbar(context, "Please enter a withdrawal title.", color: Colors.grey);
                            return;
                          }
                          if (amount == null || amount <= 0) {
                            UIHelpers.showSnackbar(context, "Please enter a valid amount.", color: Colors.grey);
                            return;
                          }

                          double availableBalance = _isCompASelected
                              ? savingsViewModel.compABalance
                              : savingsViewModel.compBBalance;

                          if (amount > availableBalance) {
                            UIHelpers.showSnackbar(context, "Insufficient balance in ${_isCompASelected ? "CompA" : "CompB"}", color: Colors.grey);
                            return;
                          }

                          // Perform withdrawal
                          savingsViewModel.withdraw(amount, _isCompASelected ? "CompA" : "CompB", title);
                          _amountController.clear();
                          _titleController.clear();
                          setState(() {
                            _selectedAmount = null;
                            _isWithdrawEnabled = false;
                          });

                          UIHelpers.showSnackbar(context, "Withdrawal Successful!", color: Colors.green);
                          FocusManager.instance.primaryFocus?.unfocus();
                        } else {
                          return;
                        }
                      },
                      gradientColors: _isWithdrawEnabled
                          ? [AppColors.primaryBlue, AppColors.primaryGreen]
                          : [Colors.grey, Colors.grey],
                    ),
                  ),
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

