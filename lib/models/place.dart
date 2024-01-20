import 'dart:io';

import 'package:uuid/uuid.dart';

const Uuid uuid = Uuid();

class PlaceLocation {
  final double lat;
  final double lng;
  final String address;

  const PlaceLocation({
    required this.lat,
    required this.lng,
    required this.address,
  });
}

class Place {
  final File image;
  final String title;
  final String id;
  final PlaceLocation placeLocation;

  Place({
    String? id,
    required this.placeLocation,
    required this.image,
    required this.title,
  }) : id = id ?? uuid.v4();
}
