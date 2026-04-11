import '../../../core/result/result.dart';
import 'wallet_ledger_entry.dart';

abstract interface class WalletRepository {
  Stream<int> watchBalance();
  Stream<List<WalletLedgerEntry>> watchLedger();
  Future<Result<int>> getBalance();
  Future<Result<List<WalletLedgerEntry>>> recentEntries({required int limit});
  Future<Result<Unit>> appendLedgerEntry(WalletLedgerEntry entry);
}
