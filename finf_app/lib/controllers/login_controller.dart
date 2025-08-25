import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../services/api_service.dart';
import '../utils/storage_service.dart';
import '../utils/constants.dart';
import '../views/main_page.dart';

class LoginController extends GetxController {
  // 서비스들
  final ApiService _apiService = Get.find<ApiService>();
  final StorageService _storageService = Get.find<StorageService>();

  // 로딩 상태 관리
  final RxBool isKakaoLoading = false.obs;
  final RxBool isAppleLoading = false.obs;

  // 로그인 상태 관리
  final RxBool isLoggedIn = false.obs;
  final RxString userEmail = ''.obs;
  final RxString userName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // 초기화 시 필요한 설정들
    _initializeLoginServices();
  }

  /// 로그인 서비스 초기화
  void _initializeLoginServices() {
    try {
      // 카카오 SDK 초기화
      KakaoSdk.init(nativeAppKey: '60c5e823ced94b66b69be487ee580473');
      print('카카오 SDK 초기화 완료');
    } catch (e) {
      print('카카오 SDK 초기화 실패: $e');
    }

    print('로그인 서비스 초기화 완료');

    // 저장된 로그인 상태 확인
    _checkSavedLoginState();
  }

  /// 저장된 로그인 상태 확인
  Future<void> _checkSavedLoginState() async {
    final isLoggedInSaved = await _storageService.isLoggedIn();
    if (isLoggedInSaved) {
      final userInfo = await _storageService.getUserInfo();
      if (userInfo != null) {
        userEmail.value = userInfo['email'] ?? '';
        userName.value = userInfo['name'] ?? '';
        isLoggedIn.value = true;
      }
    }
  }

  /// 카카오 로그인 처리
  Future<void> handleKakaoLogin() async {
    try {
      isKakaoLoading.value = true;

      // // TODO: 카카오 로그인 SDK 연동
      // await _performKakaoLogin();

      // 로그인 성공 처리
      _handleLoginSuccess();
    } catch (e) {
      // 로그인 실패 처리
      _handleLoginError('카카오 로그인', e.toString());
    } finally {
      isKakaoLoading.value = false;
    }
  }

  /// Apple 로그인 처리
  Future<void> handleAppleLogin() async {
    try {
      isAppleLoading.value = true;

      // // TODO: Apple 로그인 SDK 연동
      // await _performAppleLogin(); 

      // 로그인 성공 처리
      _handleLoginSuccess();
    } catch (e) {
      // 로그인 실패 처리
      _handleLoginError('Apple 로그인', e.toString());
    } finally {
      isAppleLoading.value = false;
    }
  }

  /// 카카오 로그인 실제 수행
  Future<void> _performKakaoLogin() async {
    try {
      String authorizationCode;

      // 카카오톡 앱으로 로그인 시도
      if (await isKakaoTalkInstalled()) {
        print('카카오톡 앱으로 로그인 시도...');
        // AuthCodeClient를 사용하여 인가 코드만 가져오기 (서버에서 토큰 교환용)
        try {
          final authCodeResult = await AuthCodeClient.instance
              .authorizeWithTalk(
                redirectUri: 'kakao60c5e823ced94b66b69be487ee580473://oauth',
              );
          authorizationCode = authCodeResult;
          print('AuthCodeClient로 인가 코드 획득 성공: $authorizationCode');
        } catch (e) {
          print('AuthCodeClient 사용 실패, 대체 방법 시도: $e');
          // AuthCodeClient가 실패하면 UserApi로 대체 (백업 방식)
          await UserApi.instance.loginWithKakaoTalk();
          final token = await TokenManagerProvider.instance.manager.getToken();
          authorizationCode = token?.accessToken ?? '';
        }
      } else {
        print('웹 로그인으로 로그인 시도...');
        // AuthCodeClient를 사용하여 인가 코드만 가져오기 (서버에서 토큰 교환용)
        try {
          final authCodeResult = await AuthCodeClient.instance.authorize(
            redirectUri: 'kakao60c5e823ced94b66b69be487ee580473://oauth',
          );
          authorizationCode = authCodeResult;
          print('AuthCodeClient로 인가 코드 획득 성공: $authorizationCode');
        } catch (e) {
          print('AuthCodeClient 사용 실패, 대체 방법 시도: $e');
          // AuthCodeClient가 실패하면 UserApi로 대체 (백업 방식)
          await UserApi.instance.loginWithKakaoAccount();
          final token = await TokenManagerProvider.instance.manager.getToken();
          authorizationCode = token?.accessToken ?? '';
        }
      }

      // 백엔드 서버에 카카오 로그인 요청 (인가 코드만 포함)
      // 여러 가능한 형태로 시도해보기
      final requestData = {
        'code': authorizationCode, // 카카오에서 받은 인가 코드
        'provider': 'KAKAO', // authProvider → provider로 변경
        'user': null, // 빈 문자열로 전송 (null 대신)
        // 'client_id': '60c5e823ced94b66b69be487ee580473', // 필요시 추가
        // 'redirect_uri': 'kakao60c5e823ced94b66b69be487ee580473://oauth', // 필요시 추가
      };

      final response = await _apiService.post(
        ApiConstants.authLogin,
        data: requestData,
      );

      if (response.statusCode == 200) {
        // 백엔드에서 받은 토큰 저장
        final accessToken = response.data['access_token'];
        final refreshToken = response.data['refresh_token'];

        await _storageService.saveAccessToken(accessToken);
        await _storageService.saveRefreshToken(refreshToken);

        // 사용자 정보 저장 (백엔드에서 반환하는 경우)
        if (response.data['user'] != null) {
          await _storageService.saveUserInfo(response.data['user']);
          userEmail.value = response.data['user']['email'] ?? '';
          userName.value = response.data['user']['name'] ?? '';
        }
      } else {
        print('서버 응답 에러 상세:');
        print('  - 상태 코드: ${response.statusCode}');
        print('  - 응답 데이터: ${response.data}');
        print('  - 응답 헤더: ${response.headers}');

        // 서버에서 반환하는 구체적인 에러 메시지 확인
        String errorMessage = '서버 로그인 실패: ${response.statusCode}';
        if (response.data != null && response.data is Map) {
          final errorData = response.data as Map;
          if (errorData.containsKey('message')) {
            errorMessage += ' - ${errorData['message']}';
          } else if (errorData.containsKey('error')) {
            errorMessage += ' - ${errorData['error']}';
          }
        }

        throw Exception(errorMessage);
      }
    } catch (e) {
      print('카카오 로그인 실패: $e');

      // DioException인 경우 더 자세한 정보 출력
      if (e.toString().contains('DioException')) {
        print('=== 카카오 로그인 상세 에러 정보 ===');
        print('에러 타입: ${e.runtimeType}');
        print('에러 메시지: $e');

        // 서버 응답이 있는 경우
        if (e.toString().contains('400')) {
          print('400 에러 - 클라이언트 요청 문제');
          print('가능한 원인:');
          print('1. 인가 코드가 유효하지 않음');
          print('2. 요청 데이터 형식이 서버 기대값과 다름');
          print('3. 필수 필드 누락');
        }
      }

      rethrow;
    }
  }

  /// Apple 로그인 실제 수행
  Future<void> _performAppleLogin() async {
    try {
      print('Apple 로그인 시작...');

      // Apple 로그인 SDK를 사용하여 인증 정보 획득
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final appleUserInfo = {
        'email': credential.email ?? '',
        'name': {
          'firstName': credential.givenName ?? '',
          'lastName': credential.familyName ?? '',
        },
        'user_identifier': credential.userIdentifier ?? '',
      };
      
      
      final response = await _apiService.post(
        ApiConstants.authLogin,
        data: {
          'code': credential.identityToken, // Apple ID Token을 code 파라미터로 전송
          'provider': 'APPLE',
          'user': appleUserInfo, // Apple 사용자 정보 포함
        },
      );

      if (response.statusCode == 200) {
        // 백엔드에서 받은 토큰 저장
        final accessToken = response.data['access_token'];
        final refreshToken = response.data['refresh_token'];

        await _storageService.saveAccessToken(accessToken);
        await _storageService.saveRefreshToken(refreshToken);

        // 사용자 정보 저장 (백엔드에서 반환하는 경우)
        if (response.data['user'] != null) {
          await _storageService.saveUserInfo(response.data['user']);
          userEmail.value = response.data['user']['email'] ?? '';
          
          // name 필드 처리
          if (response.data['user']['name'] != null) {
            final nameInfo = response.data['user']['name'];
            if (nameInfo is Map) {
              userName.value = '${nameInfo['firstName'] ?? ''} ${nameInfo['lastName'] ?? ''}'.trim();
            } else {
              userName.value = nameInfo.toString();
            }
          }
        } else {
          // 서버에서 사용자 정보를 반환하지 않는 경우 로컬 정보 사용
          await _storageService.saveUserInfo(appleUserInfo);
          userEmail.value = appleUserInfo['email']! as String;
          final nameInfo = appleUserInfo['name'] as Map<String, String>;
          userName.value = '${nameInfo['firstName'] ?? ''} ${nameInfo['lastName'] ?? ''}'.trim();
        }

        print('Apple 로그인 완료 - 사용자: ${userName.value}');
      } else {
        print('서버 응답 에러 상세:');
        print('  - 상태 코드: ${response.statusCode}');
        print('  - 응답 데이터: ${response.data}');
        print('  - 응답 헤더: ${response.headers}');
        
        // 서버에서 반환하는 구체적인 에러 메시지 확인
        String errorMessage = '서버 로그인 실패: ${response.statusCode}';
        if (response.data != null && response.data is Map) {
          final errorData = response.data as Map;
          if (errorData.containsKey('message')) {
            errorMessage += ' - ${errorData['message']}';
          } else if (errorData.containsKey('error')) {
            errorMessage += ' - ${errorData['error']}';
          }
        }
        
        throw Exception(errorMessage);
      }
    } on SignInWithAppleAuthorizationException catch (e) {
      // Apple 로그인 관련 에러 처리
      if (e.code == AuthorizationErrorCode.canceled) {
        print('Apple 로그인 취소됨');
        throw Exception('Apple 로그인이 취소되었습니다.');
      } else {
        print('Apple 로그인 에러: ${e.code} - ${e.message}');
        throw Exception('Apple 로그인 에러: ${e.message}');
      }
    } catch (e) {
      print('Apple 로그인 실패: $e');
      rethrow;
    }
  }

  /// 로그인 성공 처리
  void _handleLoginSuccess() {
    isLoggedIn.value = true;

    // 성공 메시지 표시
    Get.snackbar(
      '로그인 성공',
      '환영합니다! ${userName.value}님',
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFF4CAF50),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );

    // 메인 페이지로 이동
    Get.offAll(() => const MainPage());
  }

  /// 로그인 실패 처리
  void _handleLoginError(String loginType, String errorMessage) {
    Get.snackbar(
      '로그인 실패',
      '$loginType 중 오류가 발생했습니다: $errorMessage',
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFFF44336),
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  /// 로그아웃 처리
  Future<void> logout() async {
    try {
      // 백엔드 서버에 로그아웃 요청
      await _apiService.post(ApiConstants.authLogout);
    } catch (e) {
      print('로그아웃 API 호출 실패: $e');
    } finally {
      // 로컬 데이터 삭제
      await _storageService.clearAll();

      // UI 상태 초기화
      isLoggedIn.value = false;
      userEmail.value = '';
      userName.value = '';

      Get.snackbar(
        '로그아웃',
        '로그아웃되었습니다.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFF2196F3),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );

      // TODO: 로그인 페이지로 이동
      // Get.offAllNamed('/login');
    }
  }

  /// 사용자 정보 가져오기
  Map<String, String> getUserInfo() {
    return {'email': userEmail.value, 'name': userName.value};
  }

  /// 로그인 상태 확인
  bool get isUserLoggedIn => isLoggedIn.value;
}
