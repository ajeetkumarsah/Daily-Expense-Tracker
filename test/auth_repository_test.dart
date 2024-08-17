import 'package:expense_tracker/models/user_model.dart';
import 'package:expense_tracker/repositories/auth_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final AuthRepository authRepository = AuthRepository();

  test('Should register user successfully', () async {
    var result = await authRepository
        .registerUser(User(username: 'testuser', password: '123456'));
    expect(result, isNotNull);
  });

  test('Should log in user successfully', () async {
    var user = await authRepository.loginUser('testuser', '123456');
    expect(user, isNotNull);
  });
}
