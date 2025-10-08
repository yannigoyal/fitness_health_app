import 'package:fitness_health_app/features/home/home_binding.dart';
import 'package:fitness_health_app/features/home/home_view.dart';
import 'package:get/get.dart';
import '../../features/splash/splash_binding.dart';
import '../../features/splash/splash_view.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = <GetPage>[
    GetPage(name: Routes.SPLASH, page: () => const SplashView(), binding: SplashBinding()),
    GetPage(name: Routes.HOME,   page: () => const HomeView(),   binding: HomeBinding()),
  ];
}
