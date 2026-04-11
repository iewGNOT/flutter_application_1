import '../result/result.dart';

abstract interface class AppSettingsRepository {
  Future<Result<String?>> readString(String key);
  Future<Result<Unit>> writeString(String key, String value);
}
