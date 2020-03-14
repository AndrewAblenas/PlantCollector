import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
// ***Android - WORKAROUND - this must be enabled for proper image rotation, disable for iOS.
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:image/image.dart' as ExtendedImage;
import 'package:date_format/date_format.dart';
import 'package:plant_collector/models/data_storage/firebase_folders.dart';

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
  Future<StorageReference> getReferenceFromURL({@required imageURL}) async {
    return await _storage.getReferenceFromUrl(imageURL);
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
  Future<StorageFileDownloadTask> downloadImage(
      {@required String url, @required File saveFile}) async {
    StorageReference reference = await _storage.getReferenceFromUrl(url);
    StorageFileDownloadTask download = reference.writeToFile(saveFile);
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
//        StorageFileDownloadTask download =
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
//        StorageUploadTask imageUpload =
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
    StorageReference thumbRef = getImageRef(
        imageName: imageName, imageExtension: 'jpg', plantIDFolder: plantID);
    //get the thumb url
    return await getImageUrl(reference: thumbRef);
  }

  //get thumbnail url from image url
  static String getThumbName({@required String imageUrl}) {
    print(imageUrl);
    String imageName;
    if (imageUrl != null) {
      //remove prefix to image name
      //note this only works if the images are saved to the plant 'image' folder.
      String split = imageUrl.split('images%2F')[1];
      //remove suffix to image name
      imageName = split.split('.jpg')[0];
    }
    //this suffice is as per the firebase extension that creates thumbnails
    return imageName + '_200x200';
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
  StorageReference getImageRef(
      {@required String imageName,
      @required String imageExtension,
      @required String plantIDFolder}) {
    StorageReference ref;
    try {
      ref = _storage.ref().child(
          '$mainFolder/$currentUserFolder/$plantsFolder/$plantIDFolder/$imageFolder/$imageName.$imageExtension');
    } catch (e) {
      print(e);
    }
    return ref;
  }

  //get image url
  Future<String> getImageUrl({@required StorageReference reference}) async {
    String url;
    try {
      url = await reference.getDownloadURL();
    } catch (e) {
      print(e);
    }
    return url;
  }

  //*****************CLOUD STORAGE IMAGE RELATED*****************

  //UPLOAD A NEW IMAGE
  Future<String> getDownloadURL({
    @required StorageTaskSnapshot snapshot,
  }) async {
    String url = await snapshot.ref.getDownloadURL();
    return url;
  }

  //UPLOAD TASK
  StorageUploadTask uploadTask({
    @required File imageFile,
    @required List<int> imageCode,
    @required String imageExtension,
    @required String plantIDFolder,
    @required String subFolder,
  }) {
    StorageUploadTask upload;
    if (imageFile != null) {
      String imageName = generateImageName(plantID: plantIDFolder);
      //note image type not detection on iOS uploads defaults to applications/octet-stream
      StorageMetadata metadata = StorageMetadata(contentType: 'image/jpeg');
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
  StorageUploadTask uploadToUserSettingsTask(
      {@required File imageFile, @required String imageName}) {
    StorageUploadTask upload;
    if (imageFile != null) {
      //note image type not detection on iOS uploads defaults to applications/octet-stream
      StorageMetadata metadata = StorageMetadata(contentType: 'image/jpeg');
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
  Future<void> deleteImage({@required StorageReference imageReference}) {
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
        StorageReference reference =
            await getReferenceFromURL(imageURL: imageURL);
        StorageMetadata meta = await reference.getMetadata();
        date = dateFormat(msSinceEpoch: meta.creationTimeMillis);
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
  Future<File> getCameraImage({@required bool fromCamera}) async {
    File image;
    try {
      if (fromCamera == true) {
        image = await ImagePicker.pickImage(
            source: ImageSource.camera,
            imageQuality: 90,
            maxWidth: cameraImageSize,
            maxHeight: cameraImageSize);
      } else {
        image = await ImagePicker.pickImage(
            source: ImageSource.gallery,
            imageQuality: 90,
            maxWidth: cameraImageSize,
            maxHeight: cameraImageSize);
      }
    } catch (e) {
      image = null;
    }
    //make sure the image took
    if (image != null && image.path != null && Platform.isAndroid) {
      //// ***Android - WORKAROUND - this must be enabled for proper image rotation, disable for iOS
      image = await FlutterExifRotation.rotateAndSaveImage(path: image.path);
    }
    return image;
  }

  //END OF SECTION
}
