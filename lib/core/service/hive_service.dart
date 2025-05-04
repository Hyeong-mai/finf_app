import 'package:hive_flutter/hive_flutter.dart';
import 'package:finf_app/core/model/token_model.dart';
import 'package:path_provider/path_provider.dart';

class HiveService {
  static const String tokenBoxName = 'tokenBox';

  static Future<void> init() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDocumentDir.path);
    Hive.registerAdapter(TokenModelAdapter());
    await Hive.openBox<TokenModel>(tokenBoxName);
  }

  static Box<TokenModel> get tokenBox => Hive.box<TokenModel>(tokenBoxName);

  static Future<void> saveToken(TokenModel token) async {
    await tokenBox.put('token', token);
  }

  static TokenModel? getToken() {
    return tokenBox.get('token');
  }

  static Future<void> clearToken() async {
    await tokenBox.clear();
  }
}
