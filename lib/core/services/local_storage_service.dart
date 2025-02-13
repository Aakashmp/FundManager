import 'package:hive/hive.dart';
import '../../models/savings_model.dart';

class LocalStorageService {
  static late Box<SavingsModel> _savingsBox;

  static Future<void> init() async {
    _savingsBox = await Hive.openBox<SavingsModel>('savingsBox');

    // Initialize with default data if empty
    if (_savingsBox.isEmpty) {
      await _savingsBox.put(
        'data',
        SavingsModel(compABalance: 0.0, compBBalance: 0.0, withdrawals: []),
      );
    }
  }

  static SavingsModel getData() {
    return _savingsBox.get('data') ?? SavingsModel(
      compABalance: 0.0,
      compBBalance: 0.0,
      withdrawals: [],
    );
  }

  static void saveData(SavingsModel model) {
    _savingsBox.put('data', model);
  }
}
