import 'package:expenses_snap_app/screens/expense_form_page.dart';
import 'package:flutter/material.dart';

class ExpenseInputTypeDialog extends StatelessWidget {
  final Function? onExpenseAdded;
  
  const ExpenseInputTypeDialog({Key? key, this.onExpenseAdded}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Expense'),
      content: const Text('How would you like to add your expense?'),
      actions: <Widget>[
        TextButton(
          onPressed: () async {
            // Close dialog
            Navigator.of(context).pop();

            // Navigate to the form page and wait for result
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ExpenseFormPage()),
            );
            // If we got a result (new expense), call the callback
            if (result != null && onExpenseAdded != null) {
              onExpenseAdded!();
            }
          },
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.edit),
              SizedBox(width: 8),
              Text('Input data manually'),
            ],
          ),
        ),
        TextButton(
          onPressed: () {
            // Close dialog
            Navigator.of(context).pop();

            // Show a placeholder message for now
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Bill picture feature coming soon!'),
              ),
            );
          },
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.camera_alt),
              SizedBox(width: 8),
              Text('Take your bill picture'),
            ],
          ),
        ),
      ],
    );
  }
}