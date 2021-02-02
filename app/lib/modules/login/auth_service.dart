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
  final FirebaseAuth _firebaseAuth;
  UserToken userToken;
  static const signInText = 'Signed In';
  static const signUpText = 'Signed Up';
  static const setClaimText = 'Claim set';
  AuthenticationService(this._firebaseAuth) {
    userToken = UserToken(_firebaseAuth);
  }

  Stream<User> get authStateChanges {
    return _firebaseAuth.authStateChanges();
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut().catchError((e) => print(e.message));
  }

  Future<String> setUserClaim({String email}) async {
    var authToken = userToken.token.token;
    var httpResponse = await http.post(url + '/setDriver', headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $authToken',
    });
    if (httpResponse.statusCode > 399) {
      return jsonDecode(httpResponse.body)['error'];
    }
    return setClaimText;
  }

  Future<String> signIn({String email, String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      userToken.refresh(true);
      return signInText;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
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
