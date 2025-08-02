import 'package:expenses_snap_app/services/open_ai_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'models/expense.dart';
import 'screens/home_page.dart';

// Create a global list to store expenses across the app
List<Expense> expenses = [];

void main() async {
  await dotenv.load(fileName: ".env");

  final openAiService = OpenAIService();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expenses Snap App',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
      home: const HomePage(title: 'Expenses Tracker'),
    );
  }
}
