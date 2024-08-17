import 'package:expense_tracker/blocs/expense_bloc/bloc.dart';
import 'package:expense_tracker/blocs/expense_bloc/event.dart';
import 'package:expense_tracker/models/expense_model.dart';
import 'package:expense_tracker/utils/expense_type.dart';
import 'package:expense_tracker/utils/png_files.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class EditExpenseDialog extends StatefulWidget {
  final Expense expense;

  const EditExpenseDialog({super.key, required this.expense});

  @override
  State<EditExpenseDialog> createState() => _EditExpenseDialogState();
}

class _EditExpenseDialogState extends State<EditExpenseDialog> {
  late TextEditingController amountController;
  late TextEditingController descriptionController;
  String _title = 'Shopping';
  List<String> titles = [
    'Shopping',
    'Book',
    'Gift',
    'Health',
    'Movie',
    'Party'
  ];

  @override
  void initState() {
    super.initState();
    amountController =
        TextEditingController(text: widget.expense.amount.toString());
    descriptionController =
        TextEditingController(text: widget.expense.description);
    _title = widget.expense.title;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Expense', style: GoogleFonts.ptSansCaption()),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButton<String>(
            value: _title,
            isExpanded: true,
            items: titles.map((title) {
              return DropdownMenuItem<String>(
                value: title,
                child: Row(
                  children: [
                    Image.asset(
                      title == ExpenseTitle.shopping.get
                          ? PngFiles.shopping
                          : title == ExpenseTitle.book.get
                              ? PngFiles.book
                              : title == ExpenseTitle.gift.get
                                  ? PngFiles.gift
                                  : title == ExpenseTitle.health.get
                                      ? PngFiles.health
                                      : title == ExpenseTitle.movie.get
                                          ? PngFiles.movie
                                          : PngFiles.party,
                      width: 24,
                      height: 24,
                    ),
                    const SizedBox(width: 10),
                    Text(title),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _title = value;
                });
              }
            },
          ),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(labelText: 'Description'),
          ),
          TextField(
            controller: amountController,
            decoration: InputDecoration(labelText: 'Amount'),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            final updatedExpense = Expense(
              id: widget.expense.id,
              amount: double.parse(amountController.text),
              title: _title,
              description: descriptionController.text,
              date: widget.expense.date, // keep the original date
              userId: widget.expense.userId,
            );
            BlocProvider.of<ExpenseBloc>(context)
                .add(UpdateExpenseEvent(updatedExpense));
            Navigator.of(context).pop();
          },
          child: Text('Update'),
        ),
      ],
    );
  }
}
