abstract interface class DatabaseKeyService {
  Future<String> getOrCreateDatabaseKey();
}

abstract interface class SecureSecretStore {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
  Future<void> delete(String key);
}

abstract final class SecureStorageKeys {
  static const databaseKey = 'lifegacha.database_key.v1';
}
