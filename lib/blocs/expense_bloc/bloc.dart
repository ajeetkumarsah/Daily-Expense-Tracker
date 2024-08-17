import 'package:expense_tracker/blocs/expense_bloc/event.dart';
import 'package:expense_tracker/blocs/expense_bloc/state.dart';
import 'package:expense_tracker/models/expense_model.dart';
import 'package:expense_tracker/repositories/expense_repository.dart';
import 'package:expense_tracker/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final ExpenseRepository _repository;

  ExpenseBloc(this._repository) : super(ExpenseInitialState()) {
    // Fetch expenses initially or when the event is triggered
    on<FetchExpensesEvent>((event, emit) async {
      try {
        final expenses = await _repository.getExpensesByUserId(event.userId);
        double total = _calculateTotal(expenses);
        emit(ExpenseLoadedState(expenses, total));
      } catch (e) {
        emit(ExpenseErrorState(e.toString()));
      }
    });

    // Add new expense and fetch the updated list
    on<AddExpenseEvent>((event, emit) async {
      await _repository.addExpense(event.expense);
      // Fetch the updated list after adding the expense
      final expenses =
          await _repository.getExpensesByUserId(event.expense.userId);
      double total = _calculateTotal(expenses);
      debugPrint('===>Expense Lenght:${expenses.length}== $total');
      emit(ExpenseLoadedState(expenses, total)); // Emit updated state
    });

    // Update expense and fetch the updated list
    on<UpdateExpenseEvent>((event, emit) async {
      await _repository.updateExpense(event.expense);
      final expenses =
          await _repository.getExpensesByUserId(event.expense.userId);
      double total = _calculateTotal(expenses);
      debugPrint('===>Expense Lenght:${expenses.length}== $total');
      emit(ExpenseLoadedState(expenses, total)); // Emit updated state
    });

    // Delete expense and fetch the updated list
    on<DeleteExpenseEvent>((event, emit) async {
      await _repository.deleteExpense(event.expense.id ?? 0);
      NotificationService().showNotification(
          title: '${event.expense.title} with amount ${event.expense.amount}');
      // Assuming userId is passed in the event or can be fetched from repository
      final expenses =
          await _repository.getExpensesByUserId(event.expense.userId);
      double total = _calculateTotal(expenses);
      emit(ExpenseLoadedState(expenses, total)); // Emit updated state
    });
  }

  // Helper function to calculate total expenses
  double _calculateTotal(List<Expense> expenses) {
    double total = 0.0;
    for (var expense in expenses) {
      total += expense.amount;
    }
    return total;
  }
}
