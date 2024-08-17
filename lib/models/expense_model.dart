class Expense {
  final int? id;
  final double amount;
  final String title;
  final String description;
  final DateTime date;
  final int userId;

  Expense(
      {this.id,
      required this.amount,
      required this.title,
      required this.description,
      required this.date,
      required this.userId});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'user_id': userId,
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      amount: map['amount'],
      title: map['title'] ?? '',
      description: map['description'],
      date: DateTime.parse(map['date']),
      userId: map['user_id'],
    );
  }
}
