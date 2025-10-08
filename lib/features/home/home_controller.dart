import 'package:fitness_health_app/app/data/providers/health_provider.dart';
import 'package:get/get.dart';

class FitnessSummary {
  final int steps;
  final double activeKcals;
  FitnessSummary({required this.steps, required this.activeKcals});
}

class HomeController extends GetxController {
  final HealthProvider provider;

  HomeController(this.provider);

  final Rxn<FitnessSummary> summary = Rxn<FitnessSummary>();
  final isLoading = true.obs;
  final error = RxnString();

  final int stepsGoal = 15000;
  final int kcalGoal = 1000;

  double stepsProgress(int steps) => (steps / stepsGoal).clamp(0, 1).toDouble();
  double kcalProgress(double kcals) => (kcals / kcalGoal).clamp(0, 1).toDouble();

  @override
  Future<void> onInit() async {
    super.onInit();
    await _load();
  }

  Future<void> _load() async {
    isLoading.value = true;
    error.value = null;

    try {
      await provider.signIn();

      final steps = await provider.getTodaySteps();
      final kcals = await provider.getTodayActiveKcals();

      summary.value = FitnessSummary(steps: steps, activeKcals: kcals);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refresh() async => await _load();
}
