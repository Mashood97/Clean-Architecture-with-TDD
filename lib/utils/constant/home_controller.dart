import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeController extends GetxController with WidgetsBindingObserver {
  final RxBool _isActive = true.obs;

  bool get isActive => _isActive.value;

  late Rx<Timer> _timer;

  Timer get timer => _timer.value;

  RxInt _counter = 0.obs;

  int get counter => _counter.value;



  //List for binding stream of geo locator live position
  Rx<Position>? _postionsList;
  Position? get positionList =>
      _postionsList != null ? _postionsList!.value : null;

  //Google map controller
  Rx<GoogleMapController>? _googleMapController;

  GoogleMapController? get googleMapController =>
      _googleMapController != null ? _googleMapController!.value : null;



  //Camera Position for google map

  Rx<CameraPosition>? _cameraPosition;

  CameraPosition? get cameraPosition =>
      _cameraPosition != null ? _cameraPosition!.value : null;


  //Origin Marker
  Rx<Marker>? _originMarker;

  Marker? get originMarker =>
      _originMarker != null ? _originMarker!.value : null;

  //Destination Marker
  Rx<Marker>? _destinationMarker;

  Marker? get destinationMarker =>
      _destinationMarker != null ? _destinationMarker!.value : null;


  //On Map Created
  onMapCreated(controller) =>
      _googleMapController = Rx<GoogleMapController>(controller);


  //For checking lifecycle of app
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    //when in foreground and not visible first inactive and then paused called.
    //foreground and isvisible: inactive and then resumed.
    //for location foreground we may use
    if (state == AppLifecycleState.paused) {
      _isActive.value = false;

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


  //Destination and origin points coming from api for setting polylines

  final Rx<LatLng>? _destinationPoint =
      Rx<LatLng>(const LatLng(24.865361133450357, 67.05622915385662));
  final Rx<LatLng>? _originPoint =
      Rx<LatLng>(const LatLng(24.85871738270853, 67.06132739779827));

  LatLng get destinationPoint => _destinationPoint!.value;



  //This will add new lat lng always for live tracking
  final RxList<LatLng> _getLiveLocation = RxList();

  List<LatLng> get liveLocationTracking => [..._getLiveLocation];


  //This will be use for creating polylines on google map.
  Rx<PolylinePoints>? _polylinePoints;

  PolylinePoints? get polylinePoints => _polylinePoints!.value;

// List of coordinates to join

  RxList<LatLng>? _polylineCoordinates = RxList();

  List<LatLng>? get polylineCoordinates => [..._polylineCoordinates!];

// Map storing polylines created by connecting two points
  RxMap<PolylineId, Polyline> polylines = RxMap<PolylineId, Polyline>();

  _createPolylines({
    required double startLatitude,
    required double startLongitude,
    required double destinationLatitude,
    required double destinationLongitude,
  }) async {
    // Initializing PolylinePoints
    _polylinePoints = Rx<PolylinePoints>(PolylinePoints());

    // Generating the list of coordinates to be used for
    // drawing the polylines
    PolylineResult result =
        await _polylinePoints!.value.getRouteBetweenCoordinates(
      "AIzaSyBvOO0sBLjH3B9tylTfTJubczi-HuTHpZ0", // Google Maps API Key
      PointLatLng(startLatitude, startLongitude),
      PointLatLng(destinationLatitude, destinationLongitude),
      // travelMode: TravelMode.,
    );

    // Adding the coordinates to the list
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        _polylineCoordinates!.add(LatLng(point.latitude, point.longitude));
      });
    }

    // Defining an ID
    PolylineId id = const PolylineId('poly');

    // Initializing Polyline
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: _polylineCoordinates!.value,
      width: 3,
    );

    // Adding the polyline to the map
    polylines[id] = polyline;
  }

  Rx<Position>? _userLocation;
  Position? get userLocation => _userLocation!.value;

  @override
  void onInit() async {
    _userLocation = Rx<Position>(await Geolocator.getCurrentPosition());
    _postionsList = Rx<Position>(_userLocation!.value);

    _cameraPosition = Rx<CameraPosition>(
      CameraPosition(
        target: LatLng(
          _userLocation!.value.latitude,
          _userLocation!.value.longitude,
        ),
        zoom: 11.5,
      ),
    );

    //Set markers for origin and destination
    _destinationMarker = Rx<Marker>(
      Marker(
        markerId: const MarkerId('destination'),
        infoWindow: const InfoWindow(title: 'Destination'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        position: _destinationPoint!.value,
      ),
    );
    _originMarker = Rx<Marker>(
      Marker(
        markerId: const MarkerId('Origin'),
        infoWindow: const InfoWindow(title: 'Origin'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        position: _originPoint!.value,
      ),
    );

    //Set polyline for origin and destination point


    await _createPolylines(
      startLatitude: _originPoint!.value.latitude,
      startLongitude: _originPoint!.value.longitude,
      destinationLatitude: _destinationPoint!.value.latitude,
      destinationLongitude: _destinationPoint!.value.longitude,
    );
    WidgetsBinding.instance!.addObserver(this);
    _timer = Rx<Timer>(
      Timer.periodic(
        const Duration(seconds: 1),
        (timer) {
          if (_isActive.value) {
            _counter++;
            debugPrint(_counter.toString());
            _postionsList!.bindStream(Geolocator.getPositionStream());

            _postionsList!.stream.listen((position) {
              _getLiveLocation.add(
                LatLng(position.latitude, position.longitude),
              );

              _originMarker!.value = Marker(
                markerId: const MarkerId('Origin'),
                infoWindow: const InfoWindow(title: 'Origin'),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueGreen),
                position: LatLng(position.latitude, position.longitude),
              );

              _googleMapController!.value.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: LatLng(position.latitude, position.longitude),
                    zoom: 18.0,
                  ),
                ),
              );
              debugPrint(
                  "latitude: ${position.latitude} and longitude: ${position.longitude}");
            });
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
    _postionsList!.close();

    WidgetsBinding.instance!.removeObserver(this);

    super.onClose();
  }
}
