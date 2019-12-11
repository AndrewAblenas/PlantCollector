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
  static const String notes = 'plantNotes';
  static const String thumbnail = 'plantThumbnail';
  static const String images = 'plantImageList';

  //DESCRIPTORS
  static const Map<String, String> descriptors = {
    id: 'Plant Library ID',
    name: 'Display Name',
    variety: 'Cultivar/Variety',
    genus: 'Genus',
    species: 'Species',
    quantity: 'Quantity',
    notes: 'Notes',
    thumbnail: 'Thumbnail',
    images: 'Image Files',
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
  final String notes;
  final String thumbnail;
  final List images;

  //CONSTRUCTOR
  PlantData({
    @required this.id,
    @required this.name,
    this.variety,
    this.genus,
    this.species,
    this.quantity,
    this.notes,
    this.thumbnail,
    this.images,
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
      PlantKeys.notes: notes,
      PlantKeys.thumbnail: thumbnail,
      PlantKeys.images: images,
    };
  }

  //FROM MAP
  static PlantData fromMap({@required plantMap}) {
    if (plantMap != null) {
      return PlantData(
        id: plantMap[PlantKeys.id] ?? '',
        name: plantMap[PlantKeys.name] ?? '',
        variety: plantMap[PlantKeys.variety] ?? '',
        genus: plantMap[PlantKeys.genus] ?? '',
        species: plantMap[PlantKeys.species] ?? '',
        quantity: plantMap[PlantKeys.quantity] ?? '',
        notes: plantMap[PlantKeys.notes] ?? '',
        thumbnail: plantMap[PlantKeys.thumbnail] ?? '',
        images: plantMap[PlantKeys.images] ?? [],
      );
    } else {
      return PlantData(id: '', name: '');
    }
  }
}