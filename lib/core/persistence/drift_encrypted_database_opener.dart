import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/open.dart' as sqlite3_open;
import 'package:sqlcipher_flutter_libs/sqlcipher_flutter_libs.dart';

import '../crypto/database_key_service.dart';
import '../error/app_failure.dart';
import '../logging/app_logger.dart';
import 'encrypted_database_opener.dart';

final class DriftEncryptedDatabaseOpener implements EncryptedDatabaseOpener {
  DriftEncryptedDatabaseOpener({
    required DatabaseKeyService databaseKeyService,
    required AppLogger logger,
    this.databaseFileName = 'lifegacha.sqlite',
  }) : _databaseKeyService = databaseKeyService,
       _logger = logger;

  final DatabaseKeyService _databaseKeyService;
  final AppLogger _logger;
  final String databaseFileName;

  @override
  Future<QueryExecutor> open() async {
    try {
      await applyWorkaroundToOpenSqlCipherOnOldAndroidVersions();
      sqlite3_open.open.overrideFor(
        sqlite3_open.OperatingSystem.android,
        openCipherOnAndroid,
      );

      final directory = await getApplicationSupportDirectory();
      await directory.create(recursive: true);
      final databaseFile = File(path.join(directory.path, databaseFileName));
      final databaseKey = await _databaseKeyService.getOrCreateDatabaseKey();

      _logger.info('Opening encrypted Drift database at ${databaseFile.path}.');

      return NativeDatabase.createInBackground(
        databaseFile,
        setup: (rawDatabase) {
          // Platform integration notes:
          // 1. Android requires sqlcipher_flutter_libs and openCipherOnAndroid.
          // 2. iOS/macOS must ensure SQLCipher is the linked sqlite variant.
          // 3. Never log or persist the database key outside secure storage.
          final cipherVersionCheck = rawDatabase.select(
            'PRAGMA cipher_version;',
          );
          if (cipherVersionCheck.isEmpty) {
            throw const DatabaseEncryptionFailure(
              'SQLCipher is not available in the current runtime.',
            );
          }

          rawDatabase.execute("PRAGMA key = '$databaseKey';");
          rawDatabase.execute('PRAGMA foreign_keys = ON;');
          rawDatabase.execute('PRAGMA journal_mode = WAL;');
        },
      );
    } catch (error, stackTrace) {
      _logger.error(
        'Failed to open the encrypted Drift database.',
        error: error,
        stackTrace: stackTrace,
      );
      throw const DatabaseEncryptionFailure();
    }
  }
}
