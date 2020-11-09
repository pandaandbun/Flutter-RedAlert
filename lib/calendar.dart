import 'package:flutter/material.dart';
import 'package:location/location.dart';

class Calendar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Icon(Icons.calendar_today_outlined),
      onTap: () async {
        //BASE CODY FROM PACKAGE FOR NOW
        Location location = new Location();

        bool _serviceEnabled;
        PermissionStatus _permissionGranted;
        LocationData _locationData;

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
        print(_locationData);
      },
    );
  }
}
