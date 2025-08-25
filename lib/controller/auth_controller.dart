import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:finf_app/core/service/auth_service.dart';
import 'package:finf_app/core/config/env.dart';
import 'dart:async';
import 'dart:io';

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
          print('카카오톡 로그인 토큰: ${token.accessToken}');
          return await _handleKakaoLoginSuccess(token);
        } catch (error) {
          print('카카오톡 로그인 실패: $error');
          // 카카오톡 로그인 실패 시 카카오 계정으로 로그인 시도
          try {
            OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
            print('카카오 계정 로그인 토큰: ${token.accessToken}');
            return await _handleKakaoLoginSuccess(token);
          } catch (error) {
            print('카카오 계정 로그인 실패: $error');
            String errorMsg = '카카오 로그인에 실패했습니다.';
            if (error is KakaoClientException) {
              errorMsg = '카카오 서비스 연결에 실패했습니다.';
              print('카카오 클라이언트 오류: ${error.msg}');
            } else if (error is KakaoAuthException) {
              errorMsg = '카카오 인증에 실패했습니다.';
              print('카카오 인증 오류: ${error.error}');
            } else if (error is TimeoutException) {
              errorMsg = '서버 응답 시간이 초과되었습니다.';
            } else if (error is SocketException) {
              errorMsg = '네트워크 연결을 확인해주세요.';
            }
            errorMessage.value = errorMsg;
            return false;
          }
        }
      } else {
        // 카카오톡이 설치되어 있지 않은 경우 카카오 계정으로 로그인
        try {
          OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
          print('카카오 계정 로그인 토큰: ${token.accessToken}');
          return await _handleKakaoLoginSuccess(token);
        } catch (error) {
          print('카카오 계정 로그인 실패: $error');
          String errorMsg = '카카오 로그인에 실패했습니다.';
          if (error is KakaoClientException) {
            errorMsg = '카카오 서비스 연결에 실패했습니다.';
            print('카카오 클라이언트 오류: ${error.msg}');
          } else if (error is KakaoAuthException) {
            errorMsg = '카카오 인증에 실패했습니다.';
            print('카카오 인증 오류: ${error.error}');
          }
          errorMessage.value = errorMsg;
          return false;
        }
      }
    } catch (error) {
      print('카카오 로그인 전체 실패: $error');
      String errorMsg = '카카오 로그인에 실패했습니다.';
      if (error is KakaoClientException) {
        errorMsg = '카카오 서비스 연결에 실패했습니다.';
        print('카카오 클라이언트 오류: ${error.msg}');
      } else if (error is KakaoAuthException) {
        errorMsg = '카카오 인증에 실패했습니다.';
        print('카카오 인증 오류: ${error.error}');
      }
      errorMessage.value = errorMsg;
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> _handleKakaoLoginSuccess(OAuthToken token) async {
    try {
      if (token.accessToken.isEmpty) {
        print('토큰이 비어있습니다.');
        errorMessage.value = '인증 토큰이 유효하지 않습니다.';
        return false;
      }

      // 사용자 정보 가져오기
      User user = await UserApi.instance.me();
      print('카카오 사용자 정보: ${user.id}');

      // 서버에 토큰 전송
      bool loginResult = await _authService.kakaoLogin(token);
      if (!loginResult) {
        print('서버 로그인 실패');
        errorMessage.value = '서버 로그인에 실패했습니다.';
        return false;
      }

      isLoggedIn = true;
      return true;
    } catch (error) {
      print('카카오 로그인 후처리 실패: $error');
      errorMessage.value = '사용자 정보를 가져오는데 실패했습니다.';
      return false;
    }
  }

  // 애플 로그인
  Future<bool> signInWithApple() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      print('애플 로그인 시작');

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

      print('애플 로그인 성공: ${credential.userIdentifier}');

      // 서버에 토큰 전송
      await _authService.appleLogin(credential);
      isLoggedIn = true;
      return true;
    } catch (error) {
      print('애플 로그인 실패: $error');
      String errorMsg = '애플 로그인에 실패했습니다.';
      if (error is SignInWithAppleAuthorizationException) {
        print('애플 로그인 에러 코드: ${error.code}');
        print('애플 로그인 에러 메시지: ${error.message}');

        switch (error.code) {
          case AuthorizationErrorCode.canceled:
            errorMsg = '로그인이 취소되었습니다.';
            break;
          case AuthorizationErrorCode.invalidResponse:
            errorMsg = '잘못된 응답이 반환되었습니다.';
            break;
          case AuthorizationErrorCode.notHandled:
            errorMsg = '처리되지 않은 오류가 발생했습니다.';
            break;
          case AuthorizationErrorCode.notInteractive:
            errorMsg = '인터랙티브하지 않은 상태입니다.';
            break;
          case AuthorizationErrorCode.failed:
            errorMsg = '로그인에 실패했습니다.';
            break;
          case AuthorizationErrorCode.unknown:
            errorMsg = '알 수 없는 오류가 발생했습니다. (${error.message})';
            break;
        }
      }
      errorMessage.value = errorMsg;
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
      String errorMsg = '로그인에 실패했습니다.';
      if (e is FormatException) {
        errorMsg = '이메일 또는 비밀번호 형식이 올바르지 않습니다.';
      } else if (e is TimeoutException) {
        errorMsg = '서버 응답 시간이 초과되었습니다.';
      } else if (e is SocketException) {
        errorMsg = '네트워크 연결을 확인해주세요.';
      }
      errorMessage.value = errorMsg;
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
