import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong/latlong.dart';

class Locations {
  String currentView = "You";
  Location missingPersonLoc;
  Position yourPos;
}

class PopUpMap extends StatelessWidget {
  final MapController _mapController = MapController();
  final Locations _locations = Locations();

  final String city;
  final String province;
  final String url;

  PopUpMap(this.city, this.province, this.url);

  Future _getMissingPersonLatLng() async {
    List<Location> locations;

    try {
      locations = await locationFromAddress(
          "$city, ${province != '--' ? province : ''}");
    } catch (e) {
      print(e);
    }

    return locations;
  }

  void _moveView() {
    double curZoom = _mapController.zoom;
    LatLng newCenter;

    if (_locations.currentView == "You") {
      _locations.currentView = "Them";
      newCenter = LatLng(
        _locations.missingPersonLoc.latitude,
        _locations.missingPersonLoc.longitude,
      );
    } else {
      _locations.currentView = "You";
      newCenter = LatLng(
        _locations.yourPos.latitude,
        _locations.yourPos.longitude,
      );
    }

    _mapController.move(newCenter, curZoom);
  }

  // --------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Map"),
      content: _futureMap(),
      actions: [
        _nextBtn(),
        _exitBtn(),
      ],
    );
  }

  Widget _nextBtn() => ElevatedButton(
        onPressed: () => _moveView(),
        child: Text("Next"),
      );

  Widget _exitBtn() => Builder(
        builder: (context) => ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Exit"),
        ),
      );

  // --------------------------------------------------------------

  Widget _futureMap() {
    Future<Position> position =
        Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    return FutureBuilder(
      future: position,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _locations.yourPos = snapshot.data;
          return _futureMissingPersonLatLng();
        } else {
          return _loadingStatus(snapshot.connectionState);
        }
      },
    );
  }

  Widget _futureMissingPersonLatLng() => FutureBuilder(
        future: _getMissingPersonLatLng(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _locations.missingPersonLoc = snapshot.data[0];
            return _mapCotainer();
          } else {
            return _loadingStatus(snapshot.connectionState);
          }
        },
      );

  // --------------------------------------------------------------

  Widget _loadingStatus(ConnectionState connectionState) {
    if (connectionState == ConnectionState.waiting)
      return _loadingIcon();
    else
      return Text("Location was not found");
  }

  Widget _loadingIcon() => Center(child: CircularProgressIndicator());

  // --------------------------------------------------------------

  Widget _mapCotainer() => Container(
        width: double.maxFinite,
        child: _mapBox(),
      );

  Widget _mapBox() => FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          minZoom: 10.0,
          center:
              LatLng(_locations.yourPos.latitude, _locations.yourPos.longitude),
        ),
        layers: [
          _openMapLayer(),
          _markerLayer(),
          _polyLineLayer(),
        ],
      );

  // --------------------------------------------------------------

  TileLayerOptions _openMapLayer() => TileLayerOptions(
        urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
        subdomains: ['a', 'b', 'c'],
      );

  MarkerLayerOptions _markerLayer() {
    int distanceInMeters = Geolocator.distanceBetween(
          _locations.yourPos.latitude,
          _locations.yourPos.longitude,
          _locations.missingPersonLoc.latitude,
          _locations.missingPersonLoc.longitude,
        ) ~/
        1000.0;
    return MarkerLayerOptions(markers: [
      _yourLocMarker(),
      _missingPersonMarker(distanceInMeters),
    ]);
  }

  PolylineLayerOptions _polyLineLayer() => PolylineLayerOptions(polylines: [
        _lineBetweenYouAndMissingPerson(),
      ]);

  // --------------------------------------------------------------

  Marker _yourLocMarker() => Marker(
        width: 80,
        height: 80,
        point:
            LatLng(_locations.yourPos.latitude, _locations.yourPos.longitude),
        builder: (context) => Icon(
          Icons.home,
          color: Colors.brown,
          size: 80,
        ),
      );

  Marker _missingPersonMarker(int distanceInMeters) => Marker(
      width: 200,
      height: 200,
      point: LatLng(_locations.missingPersonLoc.latitude,
          _locations.missingPersonLoc.longitude),
      builder: (context) => Column(
            children: [
              _missingPersonDistance(distanceInMeters),
              _missingPersonAvatar(),
            ],
          ));

  Widget _missingPersonDistance(int distanceInMeters) => Flexible(
          child: Text(
        "$distanceInMeters KM",
        style: TextStyle(
          color: Colors.white,
          backgroundColor: Colors.brown,
        ),
      ));

  Widget _missingPersonAvatar() => Flexible(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: Image.network(url,
              fit: BoxFit.fill,
              errorBuilder: (_, __, ___) => Icon(
                    Icons.person,
                    color: Colors.brown,
                    size: 80,
                  )),
        ),
      );

  // --------------------------------------------------------------

  Polyline _lineBetweenYouAndMissingPerson() => Polyline(
        points: [
          LatLng(_locations.yourPos.latitude, _locations.yourPos.longitude),
          LatLng(_locations.missingPersonLoc.latitude,
              _locations.missingPersonLoc.longitude),
        ],
        isDotted: true,
        color: Colors.red,
        strokeWidth: 10,
      );
}
