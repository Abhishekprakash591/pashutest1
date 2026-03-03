class Transaction {
  final String id;
  final String type; // Income, Expense
  final String category;
  final double amount;
  final DateTime date;
  final String? description;

  Transaction({
    required this.id,
    required this.type,
    required this.category,
    required this.amount,
    required this.date,
    this.description,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['_id'],
      type: json['type'],
      category: json['category'],
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date']),
      description: json['description'],
    );
  }
}
