
import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

class Bottle extends Equatable{
  final String text,user,city;
  final LatLng location;

  Bottle(this.text,this.user,this.city, this.location);
  
  @override
  List<Object?> get props => [text, user, city, location];
}