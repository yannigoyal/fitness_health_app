import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SafeArea(
      child: Scaffold(
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.error.value != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(controller.error.value!, textAlign: TextAlign.center),
              ),
            );
          }
      
          final s = controller.summary.value!;
          final steps = s.steps;
          final kcals = s.activeKcals;
      
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 16),
                child: Text('Hi!',
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall
                        ?.copyWith(fontWeight: FontWeight.w700)),
              ),
              _StatCard(
                title: 'Steps',
                valueText: _formatNumber(steps),
                progress: controller.stepsProgress(steps),
                leadingSub: '0',
                trailingSub: 'Goal: ${controller.stepsGoal.toString()}',
                icon: SvgPicture.asset("assets/images/ion_footsteps-sharp.svg", colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.onSurface, // or onPrimary, etc.
                  BlendMode.srcIn,
                ),),
                barColor: cs.primary,
              ),
              const SizedBox(height: 16),
              _StatCard(
                title: 'Calories Burned',
                valueText: kcals.toStringAsFixed(0),
                progress: controller.kcalProgress(kcals),
                leadingSub: '0',
                trailingSub: 'Goal: ${controller.kcalGoal}',
                icon: SvgPicture.asset("assets/images/kcal 1.svg",colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.onSurface, // or onPrimary, etc.
                  BlendMode.srcIn,
                ),),
                barColor: cs.primary,
              ),
            ],
          );
        }),
      ),
    );
  }

  String _formatNumber(int n) {
    final s = n.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final fromEnd = s.length - i;
      buf.write(s[i]);
      if (fromEnd > 1 && fromEnd % 3 == 1) buf.write(',');
    }
    return buf.toString();
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String valueText;
  final double progress;
  final String leadingSub;
  final String trailingSub;
  final Widget icon;
  final Color barColor;

  const _StatCard({
    required this.title,
    required this.valueText,
    required this.progress,
    required this.leadingSub,
    required this.trailingSub,
    required this.icon,
    required this.barColor,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '$title:',
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        valueText,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: progress.isNaN ? 0 : progress,
                      minHeight: 12,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // 0  |  Goal
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(leadingSub, style: textTheme.labelSmall),
                      Text(trailingSub, style: textTheme.labelSmall),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                icon,
              ],
            ),
          ],
        ),
      ),
    );
  }
}