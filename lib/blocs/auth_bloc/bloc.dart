import 'package:expense_tracker/blocs/auth_bloc/event.dart';
import 'package:expense_tracker/blocs/auth_bloc/state.dart';
import 'package:expense_tracker/repositories/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  AuthBloc(this._authRepository) : super(AuthInitial()) {
    on<LogoutEvent>((event, emit) async {
      try {
        await _authRepository.logoutUser();
        emit(AuthLoggedOut());
      } catch (e) {
        emit(AuthErrorState(e.toString()));
      }
    });
    Stream<String?> mapEventToState(AuthEvent event) async* {
      if (event is RegisterEvent) {
        await _authRepository.registerUser(event.user);
      } else if (event is LoginEvent) {
        var user =
            await _authRepository.loginUser(event.username, event.password);
        if (user != null) {
          yield 'Logged In';
        } else {
          yield 'Invalid Credentials';
        }
      }
    }
  }
}
