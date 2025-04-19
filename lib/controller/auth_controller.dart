import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:finf_app/core/service/auth_service.dart';
import 'package:finf_app/core/config/env.dart';

class AuthController extends GetxController {
  // 싱글톤 패턴 구현
  static final AuthController _instance = AuthController._internal();

  factory AuthController() {
    return _instance;
  }

  AuthController._internal();

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final _authService = AuthService();

  // 로그인 상태
  bool isLoggedIn = false;

  // 카카오 로그인
  Future<bool> signInWithKakao() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // 카카오톡 설치 여부 확인
      if (await isKakaoTalkInstalled()) {
        try {
          // 카카오톡으로 로그인
          OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
          return await _handleKakaoLoginSuccess(token);
        } catch (error) {
          // 카카오톡 로그인 실패 시 카카오 계정으로 로그인 시도
          try {
            OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
            return await _handleKakaoLoginSuccess(token);
          } catch (error) {
            errorMessage.value = '카카오 로그인에 실패했습니다.';
            return false;
          }
        }
      } else {
        // 카카오톡이 설치되어 있지 않은 경우 카카오 계정으로 로그인
        OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
        return await _handleKakaoLoginSuccess(token);
      }
    } catch (error) {
      errorMessage.value = '카카오 로그인에 실패했습니다.';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> _handleKakaoLoginSuccess(OAuthToken token) async {
    try {
      // 사용자 정보 가져오기
      User user = await UserApi.instance.me();

      // 서버에 토큰 전송
      await _authService.kakaoLogin(token);
      isLoggedIn = true;
      return true;
    } catch (error) {
      errorMessage.value = '사용자 정보를 가져오는데 실패했습니다.';
      return false;
    }
  }

  // 애플 로그인
  Future<bool> signInWithApple() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        webAuthenticationOptions: WebAuthenticationOptions(
          clientId: Env.appleClientId,
          redirectUri: Uri.parse(Env.appleRedirectUri),
        ),
      );

      // 서버에 토큰 전송
      await _authService.appleLogin(credential);
      isLoggedIn = true;
      return true;
    } catch (error) {
      errorMessage.value = '애플 로그인에 실패했습니다.';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // 로그아웃
  Future<bool> logout() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      return await _authService.logout();
    } catch (e) {
      errorMessage.value = '로그아웃에 실패했습니다.';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // 로그인 상태 체크
  Future<bool> checkLoginStatus() async {
    // TODO: 저장된 토큰이나 세션 확인 로직 구현
    return isLoggedIn;
  }

  // 사용자 정보 저장
  Future<void> saveUserInfo(Map<String, dynamic> userInfo) async {
    // TODO: SharedPreferences나 다른 로컬 저장소에 사용자 정보 저장
  }

  Future<bool> login(String email, String password) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      return await _authService.login(email, password);
    } catch (e) {
      errorMessage.value = '로그인에 실패했습니다.';
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
