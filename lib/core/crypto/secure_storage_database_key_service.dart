import 'dart:convert';
import 'dart:math';

import '../logging/app_logger.dart';
import 'database_key_service.dart';

final class SecureStorageDatabaseKeyService implements DatabaseKeyService {
  SecureStorageDatabaseKeyService({
    required SecureSecretStore secretStore,
    required AppLogger logger,
    Random? random,
  }) : _secretStore = secretStore,
       _logger = logger,
       _random = random ?? Random.secure();

  final SecureSecretStore _secretStore;
  final AppLogger _logger;
  final Random _random;

  @override
  Future<String> getOrCreateDatabaseKey() async {
    final existing = await _secretStore.read(SecureStorageKeys.databaseKey);
    if (existing != null && existing.isNotEmpty) {
      return existing;
    }

    final bytes = List<int>.generate(32, (_) => _random.nextInt(256));
    final generatedKey = base64UrlEncode(bytes);
    await _secretStore.write(SecureStorageKeys.databaseKey, generatedKey);
    _logger.info('Generated and stored a new database encryption key.');
    return generatedKey;
  }
}
