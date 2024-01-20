import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:places/models/place.dart';
import 'package:places/providers/user_places.dart';
import 'package:places/widgets/image_input.dart';
import 'package:places/widgets/location_input.dart';

class AddPlace extends ConsumerStatefulWidget {
  const AddPlace({Key? key}) : super(key: key);

  @override
  ConsumerState<AddPlace> createState() => _AddPlaceState();
}

class _AddPlaceState extends ConsumerState<AddPlace> {
  File? _image;
  PlaceLocation? _placeLocation;
  final TextEditingController titleController = TextEditingController();
  void _savePlace() {
    final String enteredTitle = titleController.text;
    if (enteredTitle.isEmpty || _image == null) {
      return;
    }
    ref.read(userPlacesProvider.notifier).addPlace(
          enteredTitle,
          _image!,
          _placeLocation!,
        );
    Navigator.pop(context);
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new place'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 20,
                ),
                decoration: const InputDecoration(
                  labelText: 'title',
                ),
                controller: titleController,
              ),
              ImageInput(
                onSelectedImage: (File image) {
                  _image = image;
                },
              ),
              LocationInput(
                onSelectedPLace: (placeLocation) {
                  _placeLocation = placeLocation;
                },
              ),
              ElevatedButton.icon(
                onPressed: _savePlace,
                icon: const Icon(Icons.add),
                label: const Text('Add place'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
