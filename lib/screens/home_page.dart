import 'package:flutter/material.dart';

import '../components/alerts/expense_input_type_dialog.dart';
import '../components/tables/expense_table.dart';
import '../main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (expenses.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Text(
                    'No expenses yet. Add your first expense!',
                    style: TextStyle(fontSize: 16.0, fontStyle: FontStyle.italic),
                  ),
                ),
              )
            else
              ExpenseTable(expenses: expenses),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show option dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return ExpenseInputTypeDialog(
                onExpenseAdded: () {
                  // Update the UI when an expense is added
                  setState(() {});
                },
              );
            },
          );
        },
        tooltip: 'Add Expense',
        child: const Icon(Icons.add),
      ),
    );
  }
}
