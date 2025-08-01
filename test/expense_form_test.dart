// Unit tests for the expense form page
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:expenses_snap_app/screens/expense_form_page.dart';

void main() {
  group('ExpenseFormPage Widget Tests', () {
    testWidgets('ExpenseFormPage should render all form elements', (WidgetTester tester) async {
      // Build the ExpenseFormPage widget
      await tester.pumpWidget(const MaterialApp(home: ExpenseFormPage()));

      // Verify all form elements are rendered
      expect(find.text('Add Expense'), findsOneWidget); // AppBar title
      expect(find.byType(TextFormField), findsNWidgets(2)); // Name and amount fields
      expect(find.text('Expense Name'), findsOneWidget);
      expect(find.text('Amount'), findsOneWidget);
      expect(find.text('Created At'), findsOneWidget);
      expect(find.text('Type of Expense'), findsOneWidget); // New field
      expect(find.text('Need'), findsOneWidget); // Radio option 1
      expect(find.text('Desire'), findsOneWidget); // Radio option 2
      expect(find.byIcon(Icons.calendar_today), findsOneWidget); // Calendar icon
      expect(find.text('Save Expense'), findsOneWidget); // Submit button
    });

    testWidgets('Form should validate empty expense name', (WidgetTester tester) async {
      // Build the ExpenseFormPage widget
      await tester.pumpWidget(const MaterialApp(home: ExpenseFormPage()));

      // Try to submit the form without filling any fields
      await tester.tap(find.text('Save Expense'));
      await tester.pump();

      // Check that validation error message appears
      expect(find.text('Please enter an expense name'), findsOneWidget);
    });

    testWidgets('Form should validate empty amount', (WidgetTester tester) async {
      // Build the ExpenseFormPage widget
      await tester.pumpWidget(const MaterialApp(home: ExpenseFormPage()));

      // Fill in expense name but leave amount empty
      await tester.enterText(find.widgetWithText(TextFormField, 'Expense Name'), 'Test Expense');
      await tester.tap(find.text('Save Expense'));
      await tester.pump();

      // Check that amount validation error message appears
      expect(find.text('Please enter an amount'), findsOneWidget);
    });

    testWidgets('Form should validate invalid amount format', (WidgetTester tester) async {
      // Build the ExpenseFormPage widget
      await tester.pumpWidget(const MaterialApp(home: ExpenseFormPage()));

      // Fill in expense name and invalid amount
      await tester.enterText(find.widgetWithText(TextFormField, 'Expense Name'), 'Test Expense');
      await tester.enterText(find.widgetWithText(TextFormField, 'Amount'), 'not-a-number');
      await tester.tap(find.text('Save Expense'));
      await tester.pump();

      // Check that amount validation error message appears
      expect(find.text('Please enter a valid number'), findsOneWidget);
    });

    testWidgets('Form should submit successfully when all inputs are valid', (WidgetTester tester) async {
      // Build the ExpenseFormPage widget
      await tester.pumpWidget(const MaterialApp(home: ExpenseFormPage()));

      // Fill in all required fields with valid data
      await tester.enterText(find.widgetWithText(TextFormField, 'Expense Name'), 'Test Expense');
      await tester.enterText(find.widgetWithText(TextFormField, 'Amount'), '42.99');
      
      // Submit the form
      await tester.tap(find.text('Save Expense'));
      await tester.pump();

      // Check for success message
      expect(find.text('Expense saved successfully!'), findsOneWidget);
    });

    testWidgets('Date picker shows today\'s date by default', (WidgetTester tester) async {
      // Build the ExpenseFormPage widget
      await tester.pumpWidget(const MaterialApp(home: ExpenseFormPage()));

      // Get today's date formatted
      final formattedDate = DateFormat('MMM dd, yyyy').format(DateTime.now());
      
      // Verify that today's date is displayed
      expect(find.text(formattedDate), findsOneWidget);
    });

    testWidgets('Tapping calendar icon should open date picker', (WidgetTester tester) async {
      // Build the ExpenseFormPage widget
      await tester.pumpWidget(const MaterialApp(home: ExpenseFormPage()));

      // Tap on the calendar icon/date field
      await tester.tap(find.byIcon(Icons.calendar_today));
      await tester.pumpAndSettle(); // Need to wait for animation

      // Verify date picker dialog appears - look for the dialog widget instead of specific text
      expect(find.byType(DatePickerDialog), findsOneWidget);
    });
    
    testWidgets('Radio button should have "Need" selected by default', (WidgetTester tester) async {
      // Build the ExpenseFormPage widget
      await tester.pumpWidget(const MaterialApp(home: ExpenseFormPage()));
      
      // Get the first radio button (Need)
      final needRadio = tester.widget<RadioListTile<String>>(
        find.widgetWithText(RadioListTile<String>, 'Need')
      );
      
      // Get the second radio button (Desire)
      final desireRadio = tester.widget<RadioListTile<String>>(
        find.widgetWithText(RadioListTile<String>, 'Desire')
      );
      
      // Verify "Need" is selected by default
      expect(needRadio.groupValue, 'Need');
      expect(needRadio.value, needRadio.groupValue);
      expect(desireRadio.value, 'Desire');
      expect(desireRadio.value != desireRadio.groupValue, true);
    });
    
    testWidgets('Should be able to select "Desire" radio option', (WidgetTester tester) async {
      // Build the ExpenseFormPage widget
      await tester.pumpWidget(const MaterialApp(home: ExpenseFormPage()));
      
      // Tap on "Desire" radio button
      await tester.tap(find.text('Desire'));
      await tester.pump();
      
      // Get the radio button after tapping
      final desireRadio = tester.widget<RadioListTile<String>>(
        find.widgetWithText(RadioListTile<String>, 'Desire')
      );
      
      // Verify "Desire" is now selected
      expect(desireRadio.groupValue, 'Desire');
      expect(desireRadio.value, desireRadio.groupValue);
    });
  });
}
