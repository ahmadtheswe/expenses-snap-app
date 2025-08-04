import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';
import '../main.dart';

class ExpenseFormPage extends StatefulWidget {
  final Expense? initialExpense;

  const ExpenseFormPage({super.key, this.initialExpense});

  @override
  State<ExpenseFormPage> createState() => _ExpenseFormPageState();
}

class _ExpenseFormPageState extends State<ExpenseFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _expenseNameController;
  late final TextEditingController _amountController;
  late DateTime _selectedDate;
  String? _expenseType;
  bool _showExpenseNameError = false;
  bool _showAmountError = false;
  bool _showExpenseTypeError = false;

  @override
  void initState() {
    super.initState();

    _expenseNameController = TextEditingController(text: widget.initialExpense?.name);
    _amountController = TextEditingController(text: widget.initialExpense?.amount.toString());
    _selectedDate = widget.initialExpense?.createdAt ?? DateTime.now();
    _expenseType = widget.initialExpense?.expenseType;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submitForm() {
    setState(() {
      _showExpenseNameError = false;
      _showAmountError = false;
      _showExpenseTypeError = false;
    });

    bool anyErrors = false;
    if (_expenseNameController.text.isEmpty) {
      setState(() {
        _showExpenseNameError = true;
      });
      anyErrors = true;
    }

    if (_amountController.text.isEmpty) {
      setState(() {
        _showAmountError = true;
      });
      anyErrors = true;
    }

    if (_expenseType == null || _expenseType!.isEmpty) {
      setState(() {
        _showExpenseTypeError = true;
      });
      anyErrors = true;
    }

    if (anyErrors) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill in all required fields.')));
      return;
    }

    if (_formKey.currentState!.validate()) {
      final expense = Expense(
        name: _expenseNameController.text,
        amount: double.parse(_amountController.text),
        createdAt: _selectedDate,
        expenseType: _expenseType,
      );

      // TODO: Save expense to database. Add to the global expenses list
      expenses.add(expense);

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Expense saved successfully!')));

      _expenseNameController.clear();
      _amountController.clear();
      setState(() {
        _selectedDate = DateTime.now();
        _expenseType = null;
        _showExpenseNameError = false;
        _showAmountError = false;
        _showExpenseTypeError = false;
      });

      Navigator.pop(context, expense);
    }
  }

  @override
  void dispose() {
    _expenseNameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Input Expense'), backgroundColor: Theme.of(context).colorScheme.inversePrimary),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _expenseNameController,
                decoration: InputDecoration(
                  labelText: 'Expense Name',
                  border: OutlineInputBorder(),
                  errorText: _showExpenseNameError ? 'Please enter an expense name' : null,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an expense name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(),
                  prefixText: '\$ ',
                  errorText: _showAmountError ? 'Please enter an amount' : null,
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: const InputDecoration(labelText: 'Created At', border: OutlineInputBorder()),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(DateFormat('MMM dd, yyyy').format(_selectedDate)),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Type of Expense',
                  border: const OutlineInputBorder(),
                  errorText: _showExpenseTypeError ? 'Please select an expense type' : null,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RadioListTile<String>(
                      title: const Text('Need'),
                      value: 'Need',
                      groupValue: _expenseType,
                      onChanged: (value) {
                        setState(() {
                          _expenseType = value;
                          _showExpenseTypeError = false;
                        });
                      },
                      dense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                    ),
                    RadioListTile<String>(
                      title: const Text('Desire'),
                      value: 'Desire',
                      groupValue: _expenseType,
                      onChanged: (value) {
                        setState(() {
                          _expenseType = value;
                          _showExpenseTypeError = false; // Clear error when selected
                        });
                      },
                      dense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16.0)),
                child: const Text('Save Expense', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
