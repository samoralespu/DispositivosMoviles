import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Set<Marker> _makers = {};
  Future<Position> positionMap = Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

  /*void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _makers.add(
        Marker(
          markerId: MarkerId('id_1'),
          position: LatLng(22.5448131, 88.3403691)
        )
      );
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: positionMap,
      builder: (BuildContext context, AsyncSnapshot<Position> snapshot) {
        if(snapshot.hasData){
          final pos = snapshot.data;
          return Scaffold(
            body: GoogleMap(
              //onMapCreated: _onMapCreated,
              myLocationEnabled: true,
              initialCameraPosition: CameraPosition(
                target: LatLng(snapshot.data!.latitude, snapshot.data!.longitude),
                zoom: 15,
              )
              )
          );
        } else {
          return Center(child: Text('data'),);
        }
      }
    );
  }
}