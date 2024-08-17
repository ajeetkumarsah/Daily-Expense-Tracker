import 'package:expense_tracker/models/user_model.dart';

abstract class AuthEvent {}

class RegisterEvent extends AuthEvent {
  final User user;
  RegisterEvent(this.user);
}

class LoginEvent extends AuthEvent {
  final String username;
  final String password;
  LoginEvent(this.username, this.password);
}

class LogoutEvent extends AuthEvent {}
