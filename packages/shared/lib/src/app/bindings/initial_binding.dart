import 'package:get/get.dart';
import '../modules/homepage/controllers/homepage_controller.dart';
import '../modules/homepage/services/homepage_service.dart';

class InitialBindings implements Bindings {
  @override
  void dependencies() {
    // register servives
    Get.put(HomepageService());

    // register controllers
    if (!Get.isRegistered<HomepageController>()) {
      Get.put(HomepageController());
    }
  }
}
