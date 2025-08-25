class ApiConstants {
  // 백엔드 서버 URL
  static const String baseUrl = 'https://test-api.finfriends.site/api';
  
  // API 엔드포인트
  static const String authLogin = '/auth/oauth/token';
  static const String authRefresh = '/auth/refresh';
  static const String authLogout = '/auth/logout';
  static const String userProfile = '/user/profile';
  
  // 기록 관련 API
  static const String staticRecords = '/trainings/static-records';
  static const String timeBasedRecords = '/trainings/time-based';
  static const String breathBasedRecords = '/trainings/breath-based';
  
  // 개발 모드 (로깅 인터셉터 활성화)
  static const bool isDebugMode = true;
  
  // 타임아웃 설정
  static const int connectTimeout = 30; // 초
  static const int receiveTimeout = 30; // 초
  
  // 토큰 관련
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  
  // 에러 메시지
  static const String networkError = '네트워크 오류가 발생했습니다.';
  static const String serverError = '서버 오류가 발생했습니다.';
  static const String unauthorizedError = '인증이 필요합니다.';
  static const String forbiddenError = '접근 권한이 없습니다.';
  static const String notFoundError = '요청한 리소스를 찾을 수 없습니다.';
}
