import 'package:expense_tracker/models/expense_model.dart';
import 'package:expense_tracker/repositories/expense_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final ExpenseRepository expenseRepository = ExpenseRepository();

  test('Should add expense successfully', () async {
    var result = await expenseRepository.addExpense(Expense(
      amount: 100.0,
      description: 'Groceries',
      date: DateTime.now(),
      userId: 1,
    ));
    expect(result, isNotNull);
  });

  test('Should fetch expenses by user ID', () async {
    var expenses = await expenseRepository.getExpensesByUserId(1);
    expect(expenses, isNotEmpty);
  });
}
