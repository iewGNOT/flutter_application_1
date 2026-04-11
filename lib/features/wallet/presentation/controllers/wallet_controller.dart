import 'package:flutter_riverpod/flutter_riverpod.dart';

final walletControllerProvider = Provider<WalletController>((ref) {
  return const WalletController();
});

final class WalletController {
  const WalletController();
}
