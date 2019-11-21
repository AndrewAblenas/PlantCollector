import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageScreen extends StatelessWidget {
  final String imageURL;
  ImageScreen({this.imageURL});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: PhotoView(
          imageProvider: NetworkImage(imageURL),
          maxScale: 4.0,
        ),
      ),
    );
  }
}
