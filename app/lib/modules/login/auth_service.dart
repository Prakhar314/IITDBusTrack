import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../constants.dart';

class UserToken extends ChangeNotifier {
  FirebaseAuth _firebaseAuth;

  IdTokenResult _userToken;
  bool tokenLoaded;

  IdTokenResult get token => _userToken;

  UserToken(this._firebaseAuth) {
    refresh(false);
  }

  void refresh(bool notify) {
    fetchUserToken();
    tokenLoaded = false;
    if (notify) {
      notifyListeners();
    }
  }

  Future<void> fetchUserToken() async {
    // TODO: Better implementation needed
    _userToken = await _firebaseAuth.currentUser.getIdTokenResult();
    tokenLoaded = true;
    notifyListeners();
  }
}

class AuthenticationService {
  final FirebaseAuth firebaseAuth;
  UserToken userToken;
  User currentUser;
  static const signInText = 'Signed In';
  static const signUpText = 'Signed Up';
  static const setClaimText = 'Claim set';
  AuthenticationService(this.firebaseAuth) {
    userToken = UserToken(firebaseAuth);
  }

  Stream<User> get authStateChanges {
    return firebaseAuth.authStateChanges();
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut().catchError((e) => print(e.message));
  }

  Future<String> setUserClaim({String email}) async {
    var authToken = userToken.token.token;
    var httpResponse = await http.post(url + '/setDriver',
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode(<String, String>{
          'email': email,
        }));
    return jsonDecode(httpResponse.body)['message'];
  }

  Future<String> signIn({String email, String password}) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      userToken.refresh(true);
      currentUser = firebaseAuth.currentUser;
      return signInText;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String> signUp({String email, String password}) async {
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return signUpText;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
