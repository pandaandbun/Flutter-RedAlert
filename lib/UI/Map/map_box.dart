import 'package:Red_Alert/UI/Map/map_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';

class MapBox extends StatelessWidget {
  final List people;
  final MapController _mapController;

  MapBox(this.people, this._mapController);

  Future _missingPeopleDialog(BuildContext scaffoldContext) async =>
      await showDialog(
          context: scaffoldContext,
          builder: (_) {
            return MapDialog(people);
          });

  // --------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    Future<Position> position =
        Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    return FutureBuilder(
      future: position,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _mapBox(snapshot.data, context);
        } else {
          return _loadingIcon();
        }
      },
    );
  }

  // --------------------------------------------------------------

  Widget _loadingIcon() => Center(child: CircularProgressIndicator());

  Widget _mapBox(Position loc, BuildContext scaffoldContext) => FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          minZoom: 10.0,
          center: LatLng(loc.latitude, loc.longitude),
          // onTap: (e) => print(e),
        ),
        layers: [
          TileLayerOptions(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayerOptions(
              markers: [_cityMarkerHandler(loc, scaffoldContext)]),
        ],
        children: [
          RaisedButton(child: Icon(Icons.add), onPressed: () => print("value"))
        ],
      );

  Marker _cityMarkerHandler(Position loc, BuildContext scaffoldContext) =>
      people.isNotEmpty
          ? _cityMissingPeopleMarker(loc, scaffoldContext)
          : Marker();

  Marker _cityMissingPeopleMarker(Position loc, BuildContext scaffoldContext) =>
      Marker(
          width: 80,
          height: 80,
          point: LatLng(loc.latitude, loc.longitude),
          builder: (context) => IconButton(
                icon: Icon(
                  Icons.people,
                  color: Colors.brown,
                ),
                onPressed: () => _missingPeopleDialog(scaffoldContext),
                iconSize: 80,
              ));

  // Marker _yourLocationMarker(Position e) => Marker(
  //       point: LatLng(e.latitude, e.longitude),
  //       builder: (context) => Icon(
  //         Icons.home,
  //         color: Colors.brown,
  //         size: 80,
  //       ),
  //     );

  // List<Marker> _missingPeopleMarkers(Position yourLocation) => people
  //     .map((e) => Marker(
  //           point: LatLng(yourLocation.latitude, yourLocation.longitude),
  //           builder: (context) => Icon(
  //             Icons.person,
  //             color: Colors.red,
  //             size: 80,
  //             semanticLabel: e['firstName'],
  //           ),
  //         ))
  //     .toList()
  //     .cast<Marker>();
}
