import 'package:expense_tracker/blocs/auth_bloc/bloc.dart';
import 'package:expense_tracker/blocs/auth_bloc/event.dart';
import 'package:expense_tracker/blocs/auth_bloc/state.dart';
import 'package:expense_tracker/blocs/expense_bloc/bloc.dart';
import 'package:expense_tracker/blocs/expense_bloc/event.dart';
import 'package:expense_tracker/blocs/expense_bloc/state.dart';
import 'package:expense_tracker/models/expense_model.dart';
import 'package:expense_tracker/screens/login_screen.dart';
import 'package:expense_tracker/screens/widgets/update_dialog.dart';
import 'package:expense_tracker/utils/expense_type.dart';
import 'package:expense_tracker/utils/png_files.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;

class DashboardScreen extends StatelessWidget {
  final int userId;

  DashboardScreen({super.key, required this.userId});
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoggedOut) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => LoginScreen()));
        }
      },
      child: Scaffold(
        key: _key,
        backgroundColor: Colors.white,
        drawer: Drawer(),
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: GestureDetector(
            onTap: () => _key.currentState!.openDrawer(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset(
                PngFiles.dashboard,
                color: Colors.black,
                height: 30,
                width: 30,
              ),
            ),
          ),
          title: Text(
            'Dashboard',
            style: GoogleFonts.ptSansCaption(fontWeight: FontWeight.w500),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                BlocProvider.of<AuthBloc>(context).add(LogoutEvent());
              },
            ),
          ],
        ),
        body: BlocBuilder<ExpenseBloc, ExpenseState>(
          builder: (context, state) {
            if (state is ExpenseLoadedState) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      // height: 200,
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.deepPurple,
                      ),
                      child: ListTile(
                        title: Text(
                          '\u{20B9} ${state.totalAmount}',
                          style: GoogleFonts.yatraOne(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        subtitle: Text(
                          'Total expenses',
                          style: GoogleFonts.ptSansCaption(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    if (state.expenses.isEmpty)
                      SizedBox(
                        height: 300,
                        child: Center(
                          child: Text(
                            'No expenses found!\nAdd some expense using \'+\' button below.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.ptSansCaption(fontSize: 16),
                          ),
                        ),
                      ),
                    ListView.builder(
                      itemCount: state.expenses.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final expense = state.expenses[index];
                        return GestureDetector(
                          onLongPress: () {
                            showDialog(
                              context: context,
                              builder: (_) =>
                                  EditExpenseDialog(expense: expense),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.grey[100],
                            ),
                            child: Dismissible(
                              key: Key(expense.id.toString()),
                              onDismissed: (direction) {
                                BlocProvider.of<ExpenseBloc>(context)
                                    .add(DeleteExpenseEvent(expense));

                                // Show a snackbar to confirm deletion
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text('${expense.description} deleted'),
                                  ),
                                );
                              },
                              background: Container(
                                color: Colors.red,
                                alignment: Alignment.centerLeft,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: const Icon(Icons.delete,
                                    color: Colors.white),
                              ),
                              child: ListTile(
                                leading: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.deepPurple,
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  child: Image.asset(
                                    expense.title == ExpenseTitle.shopping.get
                                        ? PngFiles.shopping
                                        : expense.title == ExpenseTitle.book.get
                                            ? PngFiles.book
                                            : expense.title ==
                                                    ExpenseTitle.gift.get
                                                ? PngFiles.gift
                                                : expense.title ==
                                                        ExpenseTitle.health.get
                                                    ? PngFiles.health
                                                    : expense.title ==
                                                            ExpenseTitle
                                                                .movie.get
                                                        ? PngFiles.movie
                                                        : PngFiles.party,
                                    height: 20,
                                    width: 20,
                                    color: Colors.white,
                                  ),
                                ),
                                title: Text(expense.title),
                                subtitle: Text(expense.description),
                                trailing: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '\u{20B9} ${expense.amount}',
                                      style: GoogleFonts.yatraOne(
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      timeago.format(expense.date),
                                      style: GoogleFonts.ptSans(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  // Navigate to Edit Expense Screen
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            } else if (state is ExpenseErrorState) {
              return Center(child: Text('Error: ${state.error}'));
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Add Expense
            showDialog(
              context: context,
              builder: (_) => AddExpenseDialog(userId: userId),
            );
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}

class AddExpenseDialog extends StatefulWidget {
  final int userId;

  AddExpenseDialog({required this.userId});

  @override
  State<AddExpenseDialog> createState() => _AddExpenseDialogState();
}

class _AddExpenseDialogState extends State<AddExpenseDialog> {
  final TextEditingController amountController = TextEditingController();

  final TextEditingController descriptionController = TextEditingController();
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
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Add Expense',
        style: GoogleFonts.ptSansCaption(),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButton<String>(
            value: _title,
            hint: Text('Select Category', style: GoogleFonts.ptSansCaption()),
            isExpanded: true,
            items: titles.map((tite) {
              return DropdownMenuItem<String>(
                value: tite,
                child: Row(
                  children: [
                    Image.asset(
                      tite == ExpenseTitle.shopping.get
                          ? PngFiles.shopping
                          : tite == ExpenseTitle.book.get
                              ? PngFiles.book
                              : tite == ExpenseTitle.gift.get
                                  ? PngFiles.gift
                                  : tite == ExpenseTitle.health.get
                                      ? PngFiles.health
                                      : tite == ExpenseTitle.movie.get
                                          ? PngFiles.movie
                                          : PngFiles.party,
                      width: 24,
                      height: 24,
                    ),
                    const SizedBox(width: 10),
                    Text(tite),
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
            final expense = Expense(
              amount: double.parse(amountController.text),
              title: _title,
              description: descriptionController.text,
              date: DateTime.now(),
              userId: widget.userId,
            );
            BlocProvider.of<ExpenseBloc>(context).add(AddExpenseEvent(expense));
            Navigator.of(context).pop();
          },
          child: Text('Add'),
        ),
      ],
    );
  }
}
