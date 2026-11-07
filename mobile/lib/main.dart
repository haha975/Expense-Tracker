
import 'package:flutter/material.dart';
import 'package:mobile/app/app.dart';
import 'package:mobile/app/di/injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await configureDependencies();

  runApp(const ExpenseApp());
}
