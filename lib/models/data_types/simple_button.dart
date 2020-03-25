import 'package:flutter/cupertino.dart';

class SimpleButton {
  final IconData icon;
  final Function onPress;
  final String queryField;
  final Type type;
  SimpleButton({
    @required this.icon,
    @required this.onPress,
    @required this.queryField,
    @required this.type,
  });
}
