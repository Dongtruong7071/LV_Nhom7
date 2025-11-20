import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Đăng ký tài khoản mới
  Future<User?> signUp(String email, String password, String displayName) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        await user.updateDisplayName(displayName);
        await user.reload(); 
        user = _auth.currentUser;
      }

      return user;
    } on FirebaseAuthException catch (e) {
      print("Đăng ký thất bại: code=${e.code}, message=${e.message}");
      return null;
    }
  }

  // Đăng nhập
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print("Đăng nhập thất bại: code=${e.code}, message=${e.message}");
      return null;
    }
  }

  // Đăng xuất
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Kiểm tra user hiện tại
  User? get currentUser => _auth.currentUser;
}
