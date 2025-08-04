import 'package:flutter/material.dart';
import '../../models/expense.dart';

class ExpenseTable extends StatelessWidget {
  final List<Expense> expenses;
  
  const ExpenseTable({
    super.key,
    required this.expenses,
  });

  @override
  Widget build(BuildContext context) {
    if (expenses.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Text(
            'No expenses yet. Add your first expense!',
            style: TextStyle(fontSize: 16.0, fontStyle: FontStyle.italic),
          ),
        ),
      );
    }
    
    return SingleChildScrollView(
      child: DataTable(
        columnSpacing: 16.0,
        columns: const [
          DataColumn(label: Text('Name')),
          DataColumn(label: Text('Amount')),
          DataColumn(label: Text('Type')),
          DataColumn(label: Text('Date')),
        ],
        rows: expenses.map((expense) {
          return DataRow(
            cells: [
              DataCell(Text(expense.name)),
              DataCell(Text('\$${expense.amount.toStringAsFixed(2)}')),
              DataCell(
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: expense.expenseType == 'Need' ? Colors.blue[100] : Colors.amber[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    expense.expenseType!,
                    style: TextStyle(
                      color: expense.expenseType == 'Need' ? Colors.blue[800] : Colors.amber[800],
                    ),
                  ),
                ),
              ),
              DataCell(
                Text('${expense.createdAt.month}/${expense.createdAt.day}/${expense.createdAt.year}')
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
