import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'home_controller.dart';

class HomePage extends StatelessWidget {
  final _home = Get.put(HomeController());
//https://blog.codemagic.io/creating-a-route-calculator-using-google-maps/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Obx(
      () => GoogleMap(
        onMapCreated: (controller) => _home.onMapCreated(controller),
        initialCameraPosition: _home.cameraPosition == null
            ? const CameraPosition(
                target: LatLng(28.823550591630404, 69.78328740707093),
                // zoom: 11.5,
              )
            : _home.cameraPosition!,
        markers: {
          if (_home.originMarker != null) _home.originMarker!,
          if (_home.destinationMarker != null) _home.destinationMarker!,
        },
        myLocationButtonEnabled: false,
        myLocationEnabled: true,
        polylines: Set<Polyline>.of(_home.polylines.values),
      ),
    ));
  }
}
