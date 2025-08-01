import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:expenses_snap_app/components/tables/expense_table.dart';
import 'package:expenses_snap_app/models/expense.dart';

void main() {
  group('ExpenseTable Widget Tests', () {
    testWidgets('renders empty state when no expenses', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ExpenseTable(expenses: []),
          ),
        ),
      );
      
      expect(find.text('No expenses yet. Add your first expense!'), findsOneWidget);
    });
    
    testWidgets('renders expense data correctly', (WidgetTester tester) async {
      final expense = Expense(
        name: 'Test Expense',
        amount: 50.0,
        createdAt: DateTime(2025, 7, 31),
        expenseType: 'Need',
      );
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExpenseTable(expenses: [expense]),
          ),
        ),
      );
      
      expect(find.text('Test Expense'), findsOneWidget);
      expect(find.text('\$50.00'), findsOneWidget);
      expect(find.text('Need'), findsOneWidget);
      expect(find.text('7/31/2025'), findsOneWidget);
    });
  });
}
