import 'package:flutter/cupertino.dart';
import 'package:carousel_slider/carousel_slider.dart';

//standard shape and style for app carousel

class CarouselStandard extends StatelessWidget {
  final List<Widget> items;
  final bool connectionLibrary;

  CarouselStandard({@required this.items, @required this.connectionLibrary});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: items,
      //index 0 is add image, default to index 0 if no images, otherwise start at 1
      //this will mean take image will be one scroll away
      initialPage: (items.length >= 2 && connectionLibrary == false) ? 1 : 0,
      height: MediaQuery.of(context).size.width * 0.96,
      viewportFraction: 0.94,
      enableInfiniteScroll: false,
    );
  }
}
