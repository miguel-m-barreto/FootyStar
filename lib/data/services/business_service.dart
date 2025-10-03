import '../../domain/business.dart';

class BusinessService {
  const BusinessService();

  bool meetsRequirements({
    required Business business,
    required int teamOvr,
    required double teamAvgReputation,
  }) {
    return teamOvr >= business.reqOvr && teamAvgReputation >= business.reqReputation;
  }

  int nextUpgradeCost(Business b) => b.costForNextLevel();

  int incomeDeltaIfUpgrade(Business b) {
    if (!b.canUpgrade) return 0;
    final nextLevel = b.level + 1;
    return b.incomeAt(nextLevel) - b.currentIncome();
  }
}
