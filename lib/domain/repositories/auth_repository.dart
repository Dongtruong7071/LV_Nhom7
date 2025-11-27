import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Future<User?> signUp(String email, String password, String displayName);
  Future<User?> signIn(String email, String password);
  Future<void> signOut();
  User? get currentUser;
}
