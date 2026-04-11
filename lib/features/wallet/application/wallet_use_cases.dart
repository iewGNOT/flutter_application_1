import '../../../core/result/result.dart';
import '../domain/wallet_ledger_entry.dart';
import '../domain/wallet_repository.dart';

final class GetWalletBalanceUseCase {
  const GetWalletBalanceUseCase(this._walletRepository);

  final WalletRepository _walletRepository;

  Future<Result<int>> call() => _walletRepository.getBalance();
}

final class WatchWalletBalanceUseCase {
  const WatchWalletBalanceUseCase(this._walletRepository);

  final WalletRepository _walletRepository;

  Stream<int> call() => _walletRepository.watchBalance();
}

final class GetRecentWalletEntriesUseCase {
  const GetRecentWalletEntriesUseCase(this._walletRepository);

  final WalletRepository _walletRepository;

  Future<Result<List<WalletLedgerEntry>>> call({int limit = 20}) {
    return _walletRepository.recentEntries(limit: limit);
  }
}
