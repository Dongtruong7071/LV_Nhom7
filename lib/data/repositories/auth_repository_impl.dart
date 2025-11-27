import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  User? get currentUser => remoteDataSource.currentUser;

  @override
  Future<User?> signIn(String email, String password) {
    return remoteDataSource.signIn(email, password);
  }

  @override
  Future<void> signOut() {
    return remoteDataSource.signOut();
  }

  @override
  Future<User?> signUp(String email, String password, String displayName) {
    return remoteDataSource.signUp(email, password, displayName);
  }
}
