import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';

class Place{
  final String name;
  final int userRatingCount;
  final String vicinity;
  final Geometry geometry;

  Place({required this.geometry,required this.name,required this.userRatingCount,required this.vicinity});

  Place.fromJson(Map<dynamic, dynamic> parsedJson)
    :name = parsedJson['name'],
    userRatingCount = (parsedJson['user_ratings_total'] != null) ? parsedJson['user_ratings_total'] : 0,
    vicinity = parsedJson['vicinity'],
    geometry = Geometry.fromJson(parsedJson['geometry']);
}