import 'package:drift/native.dart';
import 'package:life_gacha/core/logging/app_logger.dart';
import 'package:life_gacha/core/persistence/life_gacha_database.dart';

Future<LifeGachaDatabase> createTestDatabase() async {
  final database = LifeGachaDatabase(
    executor: NativeDatabase.memory(),
    logger: const NoopAppLogger(),
  );
  await database.ensureReady();
  return database;
}
