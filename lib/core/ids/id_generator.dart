import 'package:uuid/uuid.dart';

abstract interface class IdGenerator {
  String newId();
}

final class UuidIdGenerator implements IdGenerator {
  UuidIdGenerator({Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  final Uuid _uuid;

  @override
  String newId() => _uuid.v7();
}
