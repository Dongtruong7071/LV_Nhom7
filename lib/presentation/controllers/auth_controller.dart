import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/user_repository.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../data/datasources/remote/auth_remote_data_source.dart';
import '../../data/datasources/remote/user_remote_data_source.dart';

class AuthController extends GetxController {
  late final AuthRepository _repository;
  late final UserRepository _userRepository;

  AuthController() {
    _repository = AuthRepositoryImpl(remoteDataSource: AuthRemoteDataSource());
    _userRepository = UserRepositoryImpl(
      remoteDataSource: UserRemoteDataSource(),
    );
  }

  var isLoading = false.obs;
  var currentUser = Rx<User?>(null);

  @override
  void onInit() {
    super.onInit();
    currentUser.value = _repository.currentUser;
  }

  Future<User?> signUp(
    String email,
    String password,
    String displayName,
  ) async {
    try {
      isLoading.value = true;
      final user = await _repository.signUp(email, password, displayName);
      currentUser.value = user;

      if (user != null) {
        _createBackendUser(user);
      }
      return user;
    } catch (e) {
      print("Sign up error: $e");
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _createBackendUser(User user) async {
    try {
      await _userRepository.createUser({"firebase_uid": user.uid});
    } catch (e) {
      print("Create backend user error: $e");
    }
  }

  Future<User?> signIn(String email, String password) async {
    try {
      isLoading.value = true;
      final user = await _repository.signIn(email, password);
      currentUser.value = user;
      return user;
    } catch (e) {
      print("Sign in error: $e");
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      await _repository.signOut();
      currentUser.value = null;
    } catch (e) {
      print("Sign out error: $e");
      rethrow;
    }
  }
}
