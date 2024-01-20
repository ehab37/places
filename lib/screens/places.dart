import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:places/models/place.dart';
import 'package:places/providers/user_places.dart';
import 'package:places/screens/add_place.dart';
import 'package:places/widgets/places_list.dart';

class Places extends ConsumerStatefulWidget {
  const Places({Key? key}) : super(key: key);

  @override
  ConsumerState<Places> createState() => _PlacesState();
}

class _PlacesState extends ConsumerState<Places> {
  late Future<void> _placesFuture;
  @override
  void initState() {
    super.initState();
    _placesFuture = ref.read(userPlacesProvider.notifier).loadPlaces();
  }

  @override
  Widget build(BuildContext context) {
    final List<Place> places = ref.watch(userPlacesProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Places'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const AddPlace();
                  },
                ),
              );
            },
            icon: const Icon(
              Icons.add,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: _placesFuture,
          builder: (context, snapshot) {
            return PlacesList(
              places: places,
            );
          },
        ),
      ),
    );
  }
}
