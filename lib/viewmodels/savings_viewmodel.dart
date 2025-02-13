import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/savings_model.dart';
import '../core/services/local_storage_service.dart';

class SavingsViewModel extends ChangeNotifier {
  SavingsModel _savingsData = SavingsModel(
    compABalance: 0.0,
    compBBalance: 0.0,
    withdrawals: [],
  );

  double _compAWithdrawals = 0.0;
  double _compBWithdrawals = 0.0;

  SavingsViewModel() {
    _loadData();
  }

  SavingsModel get savingsData => _savingsData;

  double get compABalance => _savingsData.compABalance;
  double get compBBalance => _savingsData.compBBalance;
  List<WithdrawalModel> get history => _savingsData.withdrawals;

  double get compAWithdrawals => _compAWithdrawals;
  double get compBWithdrawals => _compBWithdrawals;

  Future<void> _loadData() async {
    final box = Hive.box<SavingsModel>('savingsBox');
    _savingsData = box.get('data') ?? SavingsModel(
      compABalance: 0.0,
      compBBalance: 0.0,
      withdrawals: [],
    );

    // Calculate total withdrawals for each component
    _compAWithdrawals = _calculateTotalWithdrawals(true);
    _compBWithdrawals = _calculateTotalWithdrawals(false);

    notifyListeners();
  }

  void withdraw(double amount, String component, String title) {
    if (amount <= 0) return;

    bool fromCompA = component == "CompA";

    if (fromCompA && _savingsData.compABalance >= amount) {
      _savingsData.compABalance -= amount;
      _compAWithdrawals += amount;
    } else if (!fromCompA && _savingsData.compBBalance >= amount) {
      _savingsData.compBBalance -= amount;
      _compBWithdrawals += amount;
    } else {
      return; // Not enough balance
    }

    // Add a new entry for withdrawal
    _savingsData.withdrawals.insert(0, WithdrawalModel(
      year: DateTime.now().year,
      amount: 0.0,
      withdrawn: amount,
      title: title,
      fromCompA: fromCompA,
    ));

    _saveData();
  }

  void _saveData() {
    notifyListeners();
    LocalStorageService.saveData(_savingsData);
  }

  void addOrUpdateSavings(double amount) {
    if (amount <= 0) return;

    double splitAmount = amount / 2;
    _savingsData.compABalance += splitAmount;
    _savingsData.compBBalance += splitAmount;

    // Add separate saving for CompA and CompB
    _savingsData.withdrawals.insert(0, WithdrawalModel(
      year: DateTime.now().year,
      amount: amount,
      withdrawn: 0.0,
      title: "Savings",
      fromCompA: true,
    ));

    _saveData();
  }

  double _calculateTotalWithdrawals(bool forCompA) {
    return _savingsData.withdrawals
        .where((withdrawal) => withdrawal.fromCompA == forCompA)
        .fold(0.0, (sum, withdrawal) => sum + withdrawal.withdrawn);
  }

  void saveToHive() {
    final box = Hive.box<SavingsModel>('savingsBox');
    box.put('data', _savingsData);
  }
}
