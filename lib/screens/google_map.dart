import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/place.dart';

class MyMap extends StatefulWidget {
  const MyMap({
    Key? key,
    this.placeLocation =
        const PlaceLocation(lat: 40.156, lng: 32.515, address: 'address'),
    this.isSelecting = false,
  }) : super(key: key);
  final PlaceLocation placeLocation;
  final bool isSelecting;

  @override
  State<MyMap> createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  LatLng? latLng;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          if (widget.isSelecting)
            GestureDetector(
                onTap: () {
                  Navigator.of(context).pop<LatLng>(latLng);
                },
                child: const Icon(Icons.save_outlined))
        ],
        title: Text(widget.isSelecting ? 'Pick Location' : 'Your Location'),
      ),
      body: GoogleMap(
        onTap: (argument) {
          if (widget.isSelecting) {
            setState(() {
              latLng = argument;
            });
          }
        },
        initialCameraPosition: CameraPosition(
          zoom: 12,
          target: LatLng(
            widget.placeLocation.lat,
            widget.placeLocation.lng,
          ),
        ),
        markers: {
          Marker(
            markerId: const MarkerId('x1'),
            position: latLng ??
                LatLng(
                  widget.placeLocation.lat,
                  widget.placeLocation.lng,
                ),
          ),
        },
      ),
    );
  }
}
