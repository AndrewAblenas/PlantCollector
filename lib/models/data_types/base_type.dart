import 'package:flutter/cupertino.dart';
import 'package:plant_collector/models/global.dart';

class DV {
  //BASE TYPE FOR ALL SHARED METHODS

  //TYPE CHECK STRING
  static String isString(
      {@required var value, String fallback = DefaultTypeValue.defaultString}) {
    //return true if value is not null and of the desired type
    return (value != null && value is String) ? value : fallback;
  }

  //TYPE CHECK INT
  static num isInt({@required var value}) {
    //return true if value is not null and is number
    return (value != null && value is num)
        ? value
        : DefaultTypeValue.defaultInt;
  }

  //TYPE CHECK DOUBLE
  static num isDouble({@required var value}) {
    //return true if value is not null and is number
    return (value != null && value is num)
        ? value
        : DefaultTypeValue.defaultDouble;
  }

  //TYPE CHECK BOOL
  static bool isBool({@required var value, bool fallback = false}) {
    //return true if value is not null and of the desired type
    return (value != null && value is bool) ? value : fallback;
  }

  //TYPE CHECK BOOL
  static List isList({@required var value}) {
    //return true if value is not null and of the desired type
    return (value != null && value is List)
        ? value
        : DefaultTypeValue.defaultList;
  }
}
