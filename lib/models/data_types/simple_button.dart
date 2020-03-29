import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SimpleButton {
  final IconData icon;
  final String label;
  final Function onPress;
  final String queryField;
  final Type type;
  SimpleButton({
    this.icon = Icons.check_box_outline_blank,
    this.label = '',
    @required this.onPress,
    @required this.queryField,
    @required this.type,
  });
}
