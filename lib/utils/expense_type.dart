enum ExpenseTitle { shopping, book, gift, health, movie, party }

extension TitleToString on ExpenseTitle {
  String get get {
    switch (this) {
      case ExpenseTitle.shopping:
        return 'Shopping';
      case ExpenseTitle.book:
        return 'Book';
      case ExpenseTitle.gift:
        return 'Gift';
      case ExpenseTitle.health:
        return 'Health';
      case ExpenseTitle.movie:
        return 'Movie';
      case ExpenseTitle.party:
        return 'Party';
    }
  }
}
