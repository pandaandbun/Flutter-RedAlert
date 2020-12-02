import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_api_availability/google_api_availability.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../settings_btn.dart';
import '../drawer.dart';

class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  Location location = new Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  // Check Location Permissions, and get my location
  void _checkLocationPermission() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    _locationData = await location.getLocation();
  }

  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(43.642565, -79.3870567),
    zoom: 15,
  );

  Future<bool> _isGoogleAvailable() async {
    GooglePlayServicesAvailability google = await GoogleApiAvailability.instance
        .checkGooglePlayServicesAvailability();
    String status = google.toString().split('.').last;

    return status != "serviceInvalid";
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> gooleAvailable = _isGoogleAvailable();

    return Scaffold(
      appBar: AppBar(
        title: Text('Map'),
        actions: [SettingsBtn()],
      ),
      drawer: DrawerMenu(),
      body: futureMap(gooleAvailable),
    );
  }

  Widget futureMap(Future<bool> gooleAvailable) => FutureBuilder(
      future: gooleAvailable,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data) {
            return googleMap();
          } else {
            return Text("Device has no Google API");
          }
        } else {
          return Text("Checking for Google API");
        }
      });

  Widget googleMap() => GoogleMap(
      mapType: MapType.hybrid,
      initialCameraPosition: _kGooglePlex,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      });
}
