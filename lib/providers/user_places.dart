import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:places/models/place.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as sys;
import 'package:sqflite/sqflite.dart' as sql;

Future<sql.Database> _getDataBase() async {
  final dbPath = await sql.getDatabasesPath();
  final String newPath = path.join(dbPath, 'place.db');
  final sql.Database db = await sql.openDatabase(
    newPath,
    version: 1,
    onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE user_places (id TEXT PRIMARY KEY, title TEXT, image TEXT, lat REAL, lng REAL, address TEXT)');
    },
  );
  return db;
}

class UserPlacesNotifier extends StateNotifier<List<Place>> {
  UserPlacesNotifier() : super([]);
  Future<void> loadPlaces() async {
    final sql.Database db = await _getDataBase();
    final List<Map<String, Object?>> data = await db.query('user_places');
    List<Place> places = data
        .map(
          (row) => Place(
            placeLocation: PlaceLocation(
              lat: row['lat'] as double,
              lng: row['lng'] as double,
              address: row['address'] as String,
            ),
            image: File(row['image'] as String),
            title: row['title'] as String,
            id: row['id'] as String,
          ),
        )
        .toList();
    state = places;
  }

  void addPlace(
    String title,
    File image,
    PlaceLocation placeLocation,
  ) async {
    final Directory dir = await sys.getApplicationDocumentsDirectory();
    final String fileName = path.basename(image.path);
    final File copiedImage = await image.copy('${dir.path}/$fileName');
    final Place newPlace = Place(
      title: title,
      image: copiedImage,
      placeLocation: placeLocation,
    );
    final sql.Database db = await _getDataBase();

    db.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'lat': newPlace.placeLocation.lat,
      'lng': newPlace.placeLocation.lng,
      'address': newPlace.placeLocation.address,
    });
    state = [newPlace, ...state];
  }
}

final userPlacesProvider =
    StateNotifierProvider<UserPlacesNotifier, List<Place>>(
  (ref) => UserPlacesNotifier(),
);
