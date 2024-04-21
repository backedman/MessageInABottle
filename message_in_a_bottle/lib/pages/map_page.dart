import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:message_in_a_bottle/models/bottle.dart';
import 'package:message_in_a_bottle/providers/bottle_locations_provider.dart';
import 'package:message_in_a_bottle/pages/login.dart';
import 'package:message_in_a_bottle/providers/curr_user_location.dart';
import 'package:message_in_a_bottle/popups/message_popup.dart';
import 'package:message_in_a_bottle/utils/database_operations.dart';
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
  GeoPoint? _lastBottlePlacementPosition;
  List<Bottle> held_bottles = [];

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

        _lastBottlePlacementPosition ??= GeoPoint(position.latitude, position.longitude);
        
        
        // Check if the distance moved since the last bottle placement is greater than the threshold
        double distanceMoved = Geolocator.distanceBetween(
          _lastBottlePlacementPosition!.latitude,
          _lastBottlePlacementPosition!.longitude,
          position.latitude,
          position.longitude,
        );

        var rand = Random();

        if (rand.nextDouble() < 0.3) {
          if (held_bottles.isNotEmpty) {
            var bottle = held_bottles.removeLast();

            GeoPoint location =
                GeoPoint(position.latitude, position.longitude);

            writeBottle(bottle.user, bottle.text, bottle.city, location);
            
            print("BOTTLE PLACED");
          }

        }
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
    if (context.mounted) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const LoginPage()));
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
                style:
                    TextStyle(fontSize: 0.1 * constraint.biggest.shortestSide),
                textAlign: TextAlign.start,
              ),
            ),
            Center(
              child: SizedBox(
                child: RawMaterialButton(
                  fillColor: Colors.blue,
                  elevation: 1.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
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
            Consumer2<CurrentUserLocationProvider, BottleLocationsProvider>(
                builder: (context, state, locState, child) {
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
                          initialZoom: 18),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        ),
                        CurrentLocationLayer(
                          style: const LocationMarkerStyle(
                              showAccuracyCircle: false),
                          alignPositionOnUpdate: AlignOnUpdate.always,
                        ),
                        MarkerLayer(
                            markers: locState.bottles
                                .map(
                                  (bottle) => Marker(
                                      point: bottle.$2.location,
                                      child: GestureDetector(
                                        child: 
                                            Image.asset('assets/message_in_a_bottle.png'),
                                        onTap: () {
                                          if (Geolocator.distanceBetween(
                                                  currentPosition.latitude,
                                                  currentPosition.longitude,
                                                  bottle.$2.location.latitude,
                                                  bottle.$2.location.longitude) <=
                                              25) {

                                            //remove bottle from database
                                            deleteBottle(bottle.$1);

                                            //add bottle to local storage
                                            held_bottles.add(bottle.$2);

                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Center(
                                                  child: SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.8,
                                                    child: MessagePopup(
                                                        bottle: bottle.$2,
                                                        user:
                                                            user!.displayName!),
                                                  ),
                                                );
                                              },
                                            );
                                          }
                                        },
                                      )),
                                )
                                .toList()),
                        CircleLayer(circles: [
                          CircleMarker(
                              useRadiusInMeter: true,
                              point: LatLng(currentPosition.latitude,
                                  currentPosition.longitude),
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
    );
  }
}