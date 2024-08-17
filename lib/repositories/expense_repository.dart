import 'package:flutter/material.dart';

import '../models/expense_model.dart';
import '../services/database_provider.dart';

class ExpenseRepository {
  Future<int> addExpense(Expense expense) async {
    debugPrint('===>Adding Expense: ${expense.id}-${expense.userId}');
    final db = await DatabaseProvider().database;
    return await db.insert('expenses', expense.toMap());
  }

  Future<List<Expense>> getExpensesByUserId(int userId) async {
    final db = await DatabaseProvider().database;

    final List<Map<String, dynamic>> maps = await db.query('expenses',
        where: 'user_id = ?', whereArgs: [userId], orderBy: 'date DESC');
    return List.generate(maps.length, (i) => Expense.fromMap(maps[i]));
  }

  Future<int> updateExpense(Expense expense) async {
    final db = await DatabaseProvider().database;
    return await db.update('expenses', expense.toMap(),
        where: 'id = ?', whereArgs: [expense.id]);
  }

  Future<int> deleteExpense(int id) async {
    final db = await DatabaseProvider().database;
    return await db.delete('expenses', where: 'id = ?', whereArgs: [id]);
  }
}
