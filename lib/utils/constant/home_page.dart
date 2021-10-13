import 'package:flutter/material.dart';
import 'package:flutter_animarker/flutter_map_marker_animation.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'home_controller.dart';

class HomePage extends StatelessWidget {
  final _home = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: const Text('Google map live tracking'),
        ),
        body: SafeArea(
          child: Obx(
            () => Animarker(
              mapId: Future.value(_home.mapId.value),
              curve: Curves.ease,
              shouldAnimateCamera: false,
              useRotation: true,
              duration: const Duration(milliseconds: 5000),
              zoom: 10.0,
              markers: {
                if (_home.userMarker != null) _home.userMarker!,
                if (_home.originMarker != null) _home.originMarker!,
                if (_home.destinationMarker != null) _home.destinationMarker!,
              },
              child: GoogleMap(
                onMapCreated: (controller) => _home.onMapCreated(controller),
                initialCameraPosition: _home.cameraPosition == null
                    ? const CameraPosition(
                        target: LatLng(28.823550591630404, 69.78328740707093),
                        // zoom: 11.5,
                      )
                    : _home.cameraPosition!,
                myLocationButtonEnabled: true,
                zoomControlsEnabled: false,
                myLocationEnabled: false,
                polylines: Set<Polyline>.of(_home.polylines.values),
              ),
            ),

//If you want details with it uncommment this and paste it in body.
            //     Stack(
            //   children: [
            //     SizedBox(
            //       width: Get.width,
            //       height: Get.height,
            //       child: Animarker(
            //         mapId: Future.value(_home.mapId.value),
            //         curve: Curves.ease,
            //         shouldAnimateCamera: false,
            //         useRotation: true,
            //         duration: const Duration(milliseconds: 5000),
            //         zoom: 10.0,
            //         markers: {
            //           if (_home.userMarker != null) _home.userMarker!,
            //           if (_home.originMarker != null) _home.originMarker!,
            //           if (_home.destinationMarker != null)
            //             _home.destinationMarker!,
            //         },
            //         child: GoogleMap(
            //           onMapCreated: (controller) =>
            //               _home.onMapCreated(controller),
            //           initialCameraPosition: _home.cameraPosition == null
            //               ? const CameraPosition(
            //                   target:
            //                       LatLng(28.823550591630404, 69.78328740707093),
            //                   // zoom: 11.5,
            //                 )
            //               : _home.cameraPosition!,
            //           myLocationButtonEnabled: true,
            //           zoomControlsEnabled: false,
            //           myLocationEnabled: false,
            //           polylines: Set<Polyline>.of(_home.polylines.values),
            //         ),
            //       ),
            //     ),
            //     Align(
            //       alignment: Alignment.bottomCenter,
            //       child: SizedBox(
            //         width: Get.width,
            //         height: Get.height * 0.4,
            //         child: Card(
            //           margin: EdgeInsets.zero,
            //           shape: const RoundedRectangleBorder(
            //             borderRadius: BorderRadius.only(
            //               topLeft: Radius.circular(20),
            //               topRight: Radius.circular(20),
            //             ),
            //           ),
            //           child: Padding(
            //             padding: const EdgeInsets.all(8.0),
            //             child: SingleChildScrollView(
            //               child: Column(
            //                 mainAxisAlignment: MainAxisAlignment.start,
            //                 crossAxisAlignment: CrossAxisAlignment.start,
            //                 children: [
            //                   const Align(
            //                     alignment: Alignment.topCenter,
            //                     child: Icon(
            //                       Icons.remove,
            //                       color: Colors.grey,
            //                       size: 30,
            //                     ),
            //                   ),
            //                   const Divider(),
            //                   const SizedBox(
            //                     height: 10,
            //                   ),
            //                   const Text(
            //                     "Delivery Trip Details",
            //                     style: TextStyle(
            //                         color: Colors.deepPurple,
            //                         fontSize: 18,
            //                         fontWeight: FontWeight.w600),
            //                   ),
            //                   const Divider(),
            //                   const SizedBox(
            //                     height: 10,
            //                   ),
            //                   Row(
            //                     mainAxisAlignment:
            //                         MainAxisAlignment.spaceBetween,
            //                     crossAxisAlignment: CrossAxisAlignment.center,
            //                     children: [
            //                       Expanded(
            //                         child: Row(
            //                           children: const [
            //                             Icon(
            //                               Icons.my_location,
            //                               color: Colors.grey,
            //                             ),
            //                             SizedBox(
            //                               width: 5,
            //                             ),
            //                             Text(
            //                               "Origin:",
            //                               style: TextStyle(
            //                                 color: Colors.black,
            //                                 fontSize: 14,
            //                                 fontWeight: FontWeight.w300,
            //                               ),
            //                             ),
            //                           ],
            //                         ),
            //                       ),
            //                       Expanded(
            //                         child: Text(
            //                           _home.originAddress!,
            //                           textAlign: TextAlign.end,
            //                           style: const TextStyle(
            //                               color: Colors.deepPurple,
            //                               fontSize: 14,
            //                               fontWeight: FontWeight.w500),
            //                         ),
            //                       ),
            //                     ],
            //                   ),
            //                   const SizedBox(
            //                     height: 10,
            //                   ),
            //                   Row(
            //                     mainAxisAlignment:
            //                         MainAxisAlignment.spaceBetween,
            //                     crossAxisAlignment: CrossAxisAlignment.center,
            //                     children: [
            //                       Expanded(
            //                         child: Row(
            //                           children: const [
            //                             Icon(
            //                               Icons.where_to_vote_rounded,
            //                               color: Colors.grey,
            //                             ),
            //                             SizedBox(
            //                               width: 5,
            //                             ),
            //                             Text(
            //                               "Destination:",
            //                               style: TextStyle(
            //                                 color: Colors.black,
            //                                 fontSize: 14,
            //                                 fontWeight: FontWeight.w300,
            //                               ),
            //                             ),
            //                           ],
            //                         ),
            //                       ),
            //                       Expanded(
            //                         child: Text(
            //                           _home.destinationAddress!,
            //                           textAlign: TextAlign.end,
            //                           style: const TextStyle(
            //                               color: Colors.deepPurple,
            //                               fontSize: 14,
            //                               fontWeight: FontWeight.w500),
            //                         ),
            //                       ),
            //                     ],
            //                   ),
            //                   const Divider(),
            //                   const SizedBox(
            //                     height: 10,
            //                   ),
            //                   Row(
            //                     mainAxisAlignment:
            //                         MainAxisAlignment.spaceBetween,
            //                     crossAxisAlignment: CrossAxisAlignment.center,
            //                     children: [
            //                       Row(
            //                         children: const [
            //                           Icon(
            //                             Icons.social_distance,
            //                             color: Colors.grey,
            //                           ),
            //                           SizedBox(
            //                             width: 5,
            //                           ),
            //                           Text(
            //                             "Total Trip Distance:",
            //                             style: TextStyle(
            //                               color: Colors.black,
            //                               fontSize: 14,
            //                               fontWeight: FontWeight.w300,
            //                             ),
            //                           ),
            //                         ],
            //                       ),
            //                       Text(
            //                         _home.totalDistance,
            //                         style: const TextStyle(
            //                           color: Colors.deepPurple,
            //                           fontSize: 14,
            //                           fontWeight: FontWeight.w500,
            //                         ),
            //                       ),
            //                     ],
            //                   ),
            //                   const SizedBox(
            //                     height: 10,
            //                   ),
            //                   Row(
            //                     mainAxisAlignment:
            //                         MainAxisAlignment.spaceBetween,
            //                     crossAxisAlignment: CrossAxisAlignment.center,
            //                     children: [
            //                       Row(
            //                         children: const [
            //                           Icon(
            //                             Icons.timer,
            //                             color: Colors.grey,
            //                           ),
            //                           SizedBox(
            //                             width: 5,
            //                           ),
            //                           Text(
            //                             "Total Trip Duration:",
            //                             style: TextStyle(
            //                               color: Colors.black,
            //                               fontSize: 14,
            //                               fontWeight: FontWeight.w300,
            //                             ),
            //                           ),
            //                         ],
            //                       ),
            //                       Text(
            //                         _home.tripTotalTime!,
            //                         style: const TextStyle(
            //                           color: Colors.deepPurple,
            //                           fontSize: 14,
            //                           fontWeight: FontWeight.w500,
            //                         ),
            //                       ),
            //                     ],
            //                   ),
            //                   const Divider(),
            //                 ],
            //               ),
            //             ),
            //           ),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
          ),
        ));
  }
}
