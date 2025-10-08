import 'dart:async';
import 'package:get/get.dart';

import '../../app/routes/app_routes.dart';

class SplashController extends GetxController {
  final isSecondIcon = false.obs;

  @override
  void onInit() {
    super.onInit();

    Timer(const Duration(milliseconds: 500), () {
      isSecondIcon.value = true;
    });

    Timer(const Duration(milliseconds: 3000), () {
      Get.offAllNamed(Routes.HOME);
    });
  }
}