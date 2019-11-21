import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:plant_collector/models/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:image/image.dart' as ExtendedImage;
import 'package:date_format/date_format.dart';

//*****************OVERVIEW*****************
//Class relating to the creation, storage, deletion of images via Firebase Storage

class CloudStore extends ChangeNotifier {
  //initialize storage instance
  final FirebaseStorage _storage = FirebaseStorage.instance;
  //main folder
  static String mainFolder = kFolderUsers;
  //user folder
  String userFolder;
  //plants folder
  static String plantsFolder = kFolderPlants;
  //image folder
  static String imageFolder = kFolderImages;
  //thumbnail folder
  static String thumbnailFolder = kFolderThumbnail;
  static int thumbnailSize = 200;
  static double cameraImageSize = 800.0;

  void setUserFolderID(String loggedInID) {
    userFolder = loggedInID;
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
    List<int> encodedImage = ExtendedImage.encodePng(thumbnail);
    print('generateThumbnail: Complete');
    return encodedImage;
  }

  Future<String> thumbnailPackage(
      {@required String imageURL, @required String plantID}) async {
    //create temp file
    File tempFile = createTemp();
    //download the image
    StorageFileDownloadTask download =
        await downloadImage(url: imageURL, saveFile: tempFile);
    //wait for download completion
    await download.future;
    //create temp file
    File imageFile = createTemp();
    //edit the image
    List<int> uploadPackage = generateThumbnail(image: imageFile);
    //upload
    StorageUploadTask imageUpload = uploadTask(
        imageFile: null,
        imageCode: uploadPackage,
        imageExtension: 'png',
        plantIDFolder: plantID,
        subFolder: 'thumbnail');
    //check upload
    StorageTaskSnapshot uploadSnapshot = await imageUpload.onComplete;
    //get URL
    String url = await getDownloadURL(snapshot: uploadSnapshot);
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
      String path =
          '$mainFolder/$userFolder/$plantsFolder/$plantIDFolder/$subFolder/$imageName.$imageExtension';
      upload = _storage.ref().child(path).putData(imageFile.readAsBytesSync());
    } else if (imageCode != null) {
      String path =
          '$mainFolder/$userFolder/$plantsFolder/$plantIDFolder/$subFolder/thumbnail.$imageExtension';
      upload = _storage.ref().child(path).putData(imageCode);
    } else {
      upload = null;
    }
    print('uploadTask: Complete');
    return upload;
  }

  //GET AN IMAGE
  Future<dynamic> getImageURL(
      {@required String imageName,
      @required String imageExtension,
      @required String plantIDFolder}) async {
    Future<dynamic> url;
    try {
      url = await _storage
          .ref()
          .child(
              '$mainFolder/$userFolder/$plantsFolder/$plantIDFolder/$kFolderThumbnail/$imageName.$imageExtension')
          .getDownloadURL();
    } catch (e) {
      print(e);
    }
    return url;
  }

  //DELETE AN IMAGE
  Future<void> deleteImage({@required StorageReference imageReference}) {
    return imageReference.delete();
  }

  //GET METADATA DATE
  Future<String> getMetaDate({@required String imageURL}) async {
    String date;
    if (imageURL != null) {
      try {
        StorageReference reference =
            await getReferenceFromURL(imageURL: imageURL);
        StorageMetadata meta = await reference.getMetadata();
        date = formatDate(
            DateTime.fromMillisecondsSinceEpoch(meta.creationTimeMillis),
            [MM, ' ', d, ', ', yyyy]);
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
    if (image != null && image.path != null) {
      //fix needed for image rotation problem on android
      // Note : iOS not implemented
      image = await FlutterExifRotation.rotateAndSaveImage(path: image.path);
    }
    return image;
  }

  //END OF SECTION
}
