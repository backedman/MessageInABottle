import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';
import 'package:message_in_a_bottle/models/bottle.dart';

class BottleLocationsProvider extends ChangeNotifier {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  List<Bottle> bottles = [];

  BottleLocationsProvider() {
    init();
  }

  Future<void> init() async {
    await getBottlesFromDatabase();
    notifyListeners();
  }

  Future<void> getBottlesFromDatabase() async {
    final bottlesCollection = db.collection('bottles');
    bottlesCollection.get().then((QuerySnapshot querySnapshot) {
      for (var bottle in querySnapshot.docs) {
        GeoPoint location = bottle['location'];
        bottles.add(Bottle(bottle['message'], bottle['user'], bottle['city'],
            LatLng(location.latitude, location.longitude)));
      }
    });
  }
}
