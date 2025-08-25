import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:finf_app/core/service/provider/dio_provider.dart';
import 'package:finf_app/core/service/hive_service.dart';
import 'package:finf_app/core/model/token_model.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:finf_app/core/config/env.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final _dio = DioProvider.client;

  Future<bool> login(String email, String password) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        final tokens = response.data;
        _saveTokens(tokens);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> logout() async {
    try {
      await _dio.post('/auth/logout');
      _clearTokens();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, dynamic>?> refreshToken() async {
    try {
      final response = await _dio.post('/auth/refresh');
      if (response.statusCode == 200) {
        final tokens = response.data;
        _saveTokens(tokens);
        return tokens;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> socialLogin(
      String provider, Map<String, dynamic> tokenData) async {
    try {
      final response = await _dio.post('/auth/social/login', data: {
        'provider': provider,
        'token': tokenData,
      });

      if (response.statusCode == 200) {
        final tokens = response.data;
        _saveTokens(tokens);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> kakaoLogin(OAuthToken token) async {
    try {
      final response = await _dio.post(
        '/auth/kakao',
        data: {
          'access_token': token.accessToken,
          'refresh_token': token.refreshToken,
        },
      );

      if (response.statusCode == 200) {
        final tokenModel = TokenModel.fromJson(response.data);
        _saveTokens(tokenModel.toJson());
        return true;
      }
      return false;
    } catch (e) {
      print('카카오 로그인 서비스 오류: $e');
      return false;
    }
  }

  Future<bool> appleLogin(AuthorizationCredentialAppleID credential) async {
    try {
      print('애플 로그인 시도: ${credential.userIdentifier}');

      final response = await _dio.post('/auth/apple', data: {
        'identityToken': credential.identityToken,
        'authorizationCode': credential.authorizationCode,
        'userIdentifier': credential.userIdentifier,
        'email': credential.email,
        'fullName': {
          'givenName': credential.givenName,
          'familyName': credential.familyName,
        },
      });

      if (response.statusCode == 200) {
        final tokenModel = TokenModel.fromJson(response.data);
        _saveTokens(tokenModel.toJson());
        return true;
      }
      print('애플 로그인 서버 응답 실패: ${response.statusCode}');
      return false;
    } catch (e) {
      print('애플 로그인 서비스 오류: $e');
      return false;
    }
  }

  void _saveTokens(Map<String, dynamic> tokens) {
    DioProvider.saveTokens(tokens);

    final tokenModel = TokenModel(
      accessToken: tokens['accessToken'],
      refreshToken: tokens['refreshToken'],
      expiresAt: DateTime.now().add(Duration(seconds: tokens['expiresIn'])),
    );

    HiveService.saveToken(tokenModel);
  }

  void _clearTokens() {
    DioProvider.saveTokens(null);
    HiveService.clearToken();
  }

  Future<TokenModel?> getStoredToken() async {
    return HiveService.getToken();
  }
}
