import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';
import 'user_storage_service.dart';

// Service untuk menangani autentikasi
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final UserStorageService _userStorage = UserStorageService();

  // Cek status login
  Future<bool> isLoggedIn() async {
    return await _userStorage.isLoggedIn();
  }

  // Login dengan Google
  Future<bool> signInWithGoogle() async {
    try {
      // Login ke Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return false;
      }

      // Dapatkan token autentikasi
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Buat credential untuk Firebase
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Login ke Firebase
      final UserCredential userCredential =
      await _auth.signInWithCredential(credential);

      // Simpan info user
      final User? user = userCredential.user;
      if (user != null) {
        final userModel = UserModel(
          name: user.displayName ?? 'User',
          email: user.email ?? 'No email',
        );

        await _userStorage.saveUser(userModel);
        return true;
      }

      return false;
    } catch (e) {
      // Lempar error untuk ditangani di UI
      rethrow;
    }
  }

  // Logout dari semua service
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    await _userStorage.clearUser();
  }
}