import 'package:flutter/material.dart';
import 'package:places/models/place.dart';
import 'package:places/screens/places_details.dart';

class PlacesList extends StatelessWidget {
  const PlacesList({Key? key, required this.places}) : super(key: key);
  final List<Place> places;

  @override
  Widget build(BuildContext context) {
    if (places.isEmpty) {
      return Center(
        child: Text(
          'No Places Yet',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontSize: 25,
                color: Theme.of(context).colorScheme.onBackground,
              ),
        ),
      );
    }
    return ListView.builder(
      itemCount: places.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            radius: 22,
            backgroundImage: FileImage(
              places[index].image,
            ),
          ),
          title: Text(
            places[index].title,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
          ),
          subtitle: Text(
            places[index].placeLocation.address,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return PlacesDetails(
                    place: places[index],
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
