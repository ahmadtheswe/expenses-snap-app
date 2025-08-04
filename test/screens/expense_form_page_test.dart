import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:expenses_snap_app/screens/expense_form_page.dart';
import 'package:expenses_snap_app/models/expense.dart';
import 'package:expenses_snap_app/main.dart' as app;
import 'package:intl/intl.dart';

class MockNavigatorObserver extends NavigatorObserver {
  List<Route<dynamic>> pushedRoutes = [];
  
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    pushedRoutes.add(route);
    super.didPush(route, previousRoute);
  }
}

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
  
  group('ExpenseFormPage Widget Tests', () {
    testWidgets('renders all form fields correctly', (WidgetTester tester) async {
      // Build ExpenseFormPage widget
      await tester.pumpWidget(
        const MaterialApp(
          home: ExpenseFormPage(),
        ),
      );

      // Check AppBar title
      expect(find.text('Input Expense'), findsOneWidget);
      
      // Check form fields
      expect(find.text('Expense Name'), findsOneWidget);
      expect(find.text('Amount'), findsOneWidget);
      expect(find.text('Created At'), findsOneWidget);
      expect(find.text('Type of Expense'), findsOneWidget);
      
      // Check radio buttons
      expect(find.text('Need'), findsOneWidget);
      expect(find.text('Desire'), findsOneWidget);
      
      // Check submit button
      expect(find.text('Save Expense'), findsOneWidget);
      
      // Check date field shows today's date
      final today = DateFormat('MMM dd, yyyy').format(DateTime.now());
      expect(find.text(today), findsOneWidget);
      
      // Check if calendar icon exists
      expect(find.byIcon(Icons.calendar_today), findsOneWidget);
    });

    testWidgets('validates empty fields', (WidgetTester tester) async {
      // Build ExpenseFormPage widget
      await tester.pumpWidget(
        const MaterialApp(
          home: ExpenseFormPage(),
        ),
      );

      // Tap submit button without filling any fields
      await tester.tap(find.text('Save Expense'));
      await tester.pump();
      
      // Check for validation error messages
      expect(find.text('Please fill in all required fields.'), findsOneWidget);
      expect(find.text('Please enter an expense name'), findsOneWidget);
      expect(find.text('Please enter an amount'), findsOneWidget);
      expect(find.text('Please select an expense type'), findsOneWidget);
      
      // Check that no expense was added
      expect(app.expenses.isEmpty, true);
    });

    testWidgets('validates invalid amount format', (WidgetTester tester) async {
      // Build ExpenseFormPage widget
      await tester.pumpWidget(
        const MaterialApp(
          home: ExpenseFormPage(),
        ),
      );

      // Enter expense name
      await tester.enterText(find.widgetWithText(TextFormField, 'Expense Name'), 'Test Expense');
      
      // Enter invalid amount
      await tester.enterText(find.widgetWithText(TextFormField, 'Amount'), 'not a number');

      // Select expense type
      await tester.tap(find.text('Need'));
      await tester.pump();
      
      // Tap submit button
      await tester.tap(find.text('Save Expense'));
      await tester.pump();
      
      // Check for validation error message
      expect(find.text('Please enter a valid number'), findsOneWidget);
      
      // Check that no expense was added
      expect(app.expenses.isEmpty, true);
    });

    testWidgets('submits form successfully with valid data', (WidgetTester tester) async {
      // Build ExpenseFormPage widget
      final mockObserver = MockNavigatorObserver();
      await tester.pumpWidget(
        MaterialApp(
          home: ExpenseFormPage(),
          navigatorObservers: [mockObserver],
        ),
      );

      // Enter expense name
      await tester.enterText(find.widgetWithText(TextFormField, 'Expense Name'), 'Test Expense');
      
      // Enter amount
      await tester.enterText(find.widgetWithText(TextFormField, 'Amount'), '99.99');
      
      // Tap Need radio button to ensure it's selected
      await tester.tap(find.text('Need'));
      await tester.pump();
      
      // Tap submit button
      await tester.tap(find.text('Save Expense'));
      await tester.pump();
      
      // Check success message
      expect(find.text('Expense saved successfully!'), findsOneWidget);
      
      // Verify expense was added to the list
      expect(app.expenses.length, 1);
      expect(app.expenses.first.name, 'Test Expense');
      expect(app.expenses.first.amount, 99.99);
      expect(app.expenses.first.expenseType, 'Need');
    });

    testWidgets('date picker shows on tap', (WidgetTester tester) async {
      // This test is trickier because showDatePicker is a static method
      // that's hard to mock in widget tests
      
      // Build ExpenseFormPage widget
      await tester.pumpWidget(
        MaterialApp(
          home: ExpenseFormPage(),
        ),
      );

      // Find the date field
      final dateField = find.ancestor(
        of: find.text(DateFormat('MMM dd, yyyy').format(DateTime.now())),
        matching: find.byType(InkWell),
      );
      
      // Tap the date field
      await tester.tap(dateField);
      await tester.pumpAndSettle();
      
      // Verify date picker dialog appears
      expect(find.byType(DatePickerDialog), findsOneWidget);
    });

    testWidgets('radio button selection changes expense type', (WidgetTester tester) async {
      // Build ExpenseFormPage widget
      await tester.pumpWidget(
        MaterialApp(
          home: ExpenseFormPage(),
        ),
      );

      // Initially no radio button is selected with the nullable type
      final initialNeedRadio = tester.widget<RadioListTile<String>>(
        find.widgetWithText(RadioListTile<String>, 'Need')
      );
      expect(initialNeedRadio.groupValue, isNull);
      
      // Tap Need radio button
      await tester.tap(find.text('Need'));
      await tester.pump();
      
      // Now 'Need' should be selected
      final needRadio = tester.widget<RadioListTile<String>>(
        find.widgetWithText(RadioListTile<String>, 'Need')
      );
      expect(needRadio.groupValue, equals('Need'));
      
      // Tap Desire radio button
      await tester.tap(find.text('Desire'));
      await tester.pump();
      
      // Now 'Desire' should be selected
      final desireRadio = tester.widget<RadioListTile<String>>(
        find.widgetWithText(RadioListTile<String>, 'Desire')
      );
      expect(desireRadio.groupValue, equals('Desire'));
      
      // Complete form and submit
      await tester.enterText(find.widgetWithText(TextFormField, 'Expense Name'), 'Test Expense');
      await tester.enterText(find.widgetWithText(TextFormField, 'Amount'), '50');
      await tester.tap(find.text('Save Expense'));
      await tester.pump();
      
      // Verify expense was added with correct type
      expect(app.expenses.first.expenseType, 'Desire');
    });
  });
}
