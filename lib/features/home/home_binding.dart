import 'package:get/get.dart';

import '../../app/data/providers/health_provider.dart';
import '../../app/data/repositories/health_repository.dart';
import 'home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HealthProvider());
    Get.lazyPut(() => HealthRepository(Get.find()));
    Get.put(HomeController(Get.find()));
  }
}
