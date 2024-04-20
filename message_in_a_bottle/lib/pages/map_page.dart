import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:message_in_a_bottle/providers/curr_user_location.dart';
import 'package:message_in_a_bottle/utils/global_objects.dart';
import 'package:message_in_a_bottle/popups/message_popup.dart';
import 'package:provider/provider.dart';

class MapPage extends StatefulWidget {
  final User? user;
  const MapPage({super.key, required this.user});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late StreamSubscription<Position> _positionStream;
  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
  );

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
                Consumer<CurrentUserLocationProvider>(
                    builder: (context, state, child) {
                  Position? currentPosition = state.currentPosition;
                  if (currentPosition == null) {
                    return const CircularProgressIndicator();
                  } else {
                    return SizedBox(
                      height: constraint.biggest.shortestSide,
                      width: 0.75 * constraint.biggest.shortestSide,
                      child: FlutterMap(
                          options: MapOptions(
                              initialCenter: LatLng(currentPosition.latitude,
                                  currentPosition.longitude),
                              initialZoom: 19),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            ),
                            CurrentLocationLayer(
                              alignPositionOnUpdate: AlignOnUpdate.always,
                            ),
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
            Bottle bottle = Bottle("Hello from the bottle", "1", "2");

            // Show the message popup
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: MessagePopup(bottle: bottle),
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
