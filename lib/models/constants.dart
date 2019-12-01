//Application Constants

//Collection names for Firebase Firestore DB
const String kUserCollections = 'userCollections';
const String kUserPlants = 'userPlants';
const String kUserGroups = 'userGroups';
const String kUserConnections = 'userConnections';
const String kUserRequests = 'userRequests';

//Firebase Cloud Storage Folders
const String kFolderUsers = 'users';
const String kFolderPlants = 'plants';
const String kFolderImages = 'images';
const String kFolderThumbnail = 'thumbnail';
const String kFolderSettings = 'settings';
//db stored in local path

//Message Keys
const String kMessageSender = 'messageSender';
const String kMessageTime = 'messageTime';
const String kMessageText = 'messageText';
const String kMessageRead = 'messageRead';

//User Keys
const String kUserID = 'userID';
const String kUserName = 'userName';
const String kUserEmail = 'userEmail';
const String kUserAvatar = 'userAvatar';
const String kUserBackground = 'userBackground';
const String kUserTotalPlants = 'userTotalPlants';
const String kUserTotalCollections = 'userTotalCollections';
const String kUserTotalGroups = 'userTotalGroups';
//const String kUserRequestsList = 'userRequests';
//const String kUserConnectionsList = 'userConnections';

//User Key Descriptors
const String kUserIDDescription = 'ID';
const String kUserNameDescription = 'Name';
const String kUserEmailDescription = 'Email';
const String kUserAvatarDescription = 'Avatar';
const String kUserBackgroundDescription = 'Background';
const String kUserTotalPlantsDescription = 'Total Plants';
const String kUserTotalCollectionsDescription = 'Total Collections';
const String kUserTotalGroupsDescription = 'Total Groups';
//const String kUserRequestsListDescription = 'Connection Requests';
//const String kUserConnectionsListDescription = 'Connections';

//User Key Descriptors Map
final Map<String, String> kUserKeyDescriptorsMap = {
  kUserID: kUserIDDescription,
  kUserName: kUserNameDescription,
  kUserEmail: kUserEmailDescription,
  kUserAvatar: kUserAvatarDescription,
  kUserBackground: kUserBackgroundDescription,
  kUserTotalPlants: kUserTotalPlantsDescription,
  kUserTotalCollections: kUserTotalCollectionsDescription,
  kUserTotalGroups: kUserTotalGroupsDescription,
//  kUserRequestsList: kUserRequestsListDescription,
//  kUserConnectionsList: kUserConnectionsListDescription,
};

//Connection
const String kConnectionID = 'connectionID';
const String kConnectionShare = 'connectionShare';
const String kConnectionChat = 'connectionChat';

//Group
const String kGroupID = 'groupID';
const String kGroupName = 'groupName';
const String kGroupCollectionList = 'groupCollectionList';
const String kGroupOrder = 'groupOrder';
const String kGroupColor = 'groupColor';

//Collection
const String kCollectionID = 'collectionID';
const String kCollectionName = 'collectionName';
const String kCollectionPlantList = 'collectionPlantList';
const String kCollectionCreatorID = 'collectionCreatorID';

//Plant Keys
const String kPlantID = 'plantID';
const String kPlantName = 'plantName';
const String kPlantVariety = 'plantVariety';
const String kPlantGenus = 'plantGenus';
const String kPlantSpecies = 'plantSpecies';
const String kPlantQuantity = 'plantQuantity';
const String kPlantNotes = 'plantNotes';
const String kPlantThumbnail = 'plantThumbnail';
const String kPlantImageList = 'plantImageList';

//Plant Key Descriptors
const String kPlantIDDescription = 'Plant Library ID';
const String kPlantNameDescription = 'Display Name';
const String kPlantVarietyDescription = 'Cultivar/Variety';
const String kPlantGenusDescription = 'Genus';
const String kPlantSpeciesDescription = 'Species';
const String kPlantQuantityDescription = 'Quantity';
const String kPlantNotesDescription = 'Notes';
const String kPlantThumbnailDescription = 'Thumbnail';
const String kPlantImageListDescription = 'Image Files';

//Plant Key Descriptors Map
final Map<String, String> kPlantKeyDescriptorsMap = {
  kPlantID: kPlantIDDescription,
  kPlantName: kPlantNameDescription,
  kPlantVariety: kPlantVarietyDescription,
  kPlantSpecies: kPlantSpeciesDescription,
  kPlantGenus: kPlantGenusDescription,
  kPlantQuantity: kPlantQuantityDescription,
  kPlantNotes: kPlantNotesDescription,
  kPlantThumbnail: kPlantThumbnailDescription,
  kPlantImageList: kPlantImageListDescription,
};
