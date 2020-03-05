import 'package:flutter/material.dart';

//*****************PLANT*****************

class PlantKeys {
  //KEYS
  static const String id = 'plantID';
  static const String name = 'plantName';
  static const String variety = 'plantVariety';
  static const String genus = 'plantGenus';
  static const String species = 'plantSpecies';
  static const String quantity = 'plantQuantity';
  static const String bloom = 'plantBloom';
  static const String repot = 'plantRepot';
  static const String division = 'plantDivision';
  static const String notes = 'plantNotes';
  static const String thumbnail = 'plantThumbnail';
  static const String images = 'plantImageList';
  static const String likes = 'plantLikes';

  //DESCRIPTORS
  static const Map<String, String> descriptors = {
    id: 'Plant Library ID',
    name: 'Display Name',
    variety: 'Cultivar/Variety',
    genus: 'Genus',
    species: 'Species',
    quantity: 'Quantity',
    bloom: 'Bloom Time',
    repot: 'Last Repot',
    division: 'Last Division',
    notes: 'Notes',
    thumbnail: 'Thumbnail',
    images: 'Image Files',
    likes: 'Total Greenthumbs',
  };
}

class PlantData {
  //VARIABLES
  final String id;
  final String name;
  final String variety;
  final String genus;
  final String species;
  final String quantity;
  final String bloom;
  final String repot;
  final String division;
  final String notes;
  final String thumbnail;
  final List images;
  final int likes;

  //CONSTRUCTOR
  PlantData({
    @required this.id,
    @required this.name,
    this.variety,
    this.genus,
    this.species,
    this.quantity,
    this.bloom,
    this.repot,
    this.division,
    this.notes,
    this.thumbnail,
    this.images,
    this.likes,
  });

  //TO MAP
  Map<String, dynamic> toMap() {
    return {
      PlantKeys.id: id,
      PlantKeys.name: name,
      PlantKeys.variety: variety,
      PlantKeys.genus: genus,
      PlantKeys.species: species,
      PlantKeys.quantity: quantity,
      PlantKeys.bloom: bloom,
      PlantKeys.repot: repot,
      PlantKeys.division: division,
      PlantKeys.notes: notes,
      PlantKeys.thumbnail: thumbnail,
      PlantKeys.images: images,
      PlantKeys.likes: likes,
    };
  }

  //FROM MAP
  static PlantData fromMap({@required map}) {
    if (map != null) {
      return PlantData(
        id: map[PlantKeys.id] ?? '',
        name: map[PlantKeys.name] ?? '',
        variety: map[PlantKeys.variety] ?? '',
        genus: map[PlantKeys.genus] ?? '',
        species: map[PlantKeys.species] ?? '',
        quantity: map[PlantKeys.quantity] ?? '',
        bloom: map[PlantKeys.bloom] ?? '',
        repot: map[PlantKeys.repot] ?? '',
        division: map[PlantKeys.division] ?? '',
        notes: map[PlantKeys.notes] ?? '',
        thumbnail: map[PlantKeys.thumbnail] ?? '',
        images: map[PlantKeys.images] ?? [],
        likes: map[PlantKeys.likes] ?? 0,
      );
    } else {
      return PlantData(id: '', name: '');
    }
  }
}
