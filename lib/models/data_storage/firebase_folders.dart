//USER DB PATHS
class DBFolder {
  static const String collections = 'userCollections';
//  static const String userPlants = 'userPlants';
  static const String groups = 'userGroups';
  static const String friends = 'userConnections';
  static const String requests = 'userRequests';
  static const String records = 'records';
  static const String app = 'app';
  static const String rank = 'rank_plants';
  static const String userStatsTop = 'user_stats_top';
  static const String plants = 'plants';
  static const String quarantinePlants = 'quarantine_plants';
  static const String quarantineUsers = 'quarantine_users';
  static const String users = 'users';
  static const String announcements = 'announcements';
  static const String communications = 'communications';
}

//STORAGE PATHS
class DBFields {
  static const String byPlants = 'byPlants';
}

//STORAGE PATHS
class DBDocument {
  static const String users = 'users';
  static const String plants = 'plants';
  static const String images = 'images';
  static const String settings = 'settings';
  static const String feedbackBugs = 'feedback_bugs';
  static const String feedbackFeatures = 'feedback_features';
  static const String feedbackAbuse = 'feedback_abuse';
  static const String about = 'about';
  static const String communityGuidelines = 'community_guidelines';
  static const String privacyPolicy = 'privacy_policy';
  static const String communication = 'communication';
  static const String reportedPlants = 'reported_plants';
  static const String reportedUser = 'reported_users';
  static const String reportersPlants = 'reporters_plants';
  static const String reportersUsers = 'reporters_users';
  static const String adminToUser = 'admin_to_user';
}

//FOLDERS FOR MOVING/IMPORTING
class DBDefaultDocument {
  //import group name
  static const String import = 'import';
  //import collection names
  static const String clone = 'clone';
  static const String orphaned = 'orphaned';
  static const List<String> collectionExclude = [clone, orphaned];
}
