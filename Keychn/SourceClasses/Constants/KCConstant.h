//
//  KCConstants.h
//  Keychn
//
//  Created by Keychn Experience SL on 03/12/15.
//  Copyright © 2015 Keychn Experience SL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KCConstant : NSObject

#define ShowNetworkActivityIndicator() [UIApplication sharedApplication].networkActivityIndicatorVisible = YES
#define HideNetworkActivityIndicator() [UIApplication sharedApplication].networkActivityIndicatorVisible = NO


#define DEVICE_UDID [[[UIDevice currentDevice] identifierForVendor] UUIDString]
#define IOS_DEVICE @"iOS"
#define MAIN_STORYBOARD [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]]

#define kAllotedTimeForUser 300.0f // Represented in seconds
#define kBufferTimeForCallStart 120 // In Seconds

#define  kAgoraKeychnAppIdentifier  @"b1cfa30e21144fc096082839799e2ecb"
#define kMasterclassDateFormat @"yyyy-MM-dd HH:mm:ss"
#define kAppName  @"Keychn"
#define kAppsFlyerDeveloperKey @"qaZ65fUcrUzSWKRGrvvk6F"
#define kAppleAppIdForKeychn   @"1133885987"
#define kMixPanelToken         @"52b17c126ae6a6d4ed209a7543b64091"

/**
 @abstract Get shared instance of the constant class
 @param No Parameter
 @return instance type
*/
+ (instancetype) sharedInstance;

typedef NS_ENUM(NSUInteger, BorderPostition) {
    topBorder,
    bottomBorder
};

typedef NS_ENUM(NSUInteger,IOSDevices) {
    iPhone4,
    iPhone5,
    iPhone6,
    iPhone6Plus,
    iPhoneX,
    iPad
};

typedef NS_ENUM(NSUInteger, IOSVersion) {
    iOS7,
    iOS8,
    iOS9,
};

typedef NS_ENUM(NSUInteger, ResponseType) {
    local,
    server
};

typedef NS_ENUM(NSUInteger,DaysName) {
    sunday,
    monday,
    tuesday,
    wednesday,
    thursday,
    friday,
    saturday
};

typedef NS_ENUM(NSUInteger,ShiftName) {
  breakfast,
    lunch,
    dinner
};

typedef NS_ENUM(NSUInteger,TimeSlots) {
    timeSlot1,
    timeSlot2,
    timeSlot3,
    timeSlot4
};

typedef NS_ENUM(NSUInteger, RecipeType) {
    freeRide,
    menus,
    chewIt,
    chewItSession,
    masterClass,
    directCall
};

typedef NS_ENUM(NSUInteger, FreeRideType) {
    now,
    scheduled,
    closePopUp,
};

typedef NS_ENUM(NSUInteger, SettingSection1) {
    restoreInAppPurchase,
    changePassword,
    aboutUs,
    languages
};

typedef NS_ENUM(NSUInteger, SettingSection2) {
    contactUs,
    privacy
};

typedef NS_ENUM(NSUInteger, KeychnPointInAppPurchase) {
    hundredPoints,
    twoThirtyPoints,
    threeFiftyPoints,
    fourEightyPoints,
    sixHundredPoints,
    noSelection
};

typedef NS_ENUM(NSUInteger,TabIndex) {
    Home,
    Recipes,
    MySchedule,
    Profile
};


#pragma mark - Database Constants

#define DATABASE_FILE_NAME           @"keychn"
#define DATABASE_FILE_EXTENTION      @"sqlite"
#define KEYCHN_DATABASE_FILE         @"keychn.sqlite"
#define DATABASE_DIRECTORY_NAME      @"Library/Database"


enum cellIndexEmailSignUp {
    cellIndexEmailSignUpName,
    cellIndexEmailSignUpEmail,
    cellIndexEmailSignUpPassword,
    cellIndexEmailSignUpConfirmPassword,
    cellIndexEmailSignUpReceiveNewsletter,
    cellIndexEmailSignUpSignUpButton,
    cellIndexEmailSignUpTermsOfUse
    
};

enum cellIndexEmailSigIn {
    cellIndexEmailSignInEmail,
    cellIndexEmailSignInPassword,
    cellIndexEmailSigInButton
};

typedef NS_ENUM(NSUInteger, ActionSheetCameraRollButtonIndex) {
    actionSheetCameraRollCamera,
    actionSheetCameraRollGallery
};

extern BOOL         isNetworkReachable;
extern NSNumber     *defaultLanguage;

#define KEYCHN_POINT_DENOMINATION_ARRAY @[@"9.99", @"19.99", @"29.99", @"39.99", @"49.99"]
#define KEYCHN_POINT_ARRAY              @[@"100", @"230", @"350", @"480", @"600"]
#define INAPP_PURCHASE_PRODUCT_ID_ARRAY @[@"com.chrome.keychn.100pts", @"com.chrome.keychn.230pts", @"com.chrome.keychn.350pts", @"com.chrome.keychn.480pts", @"com.chrome.keychn.600pts"]
#define kInAppPurchaseSusbcriptionArray @[@"com.keychn.monthly", @"com.keychn.yearly"]


#pragma mark - Notification Identifier

extern NSString *beforeMasteclass;
extern NSString *joinMasteclass;
extern NSString *joinActionIdentifier;
extern NSString *joinActionCategory;

#pragma mark - URLs and Actions

extern NSString  *baseURL;
extern NSString  *aboutUsURL;
extern NSString  *privacyPolicyURL;
extern NSString  *termsOfUsePolicy;
extern NSString  *emailSignUpAction;
extern NSString  *languageListAction;
extern NSString  *socialSignUpAction;
extern NSString  *mergeSocialAccountAction;
extern NSString  *getAppLabelAction;
extern NSString  *setProfileImageAction;
extern NSString  *setLanguagePreferenceAction;
extern NSString  *userLoginAction;
extern NSString  *forgotPasswordAction;
extern NSString  *getMenuListAction;
extern NSString  *getItemsListAction;
extern NSString  *addItemToFavoriteAction;
extern NSString  *getPlaceHolderImagesAction;
extern NSString  *scheduleACallAction;
extern NSString  *getUserSchedulesAction;
extern NSString  *getMySchedulesAction;
extern NSString  *verifyNotificationAction;
extern NSString  *scheduleACallNowAction;
extern NSString  *closeConferenceAction;
extern NSString  *reconnectUserAction;
extern NSString  *cancelNowScheduleAction;
extern NSString  *flagAUserAction;
extern NSString  *shareImageAction;
extern NSString  *rateAnItemAction;
extern NSString  *freeRideScheduleNowAction;
extern NSString  *friendScheduleFreeRideNow;
extern NSString  *friendScheduleRecipeNow;
extern NSString  *directCallScheduleNow;
extern NSString  *friendScheduleRecipeLater;
extern NSString  *friendScheduleFreeRideLater;
extern NSString  *freeRideScheduleLaterAction;
extern NSString  *saveFreeRideDetailAction;
extern NSString  *fetchMyPreferencesAction;
extern NSString  *getRecentRecipesAction;
extern NSString  *updatePasswordAction;
extern NSString  *updateSocialAccountAction;
extern NSString  *linkFacebookAccountAction;
extern NSString  *logOutUserAction;
extern NSString  *submitAQueryAction;
extern NSString  *getTutorialsAction;
extern NSString  *getUserDataAction;
extern NSString  *masterClassAndCallsAction;
extern NSString  *masterClassAction;
extern NSString  *scheduleACallWithUserAction;
extern NSString  *getMasterClassDetailAction;
extern NSString  *bookAMasterClassSpotAction;
extern NSString  *saveChewItRatingAction;
extern NSString  *cancelUserScheduleAction;
extern NSString  *searchItemAction;
extern NSString  *searchStarcookAction;
extern NSString  *acceptDenyRequestAction;
extern NSString  *sendFriendRequestAction;
extern NSString  *blockRemoveUserAction;
extern NSString  *getUserFriendAction;
extern NSString  *getPendingRequest;
extern NSString  *sendTextMessageAction;
extern NSString  *getTextMessageHistoryAction;
extern NSString  *markMessagesAsReadAction;
extern NSString  *connetVideoCallAction;
extern NSString  *completGroupSessionAction;
extern NSString  *updateGroupSessoinLog;
extern NSString  *updateKeychPointAction;
extern NSString  *updateSubscriptionAction;
extern NSString  *getParcipantNamesAction;
extern NSString  *updatePushNotification;


#pragma mark - Server Keys

extern NSString  *kName;
extern NSString  *kEmailID;
extern NSString  *kPassword;
extern NSString  *kAcessToken;
extern NSString  *kImageURL;
extern NSString  *kVideoURL;
extern NSString  *kLocation;
extern NSString  *kLanguageID;
extern NSString  *kIsActive;
extern NSString  *kUserType;
extern NSString  *kReceiveNewsletter;
extern NSString  *kLanguageDetails;
extern NSString  *kIdentifier;
extern NSString  *kUserIdentity;
extern NSString  *kUsername;
extern NSString  *kNewsletterPrefs;
extern NSString  *kUserID;
extern NSString  *kSearchKeyword;
extern NSString  *kSenderID;
extern NSString  *kReceiverID;
extern NSString  *kOtherUsername;
extern NSString  *kOtherUserID;
extern NSString  *kFlagImageURL;
extern NSString  *kSuccessCode;
extern NSString  *kErrorCode;
extern NSString  *kErrorDetails;
extern NSString  *socialMergeOptions;
extern NSString  *kItemTitle;
extern NSString  *kTitle;
extern NSString  *kMessage;
extern NSString  *kQueryDescription;
extern NSString  *kTextMessage;
extern NSString  *kMessageDate;
extern NSString  *kStart;
extern NSString  *kEnd;
extern NSString  *kErrorType;
extern NSString  *kStatus;
extern NSString  *kUpdateType;
extern NSString  *kOpenStatus;
extern NSString  *kUserDetails;
extern NSString  *kAppUsers;
extern NSString  *kSubscriptionPurhcase;
extern NSString  *kSocialAccount;
extern NSString  *kFacebook;
extern NSString  *kTwitter;
extern NSString  *kSocialAccountType;
extern NSString  *kSocialID;
extern NSString  *kAppLanguage;
extern NSString  *kSpeakingLanguage;
extern NSString  *kLabelList;
extern NSString  *kSupportedLanguageID;
extern NSString  *kLabelName;
extern NSString  *kImageURLiPad;
extern NSString  *kImageURLiPhone;
extern NSString  *kSmallImageURLiPad;
extern NSString  *kSmallImageURLiPhone;
extern NSString  *kFreeRideImageiPad;
extern NSString  *kFreeRideImageiPhone;
extern NSString  *kLanguagePreference;
extern NSString  *kDateCreated;
extern NSString  *kMenuDetails;
extern NSString  *kItemDetails;
extern NSString  *kItemName;
extern NSString  *kSessionExpiredError;
extern NSString  *kPageIndex;
extern NSString  *kParticipant;
extern NSString  *kTotalPages;
extern NSString  *kMenuID;
extern NSString  *kCourseID;
extern NSString  *kCourseList;
extern NSString  *kItemID;
extern NSString  *kEventId;
extern NSString  *kMenuImageIPhone;
extern NSString  *kMenuImageIPad;
extern NSString  *kIsScheduled;
extern NSString  *kAppVersionNumber;
extern NSString  *kRecipeVisibility;
extern NSString  *kServings;
extern NSString  *kStepPosition;
extern NSString  *kDifficulty;
extern NSString  *kDuration;
extern NSString  *kRecipeSteps;
extern NSString  *kIngredients;
extern NSString  *kItemRatings;
extern NSString  *kPopUpDuration;
extern NSString  *kLikeCounter;
extern NSString  *kCookedCounter;
extern NSString  *kIsFavorite;
extern NSString  *kPlaceholderImages;
extern NSString  *kMenuPreferences;
extern NSString  *kCoursePreferences;
extern NSString  *kScheduleDate;
extern NSString  *kScheduleOnDate;
extern NSString  *kScheduleTime;
extern NSString  *kScheduleType;
extern NSString  *kRecipeSchedule;
extern NSString  *kRecipeNowSchedule;
extern NSString  *kFreeRideSchedule;
extern NSString  *kFreeRideNowSchedule;
extern NSString  *kEatLaterSchedule;
extern NSString  *kUserMessageNotification;
extern NSString  *kUserFriendNotification;
extern NSString  *kEatNowSchedule;
extern NSString  *kUserSchedule;
extern NSString  *kSchedules;
extern NSString  *kUserMatchNotification;
extern NSString  *kDeviceID;
extern NSString  *kDeviceToken;
extern NSString  *kDeviceType;
extern NSString  *kNotificationType;
extern NSString  *kIncomingCall;
extern NSString  *kReminderNotification;
extern NSString  *kCallDenied;
extern NSString  *kUserBusy;
extern NSString  *kConferenceID;
extern NSString  *kUnreadCount;
extern NSString  *kVoIPToken;
extern NSString  *kNotificationStatus;
extern NSString  *kNotifType;
extern NSString  *kNotificationStatus;
extern NSString  *kMatchDetails;
extern NSString  *kMatchStatus;
extern NSString  *kBusyStatus;
extern NSString  *kUserMatched;
extern NSString  *kUserNotMatched;
extern NSString  *kConferenceCompleted;
extern NSString  *kConferenceCancelled;
extern NSString  *kRequestType;
extern NSString  *kNewRequest;
extern NSString  *kRefreshRequest;
extern NSString  *kScheduleID;
extern NSString  *kReportedUserID;
extern NSString  *kFlaggedUserID;
extern NSString  *kRating;
extern NSString  *kAPIAction;
extern NSString  *kCurrentDate;
extern NSString  *kCurrentDateAndTime;
extern BOOL      isComingCall;
extern NSString  *kCredit;
extern NSString  *kDishofTheWeek;
extern NSString  *kFavorite;
extern NSString  *kInteraction;
extern NSString  *kStarCook;
extern NSString  *kCookedDetails;
extern NSString  *kCurrentPassword;
extern NSString  *kUserSpeakingLanguage;
extern NSString  *kTutorialDetails;
extern NSString  *kShouldFetchDetailedData;
extern NSString  *kMySchedules;
extern NSString  *kChopChop;
extern NSString  *kMasterClass;
extern NSString  *kGSTypeMasterClass;
extern NSString  *kMasterClassID;
extern NSString  *kMasterClassStatus;
extern NSString  *kMasterClassType;
extern NSString  *kMasterChefName;
extern NSString  *kScheuledOn;
extern NSString  *kTotalInteraction;
extern NSString  *kMasterClassDetail;
extern NSString  *kAboutUser;
extern NSString  *kIsBooked;
extern NSString  *kIsFull;
extern NSString  *kIsSelected;
extern NSString  *kFacebookLink;
extern NSString  *kInstagramLink;
extern NSString  *kTwitterLink;
extern NSString  *kWebsiteLink;
extern NSString  *kVideoPlaceholderiPad;
extern NSString  *kVideoPlaceholderiPhone;
extern NSString  *kIsRescheduling;
extern NSString  *kChewIt;
extern NSString  *kChewItSession;
extern NSString  *kShareURL;
extern NSString  *kAmount;
extern NSString  *kMasterClassAmount;
extern NSString  *kChewItSessionAmount;
extern NSString  *kGroupSession;
extern NSString  *kGroupSessionType;
extern NSString  *kCancelTypeGroupSession;
extern NSString  *kCancelTypeUserSchedule;
extern NSString  *kIsScheduleOpen;
extern NSString  *kSearchString;
extern NSString  *kText;
extern NSString  *kTimestamp;
extern NSString  *kIngredientDetails;
extern NSString  *kItemLabel;
extern NSString  *kSearchDetails;
extern NSString  *kPendingRequest;
extern NSString  *kFriendList;
extern NSString  *kIsAccpetingRequest;
extern NSString  *kIsRemovingFriend;
extern NSString  *kFriendID;
extern NSString  *freeRideLabel;
extern NSString  *chewItLabel;
extern NSString  *masterClassLabel;
extern NSString  *chewItSessionLabel;
extern NSString  *kMessageID;
extern NSString  *kChatDetails;
extern NSString  *kBadgeCount;
extern NSString  *kFirstScheduleID;
extern NSString  *kSessionHost;
extern NSString  *kSessionGuest;
extern NSString  *kIsHosting;
extern NSString  *kSessionID;
extern NSString  *kGroupSessionID;
extern NSString  *kAppUser;
extern NSString  *kMasterChef;
extern NSString  *kBlogger;
extern NSString  *kUserMessageUpdated;
extern NSString  *kFirstUserID;
extern NSString   *kIsPresented;
extern NSString   *kResult;

#pragma mark - Storyboard Identifiers

extern NSString  *signUpViewController;
extern NSString  *emailSignUpViewController;
extern NSString  *emailLoginViewController;
extern NSString  *forgotPasswordViewController;
extern NSString  *setProfilePhotoViewController;
extern NSString  *selectLangugeViewController;
extern NSString  *segmentNavigationController;
extern NSString  *menuViewController;
extern NSString  *myScheduleViewController;
extern NSString  *searchViewController;
extern NSString  *settingViewController;
extern NSString  *appWebViewController;
extern NSString  *rootViewController;
extern NSString  *itemListViewController;
extern NSString  *itemDetailsViewController;
extern NSString  *getItemDetailsAction;
extern NSString  *userScheduleViewController;
extern NSString  *slotScheduleViewController;
extern NSString  *liveVideoCallController;
extern NSString  *searchStarCookViewController;
extern NSString  *incomingCallViewController;
extern NSString  *callDisconnectViewController;
extern NSString  *shareImageViewController;
extern NSString  *chooseTypeViewController;
extern NSString  *myPreferenceViewController;
extern NSString  *changePasswordViewController;
extern NSString  *contacUsViewController;
extern NSString  *tutorialViewController;
extern NSString  *masterClassViewController;
extern NSString  *soloCookingViewController;
extern NSString  *chewItSessionViewController;
extern NSString  *starCookViewController;
extern NSString  *searchFriendViewController;
extern NSString  *pendingRequestViewController;
extern NSString  *textChatViewController;
extern NSString  *hostEndSessionViewController;
extern NSString  *guestEndSessionViewController;
extern NSString  *imageDisplayViewController;
extern NSString  *kHomeViewController;
extern NSString  *kCookViewController;
extern NSString  *kOnBoardViewController;

#pragma mark - Table Cell Identifiers

extern NSString  *cellIdentifierEmailSignUpTextFields;
extern NSString  *cellIdentifierForEmailSignUpReveiveNewsletter;
extern NSString  *cellIdentifierForEmailSignUpSignUpButton;
extern NSString  *cellIdentifierForEmailSignInTextField;
extern NSString  *cellIdentifierForEmailSignInButton;
extern NSString  *cellIdentifierForSettingWebLinks;
extern NSString  *cellIdentifierForSettingSocialAccount;
extern NSString  *cellIdentifierForMainMenu;
extern NSString  *cellIdentifierForItemList;
extern NSString  *cellIdentifierForItemDetails;
extern NSString  *cellIdentifierForItemIngredients;
extern NSString  *cellIdentifierForItemIngredientCount;
extern NSString  *cellIdentifierForItemRecipeStep;
extern NSString  *cellIdentifierForUserDaySchedule;
extern NSString  *cellIdentifierForUserSlotSchedule;
extern NSString  *cellIdentifierForMySchedule;
extern NSString  *cellIdentifierForChangePassword;
extern NSString  *cellIdentifierForMasterClass;
extern NSString  *cellIdentifierForTutorial;
extern NSString  *cellIdentiferForStarCook;
extern NSString  *cellIdentifierForIncomingMessage;
extern NSString  *cellIdentifierForOutgoingMessage;
extern NSString  *cellIdentifierForIncomingImage;
extern NSString  *cellIdentifierForOutgoingImage;
extern NSString  *cellIdentifierForMasterClassList;




#pragma mark - Collection View Cell Identifier

extern NSString *cellIdentifierForLeftItem;
extern NSString *cellIdentifierForRecipeItem;
extern NSString *cellIdentifierForRightItem;
extern NSString *cellIdentifierForSectionHeader;
extern NSString *cellIdentifierForNoSearchResult;
extern NSString  *cellIdentifierMenusCollectioView;
extern NSString  *cellIdentifierHomeItemCollection;
extern NSString  *cellIdentifierForOnboardCollection;

#pragma mark - Splash Constants

extern NSString *appName;
extern float    splashDelayInSeconds;

#pragma mark- Device Token
extern NSString *keychnDeviceToken;
extern NSString *keychnVoIPToken;
extern bool     shouldJoinConference;
extern NSInteger DataStreamIndentifier;

#pragma mark - Notification 

extern NSString *kApsDictionary;
extern NSString *kAlertTitle;
extern NSString *kAlertMessage;

@end
