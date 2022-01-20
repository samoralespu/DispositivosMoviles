import 'dart:async';
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:convert' as convert;

import 'package:reto9/model/place.dart';


class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Future<Position> positionMap = Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  double _currentSliderValue = 50;

  @override
  Widget build(BuildContext context) { 
    return FutureBuilder(
      future: positionMap,
      builder: (BuildContext context, AsyncSnapshot<Position> snapshot) {
        if(snapshot.hasData){
          final Marker marker = Marker(
            markerId: MarkerId("position"),
            position: LatLng(snapshot.data!.latitude, snapshot.data!.longitude),
            infoWindow: InfoWindow(title: "position", snippet: '*'),
            onTap: () {},
          );
          final pos = snapshot.data;
          return Scaffold(
            body: Stack(
              children: [
                GoogleMap(
                  onMapCreated: (controller) {
                    _getInterestPoints(LatLng(snapshot.data!.latitude, snapshot.data!.longitude), _currentSliderValue);
                  },
                  myLocationEnabled: true,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(snapshot.data!.latitude, snapshot.data!.longitude),
                    zoom: 15,
                  ),
                  markers: Set<Marker>.of(markers.values),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Slider(
                          value: _currentSliderValue,
                          max: 1000,
                          divisions: 50,
                          min: 50,
                          label: _currentSliderValue.round().toString(),
                          onChanged: (double value) {
                            setState(() {
                              _currentSliderValue = value;
                              _getInterestPoints(LatLng(snapshot.data!.latitude, snapshot.data!.longitude), _currentSliderValue);
                            });
                          },
                        ),
                        SizedBox(width: 40,),
                      ],
                    ),
                    SizedBox(height: 40,),
                  ],
                ),
              ],
            )
          );
        } else {
          return Center(child: Text('data'),);
        }
      }
    );
  }

  void _getInterestPoints(LatLng position, double distance) async {
    markers.clear();
    Response response = await get(Uri.parse('https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${position.latitude},${position.longitude}&type=point_of_interest&radius=$distance&key=AIzaSyCLPzcowGX9fNUwswNvG00was83MzfOeEQ'));
    Map data = jsonDecode(response.body);
    List results = (data["results"]);
    for (dynamic place in results) {
      print(place);
      final Marker marker = Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueViolet
        ),
        markerId: MarkerId(place['name']),
        position: LatLng(place['geometry']['location']['lat'],
            place['geometry']['location']['lng']),
        infoWindow: InfoWindow(title: place['name'], onTap: () {
        }),
        onTap: () {},
      );
      markers[MarkerId(place['name'])] = marker;
    }
    setState(() {});
  }
}