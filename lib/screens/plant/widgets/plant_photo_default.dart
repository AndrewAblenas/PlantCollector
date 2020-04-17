import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';

class PlantPhotoDefault extends StatelessWidget {
  final bool largeWidget;
  PlantPhotoDefault({@required this.largeWidget});
  @override
  Widget build(BuildContext context) {
    //*****SET WIDGET VISIBILITY START*****//

    //only show set thumbnail for large widget and current user is owner
    double iconSize = (largeWidget == true) ? 0.5 : 0.2;

    //*****SET WIDGET VISIBILITY END*****//

    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(bottom: (largeWidget == true) ? 10.0 : 0.0),
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/images/default.png'),
            ),
            boxShadow: kShadowBox,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: (largeWidget == true) ? 10.0 : 0.0),
          child: Center(
            child: Icon(
              Icons.image,
              color: Color(0x77FFFFFF),
              size: iconSize * MediaQuery.of(context).size.width,
            ),
          ),
        ),
      ],
    );
  }
}
