

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';

class Bottle {
  String text,user,city;
  GeoPoint location;

  Bottle(this.text,this.user,this.city, this.location);
}