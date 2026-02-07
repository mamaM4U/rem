import 'package:get/get.dart';
import 'package:arona/helpers/dev_print.dart';
import 'package:arona/modules/homepage/services/homepage_service.dart';

class HomepageController extends GetxController {
  final HomepageService homepageService = Get.find();
  RxList homepageData = List.empty(growable: true).obs;

  @override
  void onInit() {
    // called immediately after the widget is allocated memory
    getHomepageData();
    super.onInit();
  }

  Future<void> getHomepageData() async {
    try {
      List? homepageDataRes = await homepageService.getHomepageData();
      if (homepageDataRes != null) {
        homepageData(homepageDataRes);
      }
    } catch (e) {
      devPrint('Error in homepage controller, $e');
    }
    update();
  }
}
