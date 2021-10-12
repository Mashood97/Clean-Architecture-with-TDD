import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';

import 'home_controller.dart';

class HomePage extends StatelessWidget {
  final _home = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Obx(
          () => Text(
            _home.counter.toString(),
          ),
        ),
      ),
    );
  }
}
