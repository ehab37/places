import 'package:flutter/material.dart';
import 'package:places/models/place.dart';
import 'package:places/screens/google_map.dart';

class PlacesDetails extends StatelessWidget {
  const PlacesDetails({Key? key, required this.place}) : super(key: key);
  final Place place;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(place.title),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            children: [
              Image.file(place.image),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) {
                            return MyMap(placeLocation: place.placeLocation);
                          }),
                        );
                      },
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(
                            'https://maps.googleapis.com/maps/api/staticmap?center=${place.placeLocation.lat},${place.placeLocation.lng}&zoom=19&size=600x300&maptype=roadmap&markers=color:red%7Clabel:E%7C${place.placeLocation.lat},${place.placeLocation.lng}&key=AIzaSyCuitt6pe7Cc9wF6zOBtVPUNQKX7JJMF2g'),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 50,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Colors.black54,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          place.placeLocation.address,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
