import 'package:get/get.dart';
import 'package:finf_app/core/service/api_service.dart';
import 'package:finf_app/core/model/static_record_model.dart';

class MainController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  final RxList<StaticRecord> staticRecords = <StaticRecord>[].obs;
  final Rx<StaticRecord?> highestRecord = Rx<StaticRecord?>(null);
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getStaticRecords();
    fetchHighestStaticRecord();
  }

  Future<void> getStaticRecords() async {
    try {
      isLoading.value = true;
      final records = await _apiService.getStaticRecords();
      staticRecords.value =
          records.map((record) => StaticRecord.fromJson(record)).toList();
    } catch (e) {
      Get.snackbar('오류', '기록을 불러오는데 실패했습니다.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchHighestStaticRecord() async {
    try {
      isLoading.value = true;
      final record = await _apiService.getHighestStaticRecord();
      highestRecord.value = StaticRecord.fromJson(record);
    } catch (e) {
      Get.snackbar('오류', '최고 기록을 불러오는데 실패했습니다.');
    } finally {
      isLoading.value = false;
    }
  }
}
