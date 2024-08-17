import 'package:expense_tracker/models/expense_model.dart';

abstract class ExpenseEvent {}

class AddExpenseEvent extends ExpenseEvent {
  final Expense expense;
  AddExpenseEvent(this.expense);
}

class UpdateExpenseEvent extends ExpenseEvent {
  final Expense expense;
  UpdateExpenseEvent(this.expense);
}

class DeleteExpenseEvent extends ExpenseEvent {
  final Expense expense;
  DeleteExpenseEvent(this.expense);
}

class FetchExpensesEvent extends ExpenseEvent {
  final int userId;
  FetchExpensesEvent(this.userId);
}
