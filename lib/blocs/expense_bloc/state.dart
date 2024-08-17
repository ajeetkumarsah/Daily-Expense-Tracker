import 'package:expense_tracker/models/expense_model.dart';

abstract class ExpenseState {}

class ExpenseInitialState extends ExpenseState {}

class ExpenseLoadedState extends ExpenseState {
  final List<Expense> expenses;
  final double totalAmount;
  ExpenseLoadedState(this.expenses, this.totalAmount);
}

class ExpenseErrorState extends ExpenseState {
  final String error;
  ExpenseErrorState(this.error);
}
