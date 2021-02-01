import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;
  static const signInText = 'Signed In';
  static const signUpText = 'Signed Up';
  AuthenticationService(this._firebaseAuth);

  Stream<User> get authStateChanges {
    return _firebaseAuth.authStateChanges();
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<String> signIn({String email, String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return signInText;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<IdTokenResult> waitForCustomClaims() {
    // TODO: Better implementation needed
    return _firebaseAuth.currentUser.getIdTokenResult();
  }

  Future<String> signUp({String email, String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return signUpText;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
