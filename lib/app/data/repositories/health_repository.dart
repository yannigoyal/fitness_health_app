import '../models/fitness_summary.dart';
import '../providers/health_provider.dart';

class HealthRepository {
  final HealthProvider provider;
  HealthRepository(this.provider);

  Future<FitnessSummary> today() async {
    final steps = await provider.getTodaySteps();
    final kcals = await provider.getTodayActiveKcals();
    return FitnessSummary(steps: steps, activeKcals: kcals);
  }
}
