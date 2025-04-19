import 'package:hive/hive.dart';

part 'token_model.g.dart';

@HiveType(typeId: 0)
class TokenModel extends HiveObject {
  @HiveField(0)
  final String accessToken;

  @HiveField(1)
  final String refreshToken;

  @HiveField(2)
  final DateTime expiresAt;

  TokenModel({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
  });
}
