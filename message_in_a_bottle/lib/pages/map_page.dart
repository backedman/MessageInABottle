import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:message_in_a_bottle/pages/login.dart';
import 'package:message_in_a_bottle/providers/curr_user_location.dart';
import 'package:message_in_a_bottle/utils/global_objects.dart';
import 'package:message_in_a_bottle/popups/message_popup.dart';
import 'package:provider/provider.dart';

class MapPage extends StatefulWidget {
  final User? user;
  const MapPage({super.key, required this.user});
  

  @override
  State<MapPage> createState() => _MapPageState(user);
}

class _MapPageState extends State<MapPage> {
  final User? user;
  late StreamSubscription<Position> _positionStream;
  Position? currentPosition;
  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
  );
  
  _MapPageState(this.user);

  void _initLocationStream() async {
    final bool enabled = await _handleLocationPermission();
    if (!enabled || !mounted) return;

    _positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position? position) {
      if (position != null && mounted) {
        Provider.of<CurrentUserLocationProvider>(context, listen: false)
            .updatePosition(position);
      }
    });
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  @override
  void dispose() {
    _positionStream.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initLocationStream();
  }

  Future<void> logOut() async {
    await FirebaseAuth.instance.signOut();
    if(context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage())
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: LayoutBuilder(
          builder: (context, constraint) => Column(
            children: [
              Center(
                child: Text(
                  "Map",
                  style: TextStyle(
                      fontSize: 0.1 * constraint.biggest.shortestSide),
                  textAlign: TextAlign.start,
                ),
              ),
              Center(
                child: SizedBox(
                  child: RawMaterialButton(
                    fillColor: Colors.blue,
                    elevation: 1.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)
                    ),
                    onPressed: () async {
                      await logOut();
                    },
                    child: const Text(
                      'Log Out',
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              Consumer<CurrentUserLocationProvider>(
                  builder: (context, state, child) {
                currentPosition = state.currentPosition;
                if (currentPosition == null) {
                  return const CircularProgressIndicator();
                } else {
                  return SizedBox(
                    height: constraint.biggest.shortestSide,
                    width: 0.75 * constraint.biggest.shortestSide,
                    child: FlutterMap(
                        options: MapOptions(
                            initialCenter: LatLng(currentPosition!.latitude,
                                currentPosition!.longitude),
                            initialZoom: 18),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          ),
                          CurrentLocationLayer(
                            style: const LocationMarkerStyle(showAccuracyCircle: false),
                            alignPositionOnUpdate: AlignOnUpdate.always,
                          ),
                          CircleLayer(circles: [
                            CircleMarker(
                                useRadiusInMeter: true,
                                point: LatLng(currentPosition!.latitude, currentPosition!.longitude),
                                color: Colors.blue.withOpacity(0.1),
                                borderStrokeWidth: 3.0,
                                borderColor: Colors.blue,
                                radius: 20)
                          ])
                        ]),
                  );
                }
              })
            ],
          ),
        ),
        floatingActionButton: Builder(
          builder: (context) => FloatingActionButton(
            onPressed: () {
              // Create a dummy Bottle object for demonstration
              Bottle bottle = Bottle("Hello from the bottle", "1", "2", GeoPoint(currentPosition!.latitude, currentPosition!.longitude));

            // Show the message popup
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: MessagePopup(bottle: bottle, user: user!.displayName!),
                  ),
                );
              },
            );
          },
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
    )
  );
  }
}
