import 'package:hive/hive.dart';

part 'savings_model.g.dart';

@HiveType(typeId: 0)
class SavingsModel {
  @HiveField(0)
  double compABalance;

  @HiveField(1)
  double compBBalance;

  @HiveField(2)
  List<WithdrawalModel> withdrawals;

  SavingsModel({
    required this.compABalance,
    required this.compBBalance,
    required this.withdrawals,
  });
}

@HiveType(typeId: 1)
class WithdrawalModel extends HiveObject {
  @HiveField(0)
  int year;

  @HiveField(1)
  double amount;

  @HiveField(2)
  double withdrawn;

  @HiveField(3)
  String title;

  @HiveField(4)
  bool fromCompA;

  WithdrawalModel({
    required this.year,
    required this.amount,
    required this.withdrawn,
    required this.title,
    required this.fromCompA,
  });
}

