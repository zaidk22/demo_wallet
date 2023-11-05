import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wallet/models/transaction.dart';
import 'package:wallet/pages/home_page.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    final dir = await pathProvider.getApplicationDocumentsDirectory();
    Hive.initFlutter();
    Hive.init(dir.path);
    Hive.registerAdapter(TransactionAdapter());
   //await Hive.openBox("transactions");
  } catch (e) {
    if (kDebugMode) {
      print('Error initializing Hive: $e');
    }
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
