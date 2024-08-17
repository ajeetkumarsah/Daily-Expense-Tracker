abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoggedIn extends AuthState {
  // You can have user data here
}

class AuthLoggedOut extends AuthState {}

class AuthErrorState extends AuthState {
  final String error;

  AuthErrorState(this.error);
}
