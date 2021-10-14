import 'dart:async';

import 'package:dio/dio.dart' as d;
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeController extends GetxController with WidgetsBindingObserver {
  final RxBool _isActive = true.obs;

  bool get isActive => _isActive.value;

  RxInt _counter = 0.obs;

  int get counter => _counter.value;

  //List for binding stream of geo locator live position
  Rx<Position>? _positionStream;

  Position? get positionStream =>
      _positionStream != null ? _positionStream!.value : null;

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

  Rx<Marker>? _userMarker;

  Marker? get userMarker => _userMarker != null ? _userMarker!.value : null;

  //Destination Marker
  Rx<Marker>? _destinationMarker;

  Marker? get destinationMarker =>
      _destinationMarker != null ? _destinationMarker!.value : null;

  late RxInt mapId = 0.obs;

  //On Map Created
  onMapCreated(controller) {
    _googleMapController = Rx<GoogleMapController>(controller);
    mapId.value = _googleMapController!.value.mapId;
  }

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
      Rx<LatLng>(const LatLng(25.030989786888426, 67.30743816272722));
  final Rx<LatLng>? _originPoint =
      Rx<LatLng>(const LatLng(24.85871738270853, 67.06132739779827));

  LatLng get destinationPoint => _destinationPoint!.value;

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
      optimizeWaypoints: true,
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
      color: Colors.deepPurple,
      points: _polylineCoordinates!.value,
      width: 3,
    );

    // Adding the polyline to the map
    polylines[id] = polyline;
  }

  Rx<Position>? _userLocation;

  Position? get userLocation => _userLocation!.value;

  //Get Custom Icon Work
  Rx<BitmapDescriptor>? _userMarkerIcon;

  BitmapDescriptor? get userMarkerIcon => _userMarkerIcon!.value;

  getIcons() async {
    var icon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(
        devicePixelRatio: 20,
        size: Size(25, 25),
      ),
      "assets/images/user_pin.png",
    );

    return icon;
  }

  //Distance Calculation for a trip

  final RxString? _totalDistance = "0 mi".obs;

  String get totalDistance => _totalDistance!.value;

  final RxString? _tripTotalTime = "0 mins".obs;

  String? get tripTotalTime => _tripTotalTime!.value;

  final RxString? _originAddress = "Origin Address".obs;

  String? get originAddress => _originAddress!.value;
  final RxString? _destinationAddress = "Destination Address".obs;

  String? get destinationAddress => _destinationAddress!.value;

  @override
  void onInit() async {
    _userLocation = Rx<Position>(await Geolocator.getCurrentPosition());
    _positionStream = Rx<Position>(_userLocation!.value);

    _cameraPosition = Rx<CameraPosition>(
      CameraPosition(
        target: LatLng(
          _userLocation!.value.latitude,
          _userLocation!.value.longitude,
        ),
        zoom: 15.0,
      ),
    );

    //Get custom icon for marker of user
    var icon = await getIcons();

    _userMarkerIcon = Rx<BitmapDescriptor>(icon);

    //Set markers for origin and destination
    _destinationMarker = Rx<Marker>(
      Marker(
        markerId: const MarkerId('destination'),
        infoWindow: const InfoWindow(title: 'Destination'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
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

    _userMarker = Rx<Marker>(
      Marker(
        markerId: const MarkerId('User'),
        infoWindow: const InfoWindow(title: 'User'),
        icon: _userMarkerIcon!.value,
        position: LatLng(
          _positionStream!.value.latitude,
          _positionStream!.value.longitude,
        ),
      ),
    );

    //Set polyline for origin and destination point

    await _createPolylines(
      startLatitude: _originPoint!.value.latitude,
      startLongitude: _originPoint!.value.longitude,
      destinationLatitude: _destinationPoint!.value.latitude,
      destinationLongitude: _destinationPoint!.value.longitude,
    );

    // await getTotalTimeDuration(
    //   startLatitude: _userLocation!.value.latitude,
    //   startLongitude: _userLocation!.value.longitude,
    //   destinationLatitude: _destinationPoint!.value.latitude,
    //   destinationLongitude: _destinationPoint!.value.longitude,
    // );

    if (_isActive.value) {
      // _counter++;
      _positionStream!.bindStream(Geolocator.getPositionStream());

      _positionStream!.stream.listen((position) async {
        //_userMarker

        var icon = await getIcons();

        if (_userMarkerIcon != null) {
          _userMarker!.value = Marker(
            markerId: const MarkerId('User'),
            infoWindow: const InfoWindow(title: 'User'),
            icon: icon,
            position: LatLng(
              _positionStream!.value.latitude,
              _positionStream!.value.longitude,
            ),
          );
        }

        _cameraPosition!.value = CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 15.0,
        );

        _googleMapController!.value.animateCamera(
          CameraUpdate.newCameraPosition(_cameraPosition!.value),
        );

        debugPrint("value of latitude is: ${position.latitude}");

        //To get live update of trip duration and destination use api again and again
        // await getTotalTimeDuration(
        //   startLatitude: position.latitude,
        //   startLongitude: position.longitude,
        //   destinationLatitude: _destinationPoint!.value.latitude,
        //   destinationLongitude: _destinationPoint!.value.longitude,
        // );
      }, onError: (error) {
        Get.snackbar("Error", error.toString());
      });
    }
    WidgetsBinding.instance!.addObserver(this);

    super.onInit();
  }

  Future getTotalTimeDuration({
    required double startLatitude,
    required double startLongitude,
    required double destinationLatitude,
    required double destinationLongitude,
  }) async {
    d.Dio dio = d.Dio();
    d.Response response = await dio.get(
        "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=$startLatitude,$startLongitude&destinations=$destinationLatitude,$destinationLongitude&mode=driving&key=AIzaSyBvOO0sBLjH3B9tylTfTJubczi-HuTHpZ0");
    Map<String, dynamic> data = response.data;
    _destinationAddress!.value = data['destination_addresses'][0];
    _originAddress!.value = data['origin_addresses'][0];
    _totalDistance!.value = data['rows'][0]['elements'][0]['distance']['text'];
    _tripTotalTime!.value = data['rows'][0]['elements'][0]['duration']['text'];
  }

  @override
  void onClose() {
    _positionStream!.close();
    _googleMapController!.value.dispose();
    WidgetsBinding.instance!.removeObserver(this);

    super.onClose();
  }
}
