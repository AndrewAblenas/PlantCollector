//String constants so I don't have to change the name everywhere manually
class GlobalStrings {
  static const String group = 'Group';
  static const String groups = 'Groups';
  static const String photo = 'Photo';
  static const String photos = 'Photos';
  static const String collection = 'Shelf';
  static const String collections = 'Shelves';
  static const String plant = 'Plant';
  static const String plants = 'Plants';
  static const String library = 'Library';
  static const String libraries = 'Libraries';
  static const String app = 'Plant Collector';
  static const String discover = 'Discover';
  static const String friend = 'Friend';
  static const String friends = 'Friends';
  static const String settings = 'Settings';
  static const String account = 'Account';
  static const String journal = 'Journal';
  static const String clone = 'Clone';
  static const String greenThumb = 'Greenthumb';
  static const String feedback = 'Feedback';
  static const String news = 'News';
  static const String event = 'Event';
  static const String events = 'Events';
  static const String announcements = 'Announcements';
  static const String privacy = 'Privacy Policy';
  static const String guidelines = 'Community Guidelines';
  static const String checkItOut = 'Check out the App:\n\n'
      'iOS: ${GlobalLinks.downloadiOS}\n\n'
      'Android: ${GlobalLinks.downloadAndroid}';
}

class DefaultTypeValue {
  static const String defaultString = '';
  static const int defaultDate = 1577836800000;
  static const int defaultInt = 0;
  static const double defaultDouble = 0.0;
  static const List defaultList = [];
}

class GlobalLinks {
  static const String defaultImage =
      'https://firebasestorage.googleapis.com/v0/b/plant-collector-15db2.appspot.com/o/general%2Fui%2Fdefault_image.png?alt=media&token=9345ffa6-0cda-4bd7-8219-058be8850450';
  static const String downloadiOS =
      'https://testflight.apple.com/join/ZMDuMBZq';
  static const String downloadAndroid =
      'https://play.google.com/store/apps/details?id=com.ablenas.plant_collector';
}

class DatesCustom {
  static const List monthNumbers = [
    00,
    01,
    02,
    03,
    04,
    05,
    06,
    07,
    08,
    09,
    10,
    11,
    12
  ];
  static const List<String> monthAbbreviations = [
    'N/A',
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  static const List<int> monthDayCutoffs = [
    0,
    31,
    59,
    90,
    120,
    151,
    181,
    212,
    243,
    273,
    304,
    334,
    365
  ];
  static const List<int> monthDayCount = [
    0,
    31,
    28,
    31,
    30,
    31,
    30,
    31,
    31,
    30,
    31,
    30,
    31
  ];
}
