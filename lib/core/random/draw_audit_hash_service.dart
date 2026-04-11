import 'dart:convert';

import 'package:crypto/crypto.dart';

import '../../features/gacha/domain/gacha_draw.dart';

abstract interface class DrawAuditHashService {
  String createHash(GachaDraw draw);
}

final class Sha256DrawAuditHashService implements DrawAuditHashService {
  const Sha256DrawAuditHashService();

  @override
  String createHash(GachaDraw draw) {
    final payload = [
      draw.id,
      draw.drawType.name,
      draw.costPoints.toString(),
      draw.rolledRarity.name,
      draw.rewardCardId,
      draw.createdAt.toUtc().toIso8601String(),
    ].join('|');

    return sha256.convert(utf8.encode(payload)).toString();
  }
}
