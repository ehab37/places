import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

import '../models/place.dart';
import '../screens/google_map.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({Key? key, required this.onSelectedPLace})
      : super(key: key);
  final Function(PlaceLocation placeLocation) onSelectedPLace;

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  PlaceLocation? pickedLocation;
  bool isGettingLoction = false;
  final String apiKey = 'AIzaSyCuitt6pe7Cc9wF6zOBtVPUNQKX7JJMF2g';
  String locationImage(double lat, double lng) {
    String url =
        'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=14&size=600x300&maptype=roadmap&markers=color:red%7Clabel:E%7C$lat,$lng&key=$apiKey';
    return url;
  }

  _onSlectMap() async {
    final LatLng? newLatLng = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) {
        return const MyMap(
          isSelecting: true,
        );
      }),
    );
    if (newLatLng == null) {
      return;
    }
    _onSave(newLatLng.latitude, newLatLng.longitude);
  }

  void _onSave(double lat, double lng) async {
    Uri url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$apiKey');
    http.Response res = await http.get(url);
    final resData = jsonDecode(res.body);
    String place = resData['results'][0]['formatted_address'];
    setState(() {
      pickedLocation = PlaceLocation(
        lat: lat,
        lng: lng,
        address: place,
      );

      isGettingLoction = false;
    });
    widget.onSelectedPLace(pickedLocation!);
  }

  void _getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    setState(() {
      isGettingLoction = true;
    });

    locationData = await location.getLocation();
    final lat = locationData.latitude;
    final lng = locationData.longitude;
    if (lat == null || lng == null) {
      return;
    }
    _onSave(lat, lng);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Text(
      'No Added Places',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Theme.of(context).colorScheme.onBackground,
      ),
    );
    if (pickedLocation != null) {
      content = Image.network(
        locationImage(pickedLocation!.lat, pickedLocation!.lng),
        alignment: AlignmentDirectional.center,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }
    if (isGettingLoction) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          height: 250,
          width: double.infinity,
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Theme.of(context).colorScheme.primary.withOpacity(.2),
          ),
          child: content,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: _getCurrentLocation,
              icon: const Icon(Icons.location_on_outlined),
              label: const Text('Gey Current Location'),
            ),
            TextButton.icon(
              onPressed: _onSlectMap,
              icon: const Icon(Icons.map_outlined),
              label: const Text('Select on map'),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
