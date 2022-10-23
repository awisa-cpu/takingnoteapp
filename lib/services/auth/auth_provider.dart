import 'package:takingnoteapp/services/auth/auth_user.dart';

abstract class AuthProvider {
  AuthUser? get currentUser;

  Future<AuthUser> logIn({
    required String password,
    required String email,
  });

  Future<AuthUser> createUser({
    required String password,
    required String email,
  });

  Future<void> logOut();

  Future<void> sendEmailVerification();
}
