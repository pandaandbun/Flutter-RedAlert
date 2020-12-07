// import 'dart:async';

// import 'package:Red_Alert/Database/missing_person_database.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart' as geo;
// import 'package:google_api_availability/google_api_availability.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// //import 'package:location/location.dart';
// import 'package:geocoding/geocoding.dart';

// import '../settings_btn.dart';
// import '../drawer.dart';

// class MapView extends StatefulWidget {
//   @override
//   _MapViewState createState() => _MapViewState();
// }

// class _MapViewState extends State<MapView> {
//   //Location location = new Location();
//   bool _serviceEnabled;
//   //PermissionStatus _permissionGranted;
//   //LocationData _locationData;
//   Set<Marker> _markers = {};
//   int mid = 1;
//   BitmapDescriptor pinLocationIcon;
//   Completer<GoogleMapController> _controller = Completer();
//   //final coordinates = new Coordinates(1.10, 45.50);
//   var _geolocator = geo.Geolocator();
//   Person person;
//   MissingPeopleModel missingPeople = MissingPeopleModel();
//   Stream stream;

//   @override
//   void initState() {
//     super.initState();
//     //_checkLocationPermission();
//     //_locationData = _locationData;
//     stream = missingPeople.getCityProvince();
//   }

//   void setCustomMapPin() async {
//     pinLocationIcon = await BitmapDescriptor.fromAssetImage(
//         ImageConfiguration(devicePixelRatio: 2.5),
//         'assets/destination_map_marker.png');
//   }

// /*
//   // Check Location Permissions, and get my location
//   void _checkLocationPermission() async {
//     _serviceEnabled = await location.serviceEnabled();
//     if (!_serviceEnabled) {
//       _serviceEnabled = await location.requestService();
//       if (!_serviceEnabled) {
//         return;
//       }
//     }
//     _permissionGranted = await location.hasPermission();
//     if (_permissionGranted == PermissionStatus.denied) {
//       _permissionGranted = await location.requestPermission();
//       if (_permissionGranted != PermissionStatus.granted) {
//         return;
//       }
//     }
//     _locationData = await location.getLocation();
//   }
// */

//   Person _buildPerson(DocumentSnapshot data) {
//     return Person.fromMap(data.data(), reference: data.reference);
//   }

//   void _setMarker() {
//     stream.listen(
//       (element) {
//         element.documents.forEach((snapshot) {
//           Person p = _buildPerson(snapshot);
//           String city = p.city;
//           String prov = p.province;
//           String ady = '$city, $prov';
//           print('LOOOOOOOOOOOL $ady');
//           _geolocator
//               .placemarkFromAddress(ady)
//               .then((List<geo.Placemark> places) {
//             print('Forward geocoding results:');
//             print('LOOOOOOOOOOOL $ady');
//             for (geo.Placemark place in places) {
//               if (place.position.latitude != null &&
//                   place.position.longitude != null) {
//                 setState(() {
//                   _markers.add(
//                     Marker(
//                       markerId: MarkerId('Marker Id: $mid'),
//                       position: LatLng(
//                           place.position.latitude, place.position.longitude),
//                       icon: pinLocationIcon,
//                     ),
//                   );
//                   mid++;
//                 });
//               }
//             }
//           }).catchError((ignored) {});
//         });
//       },
//     );
//   }

//   static final CameraPosition _kGooglePlex = CameraPosition(
//     target: LatLng(43.642565, -79.3870567),
//     zoom: 14.4746,
//   );

//   Future<bool> _isGoogleAvailable() async {
//     GooglePlayServicesAvailability google = await GoogleApiAvailability.instance
//         .checkGooglePlayServicesAvailability();
//     String status = google.toString().split('.').last;

//     return status != "serviceInvalid";
//   }

//   @override
//   Widget build(BuildContext context) {
//     Future<bool> gooleAvailable = _isGoogleAvailable();

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Map'),
//         actions: [SettingsBtn()],
//       ),
//       drawer: DrawerMenu(),
//       body: futureMap(gooleAvailable),
//     );
//   }

//   Widget futureMap(Future<bool> gooleAvailable) => FutureBuilder(
//       future: gooleAvailable,
//       builder: (context, snapshot) {
//         if (snapshot.hasData) {
//           if (snapshot.data) {
//             return googleMap();
//           } else {
//             return Text("Device has no Google API");
//           }
//         } else {
//           return Text("Checking for Google API");
//         }
//       });

//   Widget googleMap() => GoogleMap(
//       mapType: MapType.hybrid,
//       markers: _markers,
//       initialCameraPosition: _kGooglePlex,
//       onMapCreated: (GoogleMapController controller) {
//         _controller.complete(controller);
//         _setMarker();
//       });
// }
