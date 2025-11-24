import 'package:get/get.dart';
import 'package:arona/modules/homepage/controllers/homepage_controller.dart';
import 'package:arona/modules/homepage/services/homepage_service.dart';

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
