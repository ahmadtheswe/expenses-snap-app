class Expense {
  final String name;
  final double amount;
  final DateTime createdAt;
  final String? expenseType; // 'Need' or 'Desire'

  Expense({
    required this.name,
    required this.amount,
    required this.createdAt,
    this.expenseType,
  });
}
