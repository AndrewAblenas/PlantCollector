import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
// ***Android - WORKAROUND - this must be enabled for proper image rotation, disable for iOS.
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:image/image.dart' as ExtendedImage;
import 'package:date_format/date_format.dart';
import 'package:plant_collector/models/data_storage/firebase_folders.dart';
import 'package:plant_collector/models/data_types/plant/plant_data.dart';

//*****************OVERVIEW*****************
//Class relating to the creation, storage, deletion of images via Firebase Storage

class CloudStore extends ChangeNotifier {
  //initialize storage instance
  final FirebaseStorage _storage = FirebaseStorage.instance;
  //main folder
  static String mainFolder = DBDocument.users;
  //user folder
  String currentUserFolder;
  //user plants folder
  static String plantsFolder = DBDocument.plants;
  //user image folder
  static String imageFolder = DBDocument.images;
  //settings folder
  static String settingsFolder = DBDocument.settings;
  //image sizing
  static int thumbnailSize = 200;
  static double cameraImageSize = 800.0;
  //connection folder to view library
  String currentConnectionFolder;

  Reference getStorageRef() {
    return _storage.ref();
  }

  void setUserFolder({@required String userID}) {
    currentUserFolder = userID;
  }

  void setConnectionFolder({@required String connectionID}) {
    currentConnectionFolder = connectionID;
  }

  //*****************GENERAL*****************

  //METHOD TO GENERATE IMAGE NAME
  String generateImageName({@required String plantID}) {
    return plantID +
        '_image_' +
        DateTime.now().millisecondsSinceEpoch.toString();
  }

//  //GET REFERENCE FROM URL
  Future<Reference> getReferenceFromURL({@required imageURL}) async {
    return _storage.refFromURL(imageURL);
  }

  //GET URL FROM REFERENCES
  Future<List> getURLs({@required List<dynamic> listImageReferences}) async {
    List<String> linkList = [];
    if (listImageReferences != null) {
      for (String ref in listImageReferences) {
        try {
          String url = await _storage.ref().child(ref).getDownloadURL();
          linkList.add(url);
        } catch (e) {
          print(e);
        }
      }
    }
    print('getURLs: Complete');
    return linkList;
  }

  //*****************CLOUD STORAGE THUMBNAIL RELATED*****************

  //CREATE TEMP DIRECTORY FOR DOWNLOAD
  File createTemp() {
    //need a directory to download
    Directory tempDir = Directory.systemTemp;
    File tempFile = File('${tempDir.path}/download.jpg');
    print('createTemp: Complete');
    return tempFile;
  }

  //DOWNLOAD IMAGE
  DownloadTask downloadImage({@required String url, @required File saveFile}) {
    Reference reference = _storage.refFromURL(url);
    DownloadTask download = reference.writeToFile(saveFile);
    print('downloadImage: Complete');
    return download;
  }

  //CREATE THUMBNAIL
  List<int> generateThumbnail({@required File image}) {
    //crop and resize file
    ExtendedImage.Image extendedImage =
        ExtendedImage.decodeJpg(image.readAsBytesSync());
    ExtendedImage.Image thumbnail =
        ExtendedImage.copyResizeCropSquare(extendedImage, thumbnailSize);
    List<int> encodedImage = ExtendedImage.encodeJpg(thumbnail);
    print('generateThumbnail: Complete');
    return encodedImage;
  }

  //this was a temp function can probably delete now
//  Future tempGenThumb(
//      {@required List urls, @required String plantIDFolder}) async {
//    if (urls != null) {
//      for (String link in urls) {
//        //create temp file
//        File tempFile = createTemp();
//        //download the image
//        FileDownloadTask download =
//            await downloadImage(url: link, saveFile: tempFile);
//        //wait for download completion
//        await download.future;
//        //create temp file
//        File imageFile = createTemp();
//        //edit the image
//        List<int> uploadPackage = generateThumbnail(image: imageFile);
//        //get image name
//        String name = getThumbName(imageUrl: link);
//        //upload
//        String path =
//            '$mainFolder/$currentUserFolder/$plantsFolder/$plantIDFolder/images/$name.jpg';
//        UploadTask imageUpload =
//            _storage.ref().child(path).putData(uploadPackage);
//        //check upload
//        StorageTaskSnapshot uploadSnapshot = await imageUpload.onComplete;
//        //get URL
//        String url = await getDownloadURL(snapshot: uploadSnapshot);
//        _storage
//            .ref()
//            .child(
//                '$mainFolder/$currentUserFolder/$plantsFolder/$plantIDFolder/thumbnail/')
//            .delete();
//        return url;
//      }
//    }
//  }

  Future<String> thumbnailPackage(
      {@required String imageURL, @required String plantID}) async {
    //get the thumbnail image name from the full sized image url
    String imageName = getThumbName(imageUrl: imageURL);
    //get the thumb ref
    Reference thumbRef = getImageRef(
        imageName: imageName,
        imageExtension: 'jpg',
        plantIDFolder: plantID,
        ownerID: currentUserFolder);
    //get the thumb url
    return getImageUrl(reference: thumbRef);
  }

  //get thumbnail url from image url
  static String getThumbName({@required String imageUrl}) {
    String imageName;
    if (imageUrl != null) {
      //remove prefix to image name
      try {
        //note this only works if the images are saved to the plant 'image' folder.
        String split = imageUrl.split('images%2F')[1];
        //remove suffix to image name
        imageName = split.split('.jpg')[0];
        imageName = imageName + '_200x200';
      } catch (e) {
        print(
            'these images were uploaded to plant/plantID/plants instead of plant/plantID/images');
        imageName = null;
      }
    }
    //this suffice is as per the firebase extension that creates thumbnails
    return imageName;
  }

  //get thumbnail url from image url
//  static String getThumbURL({@required String imageUrl}) {
//    print(imageUrl);
//    String imagePath;
//    if (imageUrl != null) {
//      //split to insert thumbnail suffix
//      List split = imageUrl.split('.jpg');
//      //insert
//      split.insert(1, '_200x200.jpg');
//      imagePath = split[0] + split[1] + split[2];
//    }
//    //this suffice is as per the firebase extension that creates thumbnails
//    print(imagePath);
//    return imagePath;
//  }

  //get image ref
  Reference getImageRef(
      {@required String imageName,
      @required String imageExtension,
      @required String plantIDFolder,
      @required String ownerID}) {
    Reference ref;
    try {
      ref = _storage.ref().child(
          '$mainFolder/$ownerID/$plantsFolder/$plantIDFolder/$imageFolder/$imageName.$imageExtension');
    } catch (e) {
      print(e);
    }
    return ref;
  }

  //get image url
  static Future<String> getImageUrl({@required Reference reference}) async {
    try {
      String url = await reference.getDownloadURL();
      return url;
    } catch (e) {
      print('ERROR');
      return 'fail';
    }
  }

  //*****************CLOUD STORAGE IMAGE RELATED*****************

  //UPLOAD A NEW IMAGE
  Future<String> getDownloadURL({
    @required TaskSnapshot snapshot,
  }) async {
    String url = await snapshot.ref.getDownloadURL();
    return url;
  }

  Future<List<String>> getThumbURLs(
      {@required List imageURLs,
      @required PlantData plant,
      @required String imageExtension}) async {
    List<String> listThumbs = [];
    for (String url in imageURLs) {
      //get the thumbnail image name for delete image and gridview display
      String thumbName = CloudStore.getThumbName(imageUrl: url);
      //get the thumb reference
      Reference thumbRef = _storage.ref().child(
          '$mainFolder/${plant.owner}/$plantsFolder/${plant.id}/$imageFolder/$thumbName.$imageExtension');
      //get the url
      String item = await CloudStore.getImageUrl(reference: thumbRef);
      listThumbs.add(item);
    }
    return listThumbs;
  }

  //UPLOAD TASK
  UploadTask uploadTask({
    @required File imageFile,
    @required List<int> imageCode,
    @required String imageExtension,
    @required String plantIDFolder,
    @required String subFolder,
  }) {
    UploadTask upload;
    if (imageFile != null) {
      String imageName = generateImageName(plantID: plantIDFolder);
      //note image type not detection on iOS uploads defaults to applications/octet-stream
      SettableMetadata metadata = SettableMetadata(contentType: 'image/jpeg');
      String path =
          '$mainFolder/$currentUserFolder/$plantsFolder/$plantIDFolder/$subFolder/$imageName.$imageExtension';
      upload = _storage
          .ref()
          .child(path)
          .putData(imageFile.readAsBytesSync(), metadata);
    } else if (imageCode != null) {
      String path =
          '$mainFolder/$currentUserFolder/$plantsFolder/$plantIDFolder/$subFolder/thumbnail.$imageExtension';
      upload = _storage.ref().child(path).putData(imageCode);
    } else {
      upload = null;
    }
    print('uploadTask: Complete');
    return upload;
  }

  //UPLOAD TASK
  UploadTask uploadToUserSettingsTask(
      {@required File imageFile, @required String imageName}) {
    UploadTask upload;
    if (imageFile != null) {
      //note image type not detection on iOS uploads defaults to applications/octet-stream
      SettableMetadata metadata = SettableMetadata(contentType: 'image/jpeg');
      String path =
          '$mainFolder/$currentUserFolder/$settingsFolder/$imageName.jpg';
      upload = _storage
          .ref()
          .child(path)
          .putData(imageFile.readAsBytesSync(), metadata);
    } else {
      upload = null;
    }
    print('uploadTask: Complete');
    return upload;
  }

  //GET AN IMAGE
//  Future<dynamic> getThumbUrlOld(
//      {@required String imageName,
//      @required String imageExtension,
//      @required String plantIDFolder}) async {
//    Future<dynamic> url;
//    try {
//      url = await _storage
//          .ref()
//          .child(
//              '$mainFolder/$currentUserFolder/$plantsFolder/$plantIDFolder/$kFolderThumbnail/$imageName.$imageExtension')
//          .getDownloadURL();
//    } catch (e) {
//      print(e);
//    }
//    return url;
//  }

  //DELETE AN IMAGE
  Future<void> deleteImage({@required Reference imageReference}) {
    return imageReference.delete();
  }

  //FORMAT DATE
  static String dateFormat({@required int msSinceEpoch}) {
    String date = formatDate(DateTime.fromMillisecondsSinceEpoch(msSinceEpoch),
        [MM, ' ', d, ', ', yyyy]);
    return date;
  }

  //GET METADATA DATE
  Future<String> getMetaDate({@required String imageURL}) async {
    String date;
    if (imageURL != null) {
      try {
        Reference reference = await getReferenceFromURL(imageURL: imageURL);
        FullMetadata meta = await reference.getMetadata();
        date =
            dateFormat(msSinceEpoch: meta.timeCreated.millisecondsSinceEpoch);
      } catch (e) {
        date = '';
        print(e);
      }
    } else {
      date = '';
    }
    return date;
  }

  //DELETE ALL IMAGES (FOR DELETE PLANT)
  //no functionality to delete entire folder so this is a cloud function now
  //on plant delete, the associated plant image folder is now deleted

  //*****************CAMERA METHODS*****************

  //METHOD TO LAUNCH IMAGE PICKER AND GET IMAGE
  Future<File> getImageFile({@required bool fromCamera}) async {
    PickedFile image;
    try {
      if (fromCamera == true) {
        image = await ImagePicker().getImage(
            source: ImageSource.camera,
            imageQuality: 90,
            maxWidth: cameraImageSize,
            maxHeight: cameraImageSize);
      } else {
        image = await ImagePicker().getImage(
            source: ImageSource.gallery,
            imageQuality: 90,
            maxWidth: cameraImageSize,
            maxHeight: cameraImageSize);
      }
      //make sure the image took
      if (image != null && image.path != null && Platform.isAndroid) {
        //// ***Android - WORKAROUND - this must be enabled for proper image rotation, disable for iOS
        final ExtendedImage.Image capturedImage =
            ExtendedImage.decodeImage(await File(image.path).readAsBytes());
        final ExtendedImage.Image orientedImage =
            ExtendedImage.bakeOrientation(capturedImage);
        return await File(image.path)
            .writeAsBytes(ExtendedImage.encodeJpg(orientedImage));
        //exif extension is not working correctly
        // return await FlutterExifRotation.rotateImage(path: image.path);
      } else {
        return File(image.path);
      }
    } catch (e) {
      print('Error with Image Capture');
      return null;
    }
  }

  //END OF SECTION
}
