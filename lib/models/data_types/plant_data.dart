import 'package:flutter/material.dart';
import 'package:plant_collector/models/data_types/bloom_data.dart';

//*****************PLANT*****************

class PlantKeys {
  //KEYS
  static const String id = 'plantID';
  static const String name = 'plantName';
  static const String variety = 'plantVariety';
  static const String genus = 'plantGenus';
  static const String species = 'plantSpecies';
  static const String hybrid = 'plantHybrid';
  static const String quantity = 'plantQuantity';
  static const String bloom = 'plantBloom';
  static const String bloomSequence = 'bloomSequence';
  static const String repot = 'plantRepot';
  static const String division = 'plantDivision';
  static const String notes = 'plantNotes';
  static const String thumbnail = 'plantThumbnail';
  static const String images = 'plantImageList';
  static const String likes = 'plantLikes';
  static const String owner = 'plantOwner';
  static const String clones = 'plantTotalClones';
  static const String journal = 'plantJournal';
  static const String water = 'plantWatering';
  static const String fertilize = 'plantFertilizing';
  static const String price = 'plantPrice';
  static const String update = 'plantLastUpdate';
  static const String created = 'PlantCreationDate';
  static const String want = 'plantWant';
  static const String sell = 'plantSell';
  static const String isVisible = 'isVisible';
  static const String isFlagged = 'isFlagged';
  static const String isHousePlant = 'isHousePlant';
  static const String dateAcquired = 'dateAcquired';
  static const String awards = 'awards';

  //VISIBLE LIST
  static const List<String> visibleKeysList = [
    name,
    genus,
    species,
    hybrid,
    variety,
    bloomSequence,
    repot,
    division,
    water,
    fertilize,
    bloom,
    dateAcquired,
    quantity,
    price,
    awards,
    notes,
  ];

  //NAME KEYS
  static const List<String> listPlantNameKeys = [
    genus,
    species,
    hybrid,
    variety,
  ];

  //SHOW DATE PICKER
  static const List<String> listDatePickerKeys = [
    repot,
    division,
    dateAcquired,
  ];

  //DESCRIPTORS
  static const Map<String, String> descriptors = {
    id: 'Plant Library ID',
    name: 'Display Name',
    variety: 'Variety/Clone',
    species: 'Species',
    hybrid: 'Hybrid',
    genus: 'Genus',
    quantity: 'Quantity',
    bloom: 'Flowering',
    bloomSequence: 'Bloom Sequence',
    repot: 'Last Repot',
    division: 'Last Division',
    notes: 'Notes',
    thumbnail: 'Thumbnail',
    images: 'Image Files',
    likes: 'Total Greenthumbs',
    owner: 'Owner',
    clones: 'Total Clones Made',
    journal: 'Journal Entries',
    water: 'Watering',
    fertilize: 'Fertilizing',
    price: 'Price',
    update: 'Last Update',
    created: 'Addition Date',
    want: 'On Wishlist',
    sell: 'For Sale',
    isVisible: 'Visible In Feed',
    isFlagged: 'Flagged Innappropriate',
    isHousePlant: 'Grown Indoors',
    dateAcquired: 'Adoption Date',
    awards: 'Awards',
  };
}

class PlantData {
  //VARIABLES
  final String id;
  final String name;
  final String variety;
  final String species;
  final String hybrid;
  final String genus;
  final String quantity;
  final String bloom;
  final List<BloomData> bloomSequence;
  final int repot;
  final int division;
  final String notes;
  final String thumbnail;
  final List images;
  final int likes;
  final String owner;
  final int clones;
  final List journal;
  final String water;
  final String fertilize;
  final String price;
  final int update;
  final int created;
  final bool want;
  final bool sell;
  final bool isVisible;
  final bool isFlagged;
  final bool isHousePlant;
  final int dateAcquired;
  final String awards;

  //CONSTRUCTOR
  PlantData(
      {@required this.id,
      @required this.name,
      this.variety,
      this.species,
      this.hybrid,
      this.genus,
      this.quantity,
      this.bloom,
      this.bloomSequence,
      this.repot,
      this.division,
      this.notes,
      this.thumbnail,
      this.images,
      this.likes,
      this.owner,
      this.clones,
      this.journal,
      this.water,
      this.fertilize,
      this.price,
      this.update,
      @required this.created,
      this.want,
      this.sell,
      @required this.isVisible,
      this.isFlagged,
      this.isHousePlant,
      this.dateAcquired,
      this.awards});

  //TO MAP
  Map<String, dynamic> toMap() {
    List<Map> bloomInfo = [];
    if (bloomSequence != null && bloomSequence.length > 0) {
      for (BloomData data in bloomSequence) {
        bloomInfo.add(data.toMap());
      }
    }
    return {
      PlantKeys.id: id,
      PlantKeys.name: name,
      PlantKeys.variety: variety,
      PlantKeys.species: species,
      PlantKeys.hybrid: hybrid,
      PlantKeys.genus: genus,
      PlantKeys.quantity: quantity,
      PlantKeys.bloom: bloom,
      PlantKeys.bloomSequence: bloomInfo.toList(),
      PlantKeys.repot: repot,
      PlantKeys.division: division,
      PlantKeys.notes: notes,
      PlantKeys.thumbnail: thumbnail,
      PlantKeys.images: images,
      PlantKeys.likes: likes,
      PlantKeys.owner: owner,
      PlantKeys.clones: clones,
      PlantKeys.journal: journal,
      PlantKeys.water: water,
      PlantKeys.fertilize: fertilize,
      PlantKeys.price: price,
      PlantKeys.update: update,
      PlantKeys.created: created,
      PlantKeys.want: want,
      PlantKeys.sell: sell,
      PlantKeys.isVisible: isVisible,
      PlantKeys.isFlagged: isFlagged,
      PlantKeys.isHousePlant: isHousePlant,
      PlantKeys.dateAcquired: dateAcquired,
      PlantKeys.awards: awards,
    };
  }

  //FROM MAP
  static PlantData fromMap({@required map}) {
    if (map != null) {
      List<BloomData> bloomInfo = [];
      if (map[PlantKeys.bloomSequence] != null) {
        for (Map data in map[PlantKeys.bloomSequence]) {
          bloomInfo.add(BloomData.fromMap(map: data));
        }
      }
      return PlantData(
          id: map[PlantKeys.id] ?? '',
          name: map[PlantKeys.name] ?? '',
          variety: map[PlantKeys.variety] ?? '',
          species: map[PlantKeys.species] ?? '',
          hybrid: map[PlantKeys.hybrid] ?? '',
          genus: map[PlantKeys.genus] ?? '',
          quantity: map[PlantKeys.quantity] ?? '',
          bloom: map[PlantKeys.bloom] ?? '',
          bloomSequence: bloomInfo.toList() ?? [],
          repot: map[PlantKeys.repot] ?? 1577836800000,
          division: map[PlantKeys.division] ?? 1577836800000,
          notes: map[PlantKeys.notes] ?? '',
          thumbnail: map[PlantKeys.thumbnail] ?? '',
          images: map[PlantKeys.images] ?? [],
          likes: map[PlantKeys.likes] ?? 0,
          owner: map[PlantKeys.owner] ?? '',
          clones: map[PlantKeys.clones] ?? 0,
          journal: map[PlantKeys.journal] ?? [],
          water: map[PlantKeys.water] ?? '',
          fertilize: map[PlantKeys.fertilize] ?? '',
          price: map[PlantKeys.price] ?? '',
          update: map[PlantKeys.update] ?? 1577836800000,
          created: map[PlantKeys.created] ?? 1577836800000,
          want: map[PlantKeys.want] ?? false,
          sell: map[PlantKeys.sell] ?? false,
          isVisible: map[PlantKeys.isVisible] ?? false,
          isFlagged: map[PlantKeys.isFlagged] ?? false,
          isHousePlant: map[PlantKeys.isHousePlant] ?? false,
          dateAcquired: map[PlantKeys.dateAcquired] ?? 1577836800000,
          awards: map[PlantKeys.awards] ?? '');
    } else {
      return PlantData(
        id: '',
        name: '',
        created: 1577836800000,
        isVisible: false,
      );
    }
  }
}
