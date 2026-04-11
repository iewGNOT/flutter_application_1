final class GachaDrawPreviewState {
  const GachaDrawPreviewState({
    required this.currentBalance,
    required this.singleDrawCost,
    required this.tenDrawCost,
    required this.availableRewardCount,
  });

  final int currentBalance;
  final int singleDrawCost;
  final int tenDrawCost;
  final int availableRewardCount;

  bool get canSingleDraw =>
      currentBalance >= singleDrawCost && availableRewardCount >= 1;
  bool get canTenDraw =>
      currentBalance >= tenDrawCost && availableRewardCount >= 10;
}
