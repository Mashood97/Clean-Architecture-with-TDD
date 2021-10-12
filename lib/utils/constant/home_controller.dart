import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController with WidgetsBindingObserver {
  final RxBool _isActive = true.obs;
  bool get isActive => _isActive.value;

  late Rx<Timer> _timer;
  Timer get timer => _timer.value;

  RxInt _counter = 0.obs;
  int get counter => _counter.value;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    //when in foreground and not visible first inactive and then paused called.
    //foreground and isvisible: inactive and then resumed.
    //for location foreground we may use
    if (state == AppLifecycleState.paused) {
      _isActive.value = true;
      debugPrint("Paused");
    } else if (state == AppLifecycleState.inactive) {
      _isActive.value = false;
      debugPrint("Inactive");
    } else if (state == AppLifecycleState.resumed) {
      _isActive.value = true;
      debugPrint("Resumed");
    } else if (state == AppLifecycleState.detached) {
      _isActive.value = false;
      debugPrint("Deteached");
    }
  }

  @override
  void onInit() {
    WidgetsBinding.instance!.addObserver(this);
    _timer = Rx<Timer>(
      Timer.periodic(
        const Duration(seconds: 1),
        (timer) {
          if (_isActive.value) {
            _counter++;
          }
        },
      ),
    );
    super.onInit();
  }

  @override
  void onClose() {
    _timer.close();
    _timer.value.cancel();

    WidgetsBinding.instance!.removeObserver(this);

    super.onClose();
  }
}
