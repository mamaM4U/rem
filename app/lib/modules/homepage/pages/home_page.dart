import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:arona/constants/colors.dart';
import 'package:arona/helpers/dev_print.dart';
import 'package:arona/modules/homepage/controllers/homepage_controller.dart';
import 'package:arona/widgets/listview_widget.dart';

class HomePage extends StatelessWidget {
  final HomepageController _homepageController = Get.isRegistered<HomepageController>() ? Get.find() : Get.put(HomepageController());
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          EasyLoading.show();
          devPrint('test');
          Future.delayed(const Duration(seconds: 1), () => EasyLoading.dismiss());
        },
        elevation: 1,
        backgroundColor: FONT_WHITE_COLOR,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 36, color: PRIMARY_COLOR),
      ),
      body: Obx(
        () => ListView.builder(
          itemCount: _homepageController.homepageData.length,
          itemBuilder: (context, index) {
            final todo = _homepageController.homepageData[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListviewWidget(
                title: todo['todo'],
                subtitle: "Completed: ${todo['completed'] ? 'Yes' : 'No'}",
                prefixWidget: Icon(
                  todo['completed'] ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: todo['completed'] ? Colors.green : Colors.grey,
                ),
                onTap: () {
                  debugPrint("Tapped on: ${todo['todo']}");
                },
              ),
            );
          },
        ),
      ),
    ));
  }
}
