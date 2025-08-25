import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'constants.dart';

class StorageService extends GetxService {
  static StorageService get to => Get.find();
  
  late SharedPreferences _prefs;
  
  @override
  void onInit() async {
    super.onInit();
    _prefs = await SharedPreferences.getInstance();
  }
  
  /// 액세스 토큰 저장
  Future<void> saveAccessToken(String token) async {
    await _prefs.setString(ApiConstants.accessTokenKey, token);
  }
  
  /// 액세스 토큰 가져오기
  Future<String?> getAccessToken() async {
    return _prefs.getString(ApiConstants.accessTokenKey);
  }
  
  /// 리프레시 토큰 저장
  Future<void> saveRefreshToken(String token) async {
    await _prefs.setString(ApiConstants.refreshTokenKey, token);
  }
  
  /// 리프레시 토큰 가져오기
  Future<String?> getRefreshToken() async {
    return _prefs.getString(ApiConstants.refreshTokenKey);
  }
  
  /// 사용자 정보 저장
  Future<void> saveUserInfo(Map<String, dynamic> userInfo) async {
    // Map을 JSON 문자열로 변환하여 저장
    final userInfoJson = userInfo.map((key, value) => MapEntry(key, value.toString()));
    await _prefs.setString('user_info', userInfoJson.toString());
  }
  
  /// 사용자 정보 가져오기
  Future<Map<String, dynamic>?> getUserInfo() async {
    final userInfoString = _prefs.getString('user_info');
    if (userInfoString != null) {
      // 간단한 파싱 (실제로는 JSON 사용 권장)
      try {
        final userInfo = <String, dynamic>{};
        final pairs = userInfoString
            .replaceAll('{', '')
            .replaceAll('}', '')
            .split(',');
        
        for (final pair in pairs) {
          final keyValue = pair.split(':');
          if (keyValue.length == 2) {
            userInfo[keyValue[0].trim()] = keyValue[1].trim();
          }
        }
        return userInfo;
      } catch (e) {
        print('사용자 정보 파싱 오류: $e');
        return null;
      }
    }
    return null;
  }
  
  /// 특정 사용자 정보 가져오기
  Future<T?> getUserData<T>(String key) async {
    final userInfo = await getUserInfo();
    return userInfo?[key] as T?;
  }
  
  /// 사용자 이메일 가져오기
  Future<String?> getUserEmail() async {
    return await getUserData<String>('email');
  }
  
  /// 사용자 이름 가져오기
  Future<String?> getUserName() async {
    return await getUserData<String>('name');
  }
  
  /// 사용자 ID 가져오기
  Future<int?> getUserId() async {
    final userId = await getUserData<String>('id');
    if (userId != null) {
      return int.tryParse(userId);
    }
    return null;
  }
  
  /// 토큰들 삭제
  Future<void> clearTokens() async {
    await _prefs.remove(ApiConstants.accessTokenKey);
    await _prefs.remove(ApiConstants.refreshTokenKey);
  }
  
  /// 사용자 정보 삭제
  Future<void> clearUserInfo() async {
    await _prefs.remove('user_info');
  }
  
  /// 모든 데이터 삭제 (로그아웃 시)
  Future<void> clearAll() async {
    await clearTokens();
    await clearUserInfo();
  }
  
  /// 로그인 상태 확인
  Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }
  
  /// 토큰 만료 시간 저장
  Future<void> saveTokenExpiry(DateTime expiry) async {
    await _prefs.setInt('token_expiry', expiry.millisecondsSinceEpoch);
  }
  
  /// 토큰 만료 시간 가져오기
  Future<DateTime?> getTokenExpiry() async {
    final timestamp = _prefs.getInt('token_expiry');
    if (timestamp != null) {
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    }
    return null;
  }
  
  /// 토큰이 만료되었는지 확인
  Future<bool> isTokenExpired() async {
    final expiry = await getTokenExpiry();
    if (expiry == null) return true;
    
    return DateTime.now().isAfter(expiry);
  }
  
  /// 설정 저장
  Future<void> saveSetting<T>(String key, T value) async {
    if (value is bool) {
      await _prefs.setBool(key, value);
    } else if (value is int) {
      await _prefs.setInt(key, value);
    } else if (value is String) {
      await _prefs.setString(key, value);
    } else if (value is double) {
      await _prefs.setDouble(key, value);
    }
  }
  
  /// 설정 가져오기 (bool)
  Future<bool> getSetting(String key, {required bool defaultValue}) async {
    return _prefs.getBool(key) ?? defaultValue;
  }
  
  /// 설정 가져오기 (int)
  Future<int> getSettingInt(String key, {required int defaultValue}) async {
    return _prefs.getInt(key) ?? defaultValue;
  }
  
  /// 설정 가져오기 (String)
  Future<String> getSettingString(String key, {required String defaultValue}) async {
    return _prefs.getString(key) ?? defaultValue;
  }
  
  /// 설정 가져오기 (double)
  Future<double> getSettingDouble(String key, {required double defaultValue}) async {
    return _prefs.getDouble(key) ?? defaultValue;
  }
  
  /// 설정 삭제
  Future<void> removeSetting(String key) async {
    await _prefs.remove(key);
  }
  
  /// 모든 설정 삭제
  Future<void> clearSettings() async {
    final keys = _prefs.getKeys();
    for (final key in keys) {
      if (!key.startsWith('access_token') && 
          !key.startsWith('refresh_token') && 
          !key.startsWith('user_info') &&
          !key.startsWith('token_expiry')) {
        await _prefs.remove(key);
      }
    }
  }
}
