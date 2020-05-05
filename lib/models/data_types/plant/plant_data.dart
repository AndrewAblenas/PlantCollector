import 'package:flutter/material.dart';
import 'package:plant_collector/models/data_types/base_type.dart';
import 'package:plant_collector/models/data_types/plant/bloom_data.dart';
import 'package:plant_collector/models/data_types/plant/growth_data.dart';
import 'package:plant_collector/models/data_types/plant/image_data.dart';

//*****************PLANT*****************

class PlantKeys {
  //KEYS
  static const String id = 'plantID';
  static const String name = 'plantName';
  static const String variety = 'plantVariety';
  static const String genus = 'plantGenus';
  static const String species = 'plantSpecies';
  static const String hybrid = 'plantHybrid';
  static const String parentage = 'parentage';
  static const String quantity = 'plantQuantity';
  static const String bloom = 'plantBloom';
//  static const String bloomSequence = 'bloomSequence';
  static const String repot = 'plantRepot';
  static const String division = 'plantDivision';
  static const String notes = 'plantNotes';
  static const String thumbnail = 'plantThumbnail';
  static const String images = 'plantImageList';
  static const String imageSets = 'imageSets';
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
//  static const String growthSequence = 'growthSequence';
  static const String sequenceBloom = 'sequenceBloom';
  static const String sequenceGrowth = 'sequenceGrowth';

  //VISIBLE LIST
  static const List<String> listVisibleKeys = [
    name,
    genus,
    species,
    hybrid,
    variety,
    parentage,
//    bloomSequence,
//    growthSequence,
    sequenceBloom,
    sequenceGrowth,
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

  //STRING KEYS FROM VISIBLE LIST
  static const List<String> listStringKeys = [
    name,
    genus,
    species,
    hybrid,
    variety,
    parentage,
    water,
    fertilize,
    bloom,
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

  //SHOW DAY OF YEAR
  static const List<String> listDatePickerMultipleKeys = [
//    bloomSequence,
//    growthSequence,
    sequenceBloom,
    sequenceGrowth,
  ];

  //DESCRIPTORS
  static const Map<String, String> descriptors = {
    id: 'Plant Library ID',
    name: 'Display Name',
    variety: 'Variety/Clone',
    species: 'Species',
    hybrid: 'Hybrid',
    genus: 'Genus',
    parentage: 'Parent Plants',
    quantity: 'Quantity',
    bloom: 'Flowering',
//    bloomSequence: 'Bloom Sequence',
    repot: 'Last Repot',
    division: 'Last Division',
    notes: 'Notes',
    thumbnail: 'Thumbnail',
    images: 'Image Files',
    imageSets: 'Image Sets',
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
//    growthSequence: 'Growth Cycle'
    sequenceBloom: 'Bloom Sequence',
    sequenceGrowth: 'Growth Sequence',
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
  final String parentage;
  final String quantity;
  final String bloom;
//  final List<BloomData> bloomSequence;
  final int repot;
  final int division;
  final String notes;
  final String thumbnail;
  final List images;
  final List<ImageData> imageSets;
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
//  final List<GrowthData> growthSequence;
  final List<BloomData> sequenceBloom;
  final List<GrowthData> sequenceGrowth;

  //CONSTRUCTOR
  PlantData({
    @required this.id,
    @required this.name,
    this.variety,
    this.species,
    this.hybrid,
    this.genus,
    this.parentage,
    this.quantity,
    this.bloom,
//      this.bloomSequence,
    this.repot,
    this.division,
    this.notes,
    this.thumbnail,
    this.images,
    this.imageSets,
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
    this.awards,
//      this.growthSequence
    this.sequenceBloom,
    this.sequenceGrowth,
  });

  //TO MAP
  Map<String, dynamic> toMap() {
    List<Map> bloomInfo = [];
    if (sequenceBloom != null && sequenceBloom.length > 0) {
      for (BloomData data in sequenceBloom) {
        bloomInfo.add(data.toMap());
      }
    }
    List<Map> growthInfo = [];
    if (sequenceGrowth != null && sequenceGrowth.length > 0) {
      for (GrowthData data in sequenceGrowth) {
        growthInfo.add(data.toMap());
      }
    }
    List<Map> imageInfo = [];
    if (imageSets != null && imageSets.length > 0) {
      for (ImageData data in imageSets) {
        imageInfo.add(data.toMap());
      }
    }
    return {
      PlantKeys.id: id,
      PlantKeys.name: name,
      PlantKeys.variety: variety,
      PlantKeys.species: species,
      PlantKeys.hybrid: hybrid,
      PlantKeys.genus: genus,
      PlantKeys.parentage: parentage,
      PlantKeys.quantity: quantity,
      PlantKeys.bloom: bloom,
      PlantKeys.repot: repot,
      PlantKeys.division: division,
      PlantKeys.notes: notes,
      PlantKeys.thumbnail: thumbnail,
      PlantKeys.images: images,
      PlantKeys.imageSets: imageInfo.toList(),
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
      PlantKeys.sequenceBloom: bloomInfo.toList(),
      PlantKeys.sequenceGrowth: growthInfo.toList()
    };
  }

  //FROM MAP
  static PlantData fromMap({@required map}) {
    if (map != null) {
      //repack bloom data
      List<BloomData> bloomInfo = [];
      if (map[PlantKeys.sequenceBloom] != null) {
        for (Map data in map[PlantKeys.sequenceBloom]) {
          bloomInfo.add(BloomData.fromMap(map: data));
        }
      }
      //repack growth data
      List<GrowthData> growthInfo = [];
      if (map[PlantKeys.sequenceGrowth] != null) {
        for (Map data in map[PlantKeys.sequenceGrowth]) {
          growthInfo.add(GrowthData.fromMap(map: data));
        }
      }
//repack image data
      List<ImageData> imageSetsInfo = [];
      if (map[PlantKeys.imageSets] != null) {
        for (Map data in map[PlantKeys.imageSets]) {
          imageSetsInfo.add(ImageData.fromMap(map: data));
        }
      }
      return PlantData(
        id: DV.isString(value: map[PlantKeys.id]),
        name: DV.isString(value: map[PlantKeys.name]),
        variety: DV.isString(value: map[PlantKeys.variety]),
        species: DV.isString(value: map[PlantKeys.species]),
        hybrid: DV.isString(value: map[PlantKeys.hybrid]),
        genus: DV.isString(value: map[PlantKeys.genus]),
        parentage: DV.isString(value: map[PlantKeys.parentage]),
        quantity: DV.isString(value: map[PlantKeys.quantity]),
        bloom: DV.isString(value: map[PlantKeys.bloom]),
        repot: DV.isInt(value: map[PlantKeys.repot]),
        division: DV.isInt(value: map[PlantKeys.division]),
        notes: DV.isString(value: map[PlantKeys.notes]),
        thumbnail: DV.isString(value: map[PlantKeys.thumbnail]),
        images: DV.isList(value: map[PlantKeys.images]),
        imageSets: DV.isList(value: imageSetsInfo.toList()),
        likes: DV.isInt(value: map[PlantKeys.likes]),
        owner: DV.isString(value: map[PlantKeys.owner]),
        clones: DV.isInt(value: map[PlantKeys.clones]),
        journal: DV.isList(value: map[PlantKeys.journal]),
        water: DV.isString(value: map[PlantKeys.water]),
        fertilize: DV.isString(value: map[PlantKeys.fertilize]),
        price: DV.isString(value: map[PlantKeys.price]),
        update: DV.isInt(value: map[PlantKeys.update]),
        created: DV.isInt(value: map[PlantKeys.created]),
        want: DV.isBool(value: map[PlantKeys.want]),
        sell: DV.isBool(value: map[PlantKeys.sell]),
        isVisible: DV.isBool(value: map[PlantKeys.isVisible]),
        isFlagged: DV.isBool(value: map[PlantKeys.isFlagged]),
        isHousePlant: DV.isBool(value: map[PlantKeys.isHousePlant]),
        dateAcquired: DV.isInt(value: map[PlantKeys.dateAcquired]),
        awards: DV.isString(value: map[PlantKeys.awards]),
        sequenceBloom: DV.isList(value: bloomInfo.toList()),
        sequenceGrowth: DV.isList(value: growthInfo.toList()),
      );
    } else {
      return PlantData(
        id: '',
        name: '',
        created: 0,
        isVisible: false,
      );
    }
  }
}
