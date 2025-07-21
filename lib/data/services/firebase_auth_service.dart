import 'dart:convert';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:crypto/crypto.dart';

import '../../domain/entities/user_auth.dart';
import '../../domain/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class FirebaseAuthService implements AuthService {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  FirebaseAuthService({
    firebase_auth.FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  })  : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  @override
  Future<void> initialize() async {
    // Firebase는 main에서 초기화됨
  }

  @override
  Future<UserAuth?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final firebase_auth.UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
      return _userFromFirebase(userCredential.user);
    } catch (e) {
      throw Exception('Google 로그인 실패: $e');
    }
  }

  @override
  Future<UserAuth?> signInWithApple() async {
    try {
      final rawNonce = _generateNonce();
      final nonce = _sha256ofString(rawNonce);

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      final oauthCredential = firebase_auth.OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      final firebase_auth.UserCredential userCredential = await _firebaseAuth.signInWithCredential(oauthCredential);
      return _userFromFirebase(userCredential.user);
    } catch (e) {
      throw Exception('Apple 로그인 실패: $e');
    }
  }

  @override
  Future<UserAuth?> signInAnonymously() async {
    try {
      final firebase_auth.UserCredential userCredential = await _firebaseAuth.signInAnonymously();
      return _userFromFirebase(userCredential.user);
    } catch (e) {
      throw Exception('익명 로그인 실패: $e');
    }
  }

  @override
  Future<void> signOut() async {
    await Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  @override
  UserAuth? getCurrentUser() {
    final user = _firebaseAuth.currentUser;
    return user != null ? _userFromFirebase(user) : null;
  }

  @override
  Stream<UserAuth?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map((user) {
      return user != null ? _userFromFirebase(user) : null;
    });
  }

  @override
  bool get isSignedIn => _firebaseAuth.currentUser != null;

  UserAuth? _userFromFirebase(firebase_auth.User? user) {
    if (user == null) return null;

    UserAuthProvider provider = UserAuthProvider.anonymous;
    if (user.providerData.isNotEmpty) {
      final providerId = user.providerData.first.providerId;
      switch (providerId) {
        case 'google.com':
          provider = UserAuthProvider.google;
          break;
        case 'apple.com':
          provider = UserAuthProvider.apple;
          break;
        case 'password':
          provider = UserAuthProvider.email;
          break;
        default:
          provider = UserAuthProvider.anonymous;
      }
    }

    return UserAuth(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName ?? '사용자',
      photoURL: user.photoURL,
      provider: provider,
      isAnonymous: user.isAnonymous,
      createdAt: user.metadata.creationTime ?? DateTime.now(),
      lastSignInAt: user.metadata.lastSignInTime,
    );
  }

  String _generateNonce([int length = 32]) {
    const charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
  }

  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}