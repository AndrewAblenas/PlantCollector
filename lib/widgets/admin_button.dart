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
  });

  final String label;
  final Function onPress;

  @override
  Widget build(BuildContext context) {
    //do another check to make sure
    return (Provider.of<AppData>(context).currentUserInfo.type ==
                UserTypes.creator ||
            Provider.of<AppData>(context).currentUserInfo.type ==
                UserTypes.admin)
        ? GestureDetector(
            onTap: () {
              onPress();
            },
            child: Padding(
              padding: EdgeInsets.all(
                5.0,
              ),
              child: ContainerWrapper(
                color: Colors.red,
                marginVertical: 0.0,
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      '!ADMIN: ${label.toUpperCase()}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: AppTextColor.white,
                          fontSize: AppTextSize.medium *
                              MediaQuery.of(context).size.width),
                    ),
                  ),
                ),
              ),
            ),
          )
        : SizedBox();
  }
}
