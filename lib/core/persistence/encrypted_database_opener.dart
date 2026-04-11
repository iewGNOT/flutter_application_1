import 'package:drift/drift.dart';

abstract interface class EncryptedDatabaseOpener {
  Future<QueryExecutor> open();
}
