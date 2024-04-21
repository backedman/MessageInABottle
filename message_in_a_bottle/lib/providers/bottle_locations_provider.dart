import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';
import 'package:message_in_a_bottle/models/bottle.dart';

class Pair<T1, T2> {
  final T1 a;
  final T2 b;

  Pair(this.a, this.b);
}


class BottleLocationsProvider extends ChangeNotifier {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  List<Pair<String, Bottle>> bottles = [];

  // BottleLocationsProvider() {
  //   init();
  // }

  Future<void> init() async {
    await getBottlesFromDatabase();
    notifyListeners();
  }

  Future<void> getBottlesFromDatabase() async {
    final bottlesCollection = db.collection('bottles');
    bottlesCollection.get().then((QuerySnapshot querySnapshot) {
      for (var bottle in querySnapshot.docs) {
        GeoPoint location = bottle['location'];
        // Use a Map to store key-value pairs for bottle data
        Pair<String, Bottle> bottleData = (
            bottle.id,
            Bottle(
              bottle['message'],
              bottle['user'],
              bottle['city'],
              LatLng(location.latitude, location.longitude),
            )
        ) as Pair<String, Bottle>;
        bottles.add(bottleData);
      }
    });
  }

  Future<void> removeBottle(Bottle bottle) async {
    Bottle? botToRemove;
    for (Bottle bot in bottles) {
      if (bot == bottle) {
        print("Bottle to remove: ${bot.text}");

        botToRemove = bot;
      }
    }
    if (botToRemove != null) bottles.remove(botToRemove);
  }
}
