import 'package:flutter/material.dart';
import 'package:fund_manager/viewmodels/tab_viewmodel.dart';
import 'package:fund_manager/views/splash_view.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'core/services/local_storage_service.dart';
import 'models/savings_model.dart';
import 'viewmodels/savings_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(SavingsModelAdapter());
  }
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(WithdrawalModelAdapter());
  }

  await Hive.openBox<SavingsModel>('savingsBox'); // Open box before using it

  await LocalStorageService.init(); // Now safe to call

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SavingsViewModel()),
        ChangeNotifierProvider(create: (context) => TabViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Savings App',
        home: SplashView(),
      ),
    );
  }
}