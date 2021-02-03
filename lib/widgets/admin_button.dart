import 'package:flutter/material.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:plant_collector/models/data_types/user_data.dart';
import 'package:plant_collector/widgets/container_wrapper.dart';
import 'package:provider/provider.dart';

class AdminButton extends StatelessWidget {
  const AdminButton({
    @required this.label,
    @required this.onPress,
    this.color,
  });

  final String label;
  final Function onPress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    //easy reference
    AppData provAppDataFalse = Provider.of<AppData>(context, listen: false);
    //do another check to make sure
    return (provAppDataFalse.currentUserInfo.type == UserTypes.creator ||
            provAppDataFalse.currentUserInfo.type == UserTypes.admin)
        ? GestureDetector(
            onTap: () {
              onPress();
            },
            child: Padding(
              padding: EdgeInsets.all(
                5.0,
              ),
              child: ContainerWrapper(
                color: (color != null) ? color : Colors.red,
                marginVertical: 0.0,
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    '!ADMIN: $label',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: AppTextColor.white,
                        fontSize: AppTextSize.small *
                            MediaQuery.of(context).size.width),
                  ),
                ),
              ),
            ),
          )
        : SizedBox();
  }
}
