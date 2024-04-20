import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class CurrentUserLocationProvider extends ChangeNotifier {
  Position? _currentPosition;
  double closestBottleDistance = double.infinity;

  Position? get currentPosition => _currentPosition;

  void updatePosition(Position newPosition) {
    _currentPosition = newPosition;
    notifyListeners();
  }
}
