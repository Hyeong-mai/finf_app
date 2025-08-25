import 'package:finf_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/common_layout.dart';
import '../theme/app_text_style.dart';
import '../services/api_service.dart';
import '../utils/constants.dart';
import '../utils/storage_service.dart';

class RecordPage extends StatefulWidget {
  const RecordPage({super.key});

  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // API 서비스
  final ApiService _apiService = Get.find<ApiService>();
  
  // Storage 서비스
  final StorageService _storageService = Get.find<StorageService>();
  
  // 기록 데이터
  List<Map<String, dynamic>> _staticRecords = [];
  List<Map<String, dynamic>> _timeBasedRecords = [];
  List<Map<String, dynamic>> _breathBasedRecords = [];
  
  // 로딩 상태
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    
    // 페이지 로드 시 데이터 가져오기
    _loadAllRecords();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// 모든 기록 데이터 로드
  Future<void> _loadAllRecords() async {
    if (_isLoading) return;
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      // 병렬로 모든 기록 데이터 가져오기
      final results = await Future.wait([
        _loadStaticRecords(),
        _loadTimeBasedRecords(),
        _loadBreathBasedRecords(),
      ]);
      
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = '기록을 불러오는데 실패했습니다: $e';
      });
      print('기록 로드 실패: $e');
    }
  }
  
  /// 스테틱 기록 데이터 로드
  Future<void> _loadStaticRecords() async {
    try {
      // 사용자 ID 가져오기
      final userId = await _storageService.getUserId();
      if (userId == null) {
        print('사용자 ID를 찾을 수 없습니다.');
        return;
      }
      
      final response = await _apiService.getStaticRecords(
        userId: userId,
        limit: 10,
      );
      
      if (response.statusCode == 200) {
        setState(() {
          // 서버 응답 구조: response.data['result']
          final records = response.data['result'] ?? [];
          _staticRecords = List<Map<String, dynamic>>.from(records);
        });
      }
    } catch (e) {
      print('스테틱 기록 로드 실패: $e');
      // 에러 발생 시 기본 데이터 사용
      setState(() {
        _staticRecords = [
          {'rank': 1, 'record': '120초', 'date': '2024-01-15'},
          {'rank': 2, 'record': '115초', 'date': '2024-01-14'},
          {'rank': 3, 'record': '110초', 'date': '2024-01-13'},
        ];
      });
    }
  }
  
  /// 시간기반 기록 데이터 로드
  Future<void> _loadTimeBasedRecords() async {
    try {
      // 사용자 ID 가져오기
      final userId = await _storageService.getUserId();
      if (userId == null) {
        print('사용자 ID를 찾을 수 없습니다.');
        return;
      }
      
      final response = await _apiService.getTimeBasedRecords(
        userId: userId,
        limit: 10,
      );
      
      if (response.statusCode == 200) {
        setState(() {
          // 서버 응답 구조: response.data['result']
          final records = response.data['result'] ?? [];
          _timeBasedRecords = List<Map<String, dynamic>>.from(records);
        });
      }
    } catch (e) {
      print('시간기반 기록 로드 실패: $e');
      // 에러 발생 시 기본 데이터 사용
      setState(() {
        _timeBasedRecords = [
          {'base': '120초', 'totalRounds': 5, 'totalTime': '8분 30초', 'date': '2024-01-15'},
          {'base': '115초', 'totalRounds': 4, 'totalTime': '7분 45초', 'date': '2024-01-14'},
          {'base': '110초', 'totalRounds': 6, 'totalTime': '9분 20초', 'date': '2024-01-13'},
        ];
      });
    }
  }
  
  /// 시간을 분:초 형식으로 변환하는 헬퍼 메서드
  String _formatDuration(int seconds) {
    if (seconds <= 0) return '0초';
    
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    
    if (minutes > 0) {
      return '${minutes}분 ${remainingSeconds}초';
    } else {
      return '${remainingSeconds}초';
    }
  }

  /// 호흡기반 기록 데이터 로드
  Future<void> _loadBreathBasedRecords() async {
    try {
      // 사용자 ID 가져오기
      final userId = await _storageService.getUserId();
      if (userId == null) {
        print('사용자 ID를 찾을 수 없습니다.');
        return;
      }
      
      final response = await _apiService.getBreathBasedRecords(
        userId: userId,
        limit: 10,
      );
      
      if (response.statusCode == 200) {
        setState(() {
          // 서버 응답 구조: response.data['result']
          final records = response.data['result'] ?? [];
          _breathBasedRecords = List<Map<String, dynamic>>.from(records);
        });
      }
    } catch (e) {
      print('호흡기반 기록 로드 실패: $e');
      // 에러 발생 시 기본 데이터 사용
      setState(() {
        _breathBasedRecords = [
          {'base': '120초', 'totalRounds': 5, 'totalTime': '8분 30초', 'date': '2024-01-15'},
          {'base': '115초', 'totalRounds': 4, 'totalTime': '7분 45초', 'date': '2024-01-14'},
          {'base': '110초', 'totalRounds': 6, 'totalTime': '9분 20초', 'date': '2024-01-13'},
        ];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title:  Text(
          '테이블 기록',
          style: AppTextStyles.h4m('white'),
        ),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.chevron_left, color: Colors.white),
          onPressed: () {
            Get.back();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadAllRecords,
          ),
        ],
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,

          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withOpacity(0.6),
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: AppTheme.primaryColor.withOpacity(0.7),
          labelStyle: AppTextStyles.b1m('white'),
          unselectedLabelStyle: AppTextStyles.b1r('white'),
          tabs: const [
            Tab(text: '스테틱'),
            Tab(text: '시간기반'),
            Tab(text: '호흡기반'),
          ],
        ),
      ),
      body: CommonLayout(
         overlayColor: AppTheme.primaryColor,

         overlayOpacity: 0.7,
        child: SafeArea(
          child: TabBarView(
            controller: _tabController,
            children: [
              // 스테틱 기록 탭
              SingleChildScrollView(child: _buildStaticRecordTable()),

              // 시간기반 기록 탭
              SingleChildScrollView(child: _buildTimeBasedRecordTable()),

              // 호흡기반 기록 탭
              SingleChildScrollView(child: _buildBreathBasedRecordTable()),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildStaticRecordTable() {
    // 로딩 상태 표시
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }
    
    // 에러 상태 표시
    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _errorMessage!,
              style: AppTextStyles.b1r('white'),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadAllRecords,
              child: const Text('다시 시도'),
            ),
          ],
        ),
      );
    }
    
    // 데이터가 없을 때
    if (_staticRecords.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(height: 100),
            Text(
              '기록이 없습니다.',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Container(
      child: Column(
        children: [
          // 테이블 헤더
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(24)),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Text('순위', style: AppTextStyles.b3r('white')),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Text('기록', style: AppTextStyles.b3r('white')),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Text('날짜', style: AppTextStyles.b3r('white')),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

                    // 테이블 데이터
          ..._staticRecords
              .asMap()
              .entries
              .map(
                (entry) {
                  final index = entry.key;
                  final record = entry.value;
                  
                  // 날짜 포맷팅
                  final createdAt = DateTime.tryParse(record['createdAt'] ?? '');
                  final formattedDate = createdAt != null 
                      ? '${createdAt.year}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}'
                      : 'N/A';
                  
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 24,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: Text(
                              '${index + 1}', // 순위는 인덱스 기반
                              textAlign: TextAlign.center,
                              style: AppTextStyles.b1r('white'),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            '${record['record']}초', // record 필드 사용
                            textAlign: TextAlign.center,
                            style: AppTextStyles.b1r('white'),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            formattedDate, // createdAt 필드 사용
                            textAlign: TextAlign.center,
                            style: AppTextStyles.b1r('white'),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )
              .toList(),
        ],
      ),
    );
  }

  Widget _buildBreathBasedRecordTable() {
    // 로딩 상태 표시
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }
    
    // 에러 상태 표시
    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _errorMessage!,
              style: AppTextStyles.b1r('white'),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadAllRecords,
              child: const Text('다시 시도'),
            ),
          ],
        ),
      );
    }
    
    // 데이터가 없을 때
    if (_breathBasedRecords.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(height: 100),
            Text(
              '기록이 없습니다.',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Container(
      child: Column(
        children: [
          // 테이블 헤더
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    '준비 호흡',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.b3r('white'),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    '스테틱 기록',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.b3r('white'),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    '총 라운드',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.b3r('white'),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    '총 시간',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.b3r('white'),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    '날짜',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.b3r('white'),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // 테이블 데이터
          ..._breathBasedRecords
              .asMap()
              .entries
              .map(
                (entry) {
                  final index = entry.key;
                  final record = entry.value;
                  
                  // 날짜 포맷팅
                  final createdAt = DateTime.tryParse(record['createdAt'] ?? '');
                  final formattedDate = createdAt != null 
                      ? '${createdAt.year}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}'
                      : 'N/A';
                  
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 24,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            '${record['preparatoryBreathDuration'] ?? 'N/A'}초', // 준비 호흡 시간
                            textAlign: TextAlign.center,
                            style: AppTextStyles.b1r('white'),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            '${record['staticRecord'] ?? 'N/A'}초', // 스테틱 기록
                            textAlign: TextAlign.center,
                            style: AppTextStyles.b1r('white'),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            '${record['totalRounds'] ?? 'N/A'}',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.b1r('white'),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            _formatDuration(record['totalSetTime'] ?? 0), // 총 시간을 분:초 형식으로 변환
                            textAlign: TextAlign.center,
                            style: AppTextStyles.b1r('white'),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            formattedDate, // createdAt 필드 사용
                            textAlign: TextAlign.center,
                            style: AppTextStyles.b1r('white'),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )
              .toList(),
        ],
      ),
    );
  }

  Widget _buildTimeBasedRecordTable() {
    // 로딩 상태 표시
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }
    
    // 에러 상태 표시
    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _errorMessage!,
              style: AppTextStyles.b1r('white'),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadAllRecords,
              child: const Text('다시 시도'),
            ),
          ],
        ),
      );
    }
    
    // 데이터가 없을 때
    if (_timeBasedRecords.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(height: 100),
            Text(
              '기록이 없습니다.',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Container(
      child: Column(
        children: [
          // 테이블 헤더
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child:  Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    '스테틱 기록',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.b3r('white'),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    '총 라운드',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.b3r('white'),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    '총 시간',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.b3r('white'),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    '날짜',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.b3r('white'),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

                    // 테이블 데이터
          ..._timeBasedRecords
              .asMap()
              .entries
              .map(
                (entry) {
                  final index = entry.key;
                  final record = entry.value;
                  
                  // 날짜 포맷팅
                  final createdAt = DateTime.tryParse(record['createdAt'] ?? '');
                  final formattedDate = createdAt != null 
                      ? '${createdAt.year}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}'
                      : 'N/A';
                  
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 24,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            '${record['staticRecord'] ?? 'N/A'}초', // staticRecord 필드 사용
                            textAlign: TextAlign.center,
                            style: AppTextStyles.b1r('white'),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            '${record['totalRounds'] ?? 'N/A'}',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.b1r('white'),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            _formatDuration(record['totalSetTime'] ?? 0), // totalSetTime을 시간 형식으로 변환
                            textAlign: TextAlign.center,
                            style: AppTextStyles.b1r('white'),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            formattedDate, // createdAt 필드 사용
                            textAlign: TextAlign.center,
                            style: AppTextStyles.b1r('white'),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )
              .toList(),
        ],
      ),
    );
  }

}
