import 'package:flutter/cupertino.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:plant_collector/formats/colors.dart';

//standard shape and style for app carousel

class CarouselStandard extends StatelessWidget {
  final List<Widget> items;
  final bool connectionLibrary;

  CarouselStandard({@required this.items, @required this.connectionLibrary});

  @override
  Widget build(BuildContext context) {
    //*****SET WIDGET VISIBILITY START*****//

    //initial slide index
    //if current user library and at least two items (Add Image Buttons and an image)
    //Then start at index 1, the first image
    int initialSlideIndex =
        (items.length >= 2 && connectionLibrary == false) ? 1 : 0;

    //*****SET WIDGET VISIBILITY END*****//

    return Container(
      padding: EdgeInsets.only(top: 10.0),
      decoration: BoxDecoration(
        color: kGreenMedium,
        boxShadow: kShadowBox,
      ),
      child: CarouselSlider(
        items: items,
        //index 0 is add image, default to index 0 if no images, otherwise start at 1
        //this will mean take image will be one scroll away
        initialPage: initialSlideIndex,
        height: MediaQuery.of(context).size.width * 0.96,
        viewportFraction: 0.94,
        enableInfiniteScroll: false,
      ),
    );
  }
}
