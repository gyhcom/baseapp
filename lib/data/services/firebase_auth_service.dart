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
        _googleSignIn = googleSignIn ?? GoogleSignIn(
          // Firebase 프로젝트의 클라이언트 ID 직접 설정
          clientId: '519214372910-4am179ffmbj8927ocftg5pq7qjes7rsv.apps.googleusercontent.com',
          scopes: <String>[
            'email',
            'profile',
          ],
        );

  @override
  Future<void> initialize() async {
    // Firebase는 main에서 초기화됨
  }

  @override
  Future<UserAuth?> signInWithGoogle() async {
    try {
      // iOS에서 Google Sign-In 설정 확인
      print('🔧 Google Sign-In 설정 확인 중...');
      
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print('❌ Google 로그인 취소됨');
        return null;
      }

      print('✅ Google 계정 선택 완료: ${googleUser.email}');
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        throw Exception('Google 인증 토큰을 가져올 수 없습니다');
      }
      
      print('✅ Google 인증 토큰 획득 완료');
      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      print('🔥 Firebase 인증 시도 중...');
      final firebase_auth.UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
      print('✅ Firebase 인증 성공');
      
      return _userFromFirebase(userCredential.user);
    } on firebase_auth.FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'account-exists-with-different-credential':
          throw Exception('이미 다른 방법으로 가입된 계정입니다.');
        case 'invalid-credential':
          throw Exception('인증 정보가 올바르지 않습니다.');
        case 'operation-not-allowed':
          throw Exception('Google 로그인이 비활성화되어 있습니다.');
        case 'user-disabled':
          throw Exception('비활성화된 계정입니다.');
        case 'user-not-found':
          throw Exception('사용자를 찾을 수 없습니다.');
        case 'wrong-password':
          throw Exception('잘못된 비밀번호입니다.');
        default:
          throw Exception('Google 로그인 중 오류가 발생했습니다: ${e.message}');
      }
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
    } on SignInWithAppleAuthorizationException catch (e) {
      switch (e.code) {
        case AuthorizationErrorCode.canceled:
          return null; // 사용자가 취소함
        case AuthorizationErrorCode.failed:
          throw Exception('Apple 로그인에 실패했습니다.');
        case AuthorizationErrorCode.invalidResponse:
          throw Exception('Apple 서버 응답이 올바르지 않습니다.');
        case AuthorizationErrorCode.notHandled:
          throw Exception('Apple 로그인이 처리되지 않았습니다.');
        case AuthorizationErrorCode.unknown:
          throw Exception('알 수 없는 Apple 로그인 오류가 발생했습니다.');
        default:
          throw Exception('Apple 로그인 오류: ${e.code}');
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'account-exists-with-different-credential':
          throw Exception('이미 다른 방법으로 가입된 계정입니다.');
        case 'invalid-credential':
          throw Exception('Apple 인증 정보가 올바르지 않습니다.');
        case 'operation-not-allowed':
          throw Exception('Apple 로그인이 비활성화되어 있습니다.');
        default:
          throw Exception('Apple 로그인 중 오류가 발생했습니다: ${e.message}');
      }
    } catch (e) {
      throw Exception('Apple 로그인 실패: $e');
    }
  }

  @override
  Future<UserAuth?> signInAnonymously() async {
    try {
      final firebase_auth.UserCredential userCredential = await _firebaseAuth.signInAnonymously();
      return _userFromFirebase(userCredential.user);
    } on firebase_auth.FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'operation-not-allowed':
          throw Exception('익명 로그인이 비활성화되어 있습니다.');
        default:
          throw Exception('익명 로그인 중 오류가 발생했습니다: ${e.message}');
      }
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