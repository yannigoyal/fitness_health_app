import 'package:fitness_health_app/features/splash/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 140,
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Center(
                    child: SvgPicture.asset(
                      isDark
                          ? 'assets/images/BoozinLogoDark.svg'
                          : 'assets/images/Boozin Logo.svg',
                      width: 140,
                    ),
                  ),

                  Obx(() {
                    return AnimatedAlign(
                      alignment: controller.isSecondIcon.value
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      duration: const Duration(milliseconds: 2000),
                      curve: Curves.easeInOut,
                      child: SvgPicture.asset(
                        isDark
                            ? 'assets/images/pin_dark.svg'
                            : 'assets/images/pin.svg',
                        width: 30,
                      ),
                    );
                  }),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Text(
              "Fitness",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

