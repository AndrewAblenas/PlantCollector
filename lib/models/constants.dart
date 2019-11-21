//Application Constants

//Collection names for Firebase DB
const String kUserCollections = 'userCollections';
const String kUserPlants = 'userPlants';
const String kUserGroups = 'userGroups';

//Firebase Storage Folders
const String kFolderUsers = 'users';
const String kFolderPlants = 'plants';
const String kFolderImages = 'images';
const String kFolderThumbnail = 'thumbnail';
const String kFolderSettings = 'settings';
//db stored in local path

//User Keys
const String kUserID = 'userID';
const String kUserFirstName = 'userFirstName';
const String kUserLastName = 'userLastName';
const String kUserEmail = 'userEmail';

//User Key Descriptors
const String kUserIDDescription = 'ID';
const String kUserFirstNameDescription = 'Name';
const String kUserLastNameDescription = 'Surname';
const String kUserEmailDescription = 'Email';

//User Key Descriptors Map
final Map<String, String> kUserKeyDescriptorsMap = {
  kUserID: kUserIDDescription,
  kUserFirstName: kUserFirstNameDescription,
  kUserLastName: kUserLastNameDescription,
  kUserEmail: kUserEmailDescription,
};

//Set
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
  kPlantGenus: kPlantGenusDescription,
  kPlantSpecies: kPlantSpeciesDescription,
  kPlantQuantity: kPlantQuantityDescription,
  kPlantNotes: kPlantNotesDescription,
  kPlantThumbnail: kPlantThumbnailDescription,
  kPlantImageList: kPlantImageListDescription,
};
