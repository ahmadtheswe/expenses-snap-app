import 'package:flutter/material.dart';
import 'models/expense.dart';
import 'screens/home_page.dart';

// Create a global list to store expenses across the app
List<Expense> expenses = [];

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expenses Snap App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomePage(title: 'Expenses Tracker'),
    );
  }
}
