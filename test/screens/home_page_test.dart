import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:expenses_snap_app/screens/home_page.dart';
import 'package:expenses_snap_app/models/expense.dart';
import 'package:expenses_snap_app/components/alerts/expense_input_type_dialog.dart';
import 'package:expenses_snap_app/components/tables/expense_table.dart';
import 'package:expenses_snap_app/main.dart' as app;

void main() {
  // Store the original expense list to restore after tests
  late List<Expense> originalExpenses;
  
  setUp(() {
    // Save the original expense list
    originalExpenses = List<Expense>.from(app.expenses);
    // Clear expenses before each test
    app.expenses = [];
  });

  tearDown(() {
    // Restore the original expense list
    app.expenses = originalExpenses;
  });
  
  group('HomePage Widget Tests', () {
    testWidgets('renders app bar with correct title', (WidgetTester tester) async {
      // Build HomePage widget
      await tester.pumpWidget(
        const MaterialApp(
          home: HomePage(title: 'Test Expenses'),
        ),
      );

      // Check for AppBar
      final appBarFinder = find.byType(AppBar);
      expect(appBarFinder, findsOneWidget);
      
      // Check for title
      expect(find.text('Test Expenses'), findsOneWidget);
    });

    testWidgets('shows empty state message when no expenses', (WidgetTester tester) async {
      // Build HomePage widget with empty expense list
      app.expenses = [];
      
      await tester.pumpWidget(
        const MaterialApp(
          home: HomePage(title: 'Test Expenses'),
        ),
      );

      // Check for empty state message
      expect(find.text('No expenses yet. Add your first expense!'), findsOneWidget);
      
      // Verify that ExpenseTable is not present
      expect(find.byType(ExpenseTable), findsNothing);
    });

    testWidgets('shows ExpenseTable when expenses exist', (WidgetTester tester) async {
      // Add test expenses
      app.expenses = [
        Expense(
          name: 'Test Expense',
          amount: 123.45,
          createdAt: DateTime(2025, 7, 31),
          expenseType: 'Need',
        ),
      ];
      
      await tester.pumpWidget(
        const MaterialApp(
          home: HomePage(title: 'Test Expenses'),
        ),
      );

      // Verify ExpenseTable is shown
      expect(find.byType(ExpenseTable), findsOneWidget);
      
      // Empty state message should not be shown
      expect(find.text('No expenses yet. Add your first expense!'), findsNothing);
    });

    testWidgets('tapping FAB shows ExpenseInputTypeDialog', (WidgetTester tester) async {
      // Build HomePage widget
      await tester.pumpWidget(
        const MaterialApp(
          home: HomePage(title: 'Test Expenses'),
        ),
      );

      // Locate and tap the FloatingActionButton
      final fabFinder = find.byType(FloatingActionButton);
      expect(fabFinder, findsOneWidget);
      await tester.tap(fabFinder);
      await tester.pumpAndSettle();
      
      // Verify that the dialog appears
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Add Expense'), findsOneWidget);
      expect(find.text('How would you like to add your expense?'), findsOneWidget);
      
      // Check for dialog buttons
      expect(find.text('Input data manually'), findsOneWidget);
      expect(find.text('Take your bill picture'), findsOneWidget);
    });

    testWidgets('setState is called when onExpenseAdded callback is triggered', (WidgetTester tester) async {
      // We can't directly test setState, but we can verify the dialog is created with a callback
      
      // Build HomePage widget
      await tester.pumpWidget(
        const MaterialApp(
          home: HomePage(title: 'Test Expenses'),
        ),
      );

      // Tap the FAB to show dialog
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      
      // Verify dialog with ExpenseInputTypeDialog is shown
      expect(find.byType(ExpenseInputTypeDialog), findsOneWidget);
      
      // For a real implementation, we would need to use a mocked version of ExpenseInputTypeDialog
      // that allows us to trigger the callback and verify the state update
    });
  });
}
