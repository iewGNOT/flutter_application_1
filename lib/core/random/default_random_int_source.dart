import 'dart:math';

import 'random_int_source.dart';

final class DefaultRandomIntSource implements RandomIntSource {
  DefaultRandomIntSource({Random? random})
    : _random = random ?? Random.secure();

  final Random _random;

  @override
  int nextInt(int maxExclusive) => _random.nextInt(maxExclusive);
}
