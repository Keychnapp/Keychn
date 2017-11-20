//
//  KCConstants.m
//  Keychn
//
//  Created by Keychn Experience SL on 03/12/15.
//  Copyright © 2015 Keychn Experience SL. All rights reserved.
//

#import "KCConstant.h"

@implementation KCConstant

+ (instancetype)sharedInstance {
    static KCConstant *kcConstant = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kcConstant = [[KCConstant alloc] init];
    });
    return kcConstant;
}

BOOL isNetworkReachable = NO;
NSNumber     *defaultLanguage;

#pragma mark - Notification Identifier

NSString *beforeMasteclass      = @"MinutesBeforeMasterclass";
NSString *joinMasteclass        = @"JoinMasterclass";
NSString *joinActionIdentifier  = @"JoinAction";
NSString *joinActionCategory    = @"JoinActionCategory";


#pragma mark - URLs and Actions

//NSString  *baseURL                    = @"http://52.24.88.32/"; // Live Server
NSString  *baseURL                    = @"http://api.keychn.com/"; // Live Server
// NSString  *baseURL                    = @"http://34.213.209.52/"; // Development Server
NSString  *aboutUsURL                 = @"http://keychn.com/terms.html";
NSString  *privacyPolicyURL           = @"http://keychn.com/privacy.html";
NSString  *termsOfUsePolicy           = @"http://keychn.com/terms.html";
NSString  *emailSignUpAction          = @"userapis/signup_with_email";
NSString  *languageListAction         = @"listapis/getLanguages";
NSString  *socialSignUpAction         = @"userapis/signup_with_social";
NSString  *mergeSocialAccountAction   = @"userapis/signup_with_social_merge";
NSString  *getAppLabelAction          = @"listapis/getLabelsByLanguage";
NSString  *setProfileImageAction      = @"userapis/user_profile_photo_upload";
NSString  *setLanguagePreferenceAction = @"userapis/user_language_update";
NSString  *userLoginAction             = @"userapis/user_login";
NSString  *forgotPasswordAction        = @"userapis/forgot_password";
NSString  *getMenuListAction           = @"listapis/getMenus";
NSString  *getItemsListAction          = @"listapis/getItemsList";
NSString  *getItemDetailsAction        = @"listapis/itemDetails";
NSString  *addItemToFavoriteAction     = @"listapis/addItemToFavorite";
NSString  *getPlaceHolderImagesAction  = @"getPlaceholderImages";
NSString  *scheduleACallAction         = @"listapis/scheduleACall";
NSString  *getUserSchedulesAction      = @"listapis/getAllSchedules";
NSString  *getMySchedulesAction        = @"listapis/getMySchedules";
NSString  *verifyNotificationAction    = @"videoapis/verifyNotification";
NSString  *scheduleACallNowAction      = @"videoapis/scheduleACallNow";
NSString  *closeConferenceAction       = @"videoapis/reconnectUpdateStatus";
NSString  *reconnectUserAction         = @"videoapis/reconnectUsers";
NSString  *cancelNowScheduleAction     = @"videoapis/userCancelledCall";
NSString  *flagAUserAction             = @"listapis/flaggedAUser";
NSString  *shareImageAction            = @"listapis/uploadCookedRecipe";
NSString  *rateAnItemAction            = @"listapis/saveItemRating";
NSString  *freeRideScheduleNowAction   = @"free_rideapis/scheduleACallNow";
NSString  *friendScheduleFreeRideNow   = @"free_rideapis/scheduleACallFriendNow";
NSString  *friendScheduleRecipeNow     = @"videoapis/scheduleACallFriendNow";
NSString  *directCallScheduleNow       = @"videoapis/scheduleACallNowHome";
NSString  *friendScheduleRecipeLater   = @"listapis/scheduleACallFriend";
NSString  *friendScheduleFreeRideLater = @"free_rideapis/scheduleACallFriend";
NSString  *freeRideScheduleLaterAction = @"free_rideapis/scheduleACall";
NSString  *saveFreeRideDetailAction    = @"free_rideapis/saveFreerideRating";
NSString  *fetchMyPreferencesAction    = @"listapis/getStarInteractionFavoriteDishWeek";
NSString  *getRecentRecipesAction      = @"listapis/recentCookedRecipesByUser";
NSString  *updatePasswordAction        = @"userapis/reset_password";
NSString  *updateSocialAccountAction   = @"userapis/activeDeactiveSocialAccount";
NSString  *linkFacebookAccountAction   = @"userapis/link_social_account";
NSString  *logOutUserAction            = @"userapis/logout";
NSString  *submitAQueryAction          = @"listapis/submitUserQuery";
NSString  *getTutorialsAction          = @"listapis/getTutorials";
NSString  *getUserDataAction           = @"listapis/userInteraction";
NSString  *masterClassAndCallsAction   = @"listapis/masterClassScheduleList";
NSString  *masterClassAction           = @"userapis/getMasterClassList";
NSString  *scheduleACallWithUserAction = @"listapis/bookASchedule";
NSString  *getMasterClassDetailAction  = @"listapis/getMasterClassDetails";
NSString  *bookAMasterClassSpotAction  = @"userapis/bookMasterClass";
NSString  *saveChewItRatingAction      = @"free_rideapis/saveChewItRating";
NSString  *cancelUserScheduleAction    = @"listapis/cancelMasterClass";
NSString  *searchItemAction            = @"listapis/userSearch";
NSString  *searchStarcookAction        = @"listapis/userSearchForFriend";
NSString  *acceptDenyRequestAction     = @"listapis/acceptDenyFriendRequest";
NSString  *sendFriendRequestAction     = @"listapis/sendFriendRequest";
NSString  *blockRemoveUserAction       = @"listapis/removeBlockUser";
NSString  *getUserFriendAction         = @"listapis/getFriends";
NSString  *getPendingRequest           = @"listapis/getFriendshipRequest";
NSString  *sendTextMessageAction       = @"listapis/addUserChat";
NSString  *getTextMessageHistoryAction = @"listapis/getUserChat";
NSString  *markMessagesAsReadAction    = @"listapis/markReadMessages";
NSString  *connetVideoCallAction       = @"videoapis/scheduledACallLaterConnect";
NSString  *completGroupSessionAction   = @"listapis/markGroupSessionComplete";
NSString  *updateGroupSessoinLog       = @"listapis/saveGroupSessionLog";
NSString  *updateKeychPointAction      = @"listapis/addUserCredit";
NSString  *updateSubscriptionAction    = @"userapis/updateUserSubscription";
NSString  *getParcipantNamesAction     = @"listapis/allGroupParticipants";
NSString  *updatePushNotification      = @"userapis/updateToken";

#pragma mark - Server Keys

NSString  *kName                     = @"name";
NSString  *kEmailID                  = @"email_id";
NSString  *kAcessToken               = @"access_token";
NSString  *kImageURL                 = @"image_url";
NSString  *kVideoURL                 = @"video_url";
NSString  *kLocation                 = @"location";
NSString  *kPassword                 = @"password";
NSString  *kReceiveNewsletter        = @"receive_newsletter";
NSString  *kLanguageID               = @"language_id";
NSString  *kIsActive                 = @"is_active";
NSString  *kUserType                 = @"user_type";
NSString  *kLanguageDetails          = @"language_details";
NSString  *kIdentifier               = @"id";
NSString  *kUserIdentity             = @"identity";
NSString  *kUsername                 = @"username";
NSString  *kNewsletterPrefs          = @"newsletter_preference";
NSString  *kUserID                   = @"user_id";
NSString  *kSearchKeyword            = @"keyword";
NSString  *kSenderID                 = @"sender_id";
NSString  *kReceiverID               = @"receiver_id";
NSString  *kOtherUsername            = @"second_user_name";
NSString  *kOtherUserID              = @"second_user_id";
NSString  *kFlagImageURL             = @"flag_image_url";
NSString  *kSuccessCode              = @"success";
NSString  *kErrorCode                = @"error";
NSString  *kErrorDetails             = @"error_details";
NSString  *socialMergeOptions        = @"Social Merge";
NSString  *kItemTitle                 = @"title";
NSString  *kTitle                    = @"error_title";
NSString  *kMessage                  = @"error_message";
NSString  *kQueryDescription         = @"message";
NSString  *kTextMessage              = @"message";
NSString  *kMessageDate              = @"message_date";
NSString  *kErrorType                = @"error_type";
NSString  *kStart                    = @"start";
NSString  *kEnd                      = @"end";
NSString  *kStatus                   = @"status";
NSString  *kUpdateType               = @"type";
NSString  *kOpenStatus               = @"open";
NSString  *kUserDetails              = @"user_details";
NSString  *kAppUsers                 = @"app_users";
NSString  *kSubscriptionPurhcase     = @"plan_info";
NSString  *kSocialAccount            = @"user_social_accounts";
NSString  *kFacebook                 = @"facebook";
NSString  *kTwitter                  = @"twitter";
NSString  *kSocialAccountType        = @"acc_type";
NSString  *kSocialID                 = @"social_id";
NSString  *kAppLanguage              = @"app_language";
NSString  *kSpeakingLanguage         = @"speaking_language";
NSString  *kLabelList                = @"label_list";
NSString  *kSupportedLanguageID      = @"supported_language_id";
NSString  *kLabelName                = @"label_name";
NSString  *kImageURLiPad             = @"image_url_ipad";
NSString  *kImageURLiPhone           = @"image_url_iphone";
NSString  *kSmallImageURLiPad        = @"small_image_url_ipad";
NSString  *kSmallImageURLiPhone      = @"small_image_url_iphone";
NSString  *kFreeRideImageiPad        = @"freeride_image_ipad";
NSString  *kFreeRideImageiPhone      = @"freeride_image_iphone";
NSString  *kLanguagePreference       = @"language_preference";
NSString  *kDateCreated              = @"created";
NSString  *kMenuDetails              = @"menu_details";
NSString  *kItemDetails              = @"item_details";
NSString  *kItemName                 = @"item_name";
NSString  *kSessionExpiredError      = @"session expired";
NSString  *kPageIndex                = @"page_index";
NSString  *kParticipant              = @"participant";
NSString  *kTotalPages               = @"page_total";
NSString  *kMenuID                   = @"menu_id";
NSString  *kCourseID                 = @"course_id";
NSString  *kCourseList               = @"course_list";
NSString  *kItemID                   = @"item_id";
NSString  *kEventId                  = @"event_id";
NSString  *kMenuImageIPhone          = @"menu_image_iphone";
NSString  *kMenuImageIPad            = @"menu_image_ipad";
NSString  *kIsScheduled              = @"is_scheduled";
NSString  *kAppVersionNumber         = @"app_verion";
NSString  *kRecipeVisibility         = @"recipe_visibility";
NSString  *kServings                 = @"servings";
NSString  *kStepPosition             = @"step_position";
NSString  *kDifficulty               = @"difficulty";
NSString  *kDuration                 = @"duration";
NSString  *kRecipeSteps              = @"recipe_steps";
NSString  *kIngredients              = @"ingredients";
NSString  *kItemRatings              = @"rating";
NSString  *kPopUpDuration            = @"now_schedule_popup";
NSString  *kLikeCounter              = @"favorite";
NSString  *kCookedCounter            = @"cooked_counter";
NSString  *kIsFavorite               = @"is_favorite";
NSString  *kPlaceholderImages        = @"placeholder_images";
NSString  *kMenuPreferences          = @"menu_preference";
NSString  *kCoursePreferences        = @"course_preference";
NSString  *kScheduleDate             = @"schedule_date";
NSString  *kScheduleOnDate           = @"scheduled_on";
NSString  *kScheduleTime             = @"schedule_time";
NSString  *kScheduleType             = @"schedule_type";
NSString  *kRecipeSchedule           = @"recipe";
NSString  *kRecipeNowSchedule        = @"nowrecipe";
NSString  *kFreeRideSchedule         = @"freeride_scheduled";
NSString  *kFreeRideNowSchedule      = @"freeride";
NSString  *kEatLaterSchedule         = @"eat_later";
NSString  *kEatNowSchedule           = @"eat_now";
NSString  *kUserSchedule             = @"user_schedules";
NSString  *kSchedules                = @"schedules";
NSString  *kUserMatchNotification    = @"user_schedule";
NSString  *kUserMessageNotification  = @"user_message";
NSString  *kUserFriendNotification   = @"user_friend";
NSString  *kDeviceID                 = @"device_id";
NSString  *kDeviceToken              = @"device_token";
NSString  *kDeviceType               = @"device_type";
NSString  *kNotificationType         = @"message_type";
NSString  *kIncomingCall             = @"incoming";
NSString  *kReminderNotification     = @"reminder";
NSString  *kCallDenied               = @"call_denied";
NSString  *kUserBusy                 = @"user_busy";
NSString  *kConferenceID             = @"conference_id";
NSString  *kUnreadCount              = @"unread_count";
NSString  *kVoIPToken                = @"voip_device_token";
NSString  *kNotificationStatus       = @"notification_status";
NSString  *kNotifType                = @"notification_type";
NSString  *kMatchDetails             = @"match_details";
NSString  *kMatchStatus              = @"match_status";
NSString  *kBusyStatus               = @"busy_status";
NSString  *kUserMatched              = @"matched";
NSString  *kUserNotMatched           = @"nomatched";
NSString  *kConferenceCompleted      = @"completed";
NSString  *kConferenceCancelled      = @"cancelled";
NSString  *kRequestType              = @"request_type";
NSString  *kNewRequest               = @"new";
NSString  *kRefreshRequest           = @"refresh";
NSString  *kScheduleID               = @"schedule_id";
NSString  *kReportedUserID           = @"reporter_user_id";
NSString  *kFlaggedUserID            = @"flagged_user_id";
NSString  *kRating                   = @"rating";
NSString  *kAPIAction                = @"action";
NSString  *kCurrentDate              = @"current_date";
NSString  *kCurrentDateAndTime       = @"date";
BOOL      isComingCall               = NO;
NSString  *kCredit                   = @"credit";
NSString  *kDishofTheWeek            = @"dish_of_week";
NSString  *kFavorite                 = @"favorite";
NSString  *kInteraction              = @"interaction";
NSString  *kStarCook                 = @"star_cook";
NSString  *kCookedDetails            = @"cooked_details";
NSString  *kCurrentPassword          = @"current_password";
NSString  *kUserSpeakingLanguage     = @"user_speaking_languages";
NSString  *kTutorialDetails          = @"tutorial_details";
NSString  *kShouldFetchDetailedData  = @"is_all";
NSString  *kMySchedules              = @"my_schedules";
NSString  *kChopChop                 = @"chop_chop";
NSString  *kMasterClass              = @"master_class";
NSString  *kGSTypeMasterClass        = @"masterclass";
NSString  *kMasterClassID            = @"master_class_id";
NSString  *kMasterClassStatus        = @"master_class_status";
NSString  *kMasterClassType          = @"master_class_type";
NSString  *kMasterChefName            = @"masterchef_name";
NSString  *kScheuledOn               = @"scheduled_on";
NSString  *kTotalInteraction         = @"total_interaction";
NSString  *kMasterClassDetail        = @"master_class_details";
NSString  *kAboutUser                = @"about_user";
NSString  *kIsBooked                 = @"is_booked";
NSString  *kIsFull                   = @"is_full";
NSString  *kIsSelected               = @"is_selected";
NSString  *kFacebookLink             = @"facebook_link";
NSString  *kInstagramLink            = @"instagram_link";
NSString  *kTwitterLink              = @"twitter_link";
NSString  *kWebsiteLink              = @"website_link";
NSString  *kVideoPlaceholderiPad     = @"video_image_ipad";
NSString  *kVideoPlaceholderiPhone   = @"video_image_iphone";
NSString  *kIsRescheduling           = @"is_reschedule";
NSString  *kChewIt                   = @"chewit";
NSString  *kChewItSession            = @"chewit_session";
NSString  *kShareURL                 = @"http://www.keychn.com";
NSString  *kAmount                   = @"amount";
NSString  *kMasterClassAmount        = @"25";
NSString  *kChewItSessionAmount      = @"0";
NSString  *kGroupSession             = @"group_session";
NSString  *kGroupSessionType         = @"master_class_type";
NSString  *kCancelTypeGroupSession   = @"groupsession";
NSString  *kCancelTypeUserSchedule   = @"userschedule";
NSString  *kIsScheduleOpen           = @"is_open";
NSString  *kSearchString             = @"search_text";
NSString  *kText                     = @"text";
NSString  *kTimestamp                = @"timestamp";
NSString  *kIngredientDetails        = @"ingredient_details";
NSString  *kItemLabel                = @"item_label";
NSString  *kSearchDetails            = @"search_details";
NSString  *kPendingRequest           = @"pending_requests";
NSString  *kFriendList               = @"friends";
NSString  *kIsAccpetingRequest       = @"is_accept";
NSString  *kIsRemovingFriend         = @"is_remove";
NSString  *kFriendID                 = @"friend_id";
NSString  *freeRideLabel             = @"FREE/RIDE";
NSString  *chewItLabel               = @"CHEW/IT";
NSString  *masterClassLabel          = @"MASTERCLASS";
NSString  *chewItSessionLabel        = @"CHEW/IT SESSION";
NSString  *kMessageID                = @"message_id";
NSString  *kChatDetails              = @"chat_details";
NSString  *kBadgeCount               = @"badge";
NSString  *kFirstScheduleID          = @"first_schedule_id";
NSString  *kSessionHost              = @"sessionHost";
NSString  *kSessionGuest             = @"sessionGuest";
NSString  *kIsHosting                = @"is_hosting";
NSString  *kSessionID                = @"session_id";
NSString  *kGroupSessionID           = @"group_session_id";
NSString  *kAppUser                  = @"user";
NSString  *kMasterChef               = @"masterchef";
NSString  *kBlogger                  = @"blogger";
NSString  *kUserMessageUpdated       = @"user_message_updated";
NSString  *kFirstUserID              = @"first_user_id";
NSString   *kIsPresented             = @"is_paperboard_presented";
NSString   *kResult                  = @"result";

#pragma mark - Storyboard Identifiers

NSString  *signUpViewController          = @"signUpViewController";
NSString  *emailSignUpViewController     = @"emailSignUpViewController";
NSString  *emailLoginViewController      = @"emailLoginViewController";
NSString  *forgotPasswordViewController  = @"forgotPasswordViewController";
NSString  *setProfilePhotoViewController = @"setProfilePhotoViewController";
NSString  *selectLangugeViewController   = @"selectLanguageViewController";
NSString  *segmentNavigationController   = @"mainMenuNavigationController";
NSString  *menuViewController            = @"menuViewController";
NSString  *myScheduleViewController      = @"myScheduleViewController";
NSString  *searchViewController          = @"searchViewController";
NSString  *settingViewController         = @"settingViewController";
NSString  *appWebViewController          = @"appWebViewController";
NSString  *rootViewController            = @"rootViewNavigationController";
NSString  *itemListViewController        = @"itemListViewController";
NSString  *itemDetailsViewController     = @"itemDetailsViewController";
NSString  *userScheduleViewController    = @"userDayScheduleViewController";
NSString  *slotScheduleViewController    = @"slotScheduleViewController";
NSString  *liveVideoCallController       = @"liveVideoCallController";
NSString  *searchStarCookViewController  = @"searchStarCookViewController";
NSString  *incomingCallViewController    = @"incomingCallViewController";
NSString  *callDisconnectViewController  = @"callDisconnectViewController";
NSString  *shareImageViewController      = @"sharePhotoViewController";
NSString  *chooseTypeViewController      = @"chooseATypeViewController";
NSString  *myPreferenceViewController    = @"myPreferencesViewController";
NSString  *changePasswordViewController  = @"changePasswordViewController";
NSString  *contacUsViewController        = @"contactUsViewController";
NSString  *tutorialViewController        = @"tutorialViewControlelr";
NSString  *masterClassViewController     = @"masterClassViewController";
NSString  *soloCookingViewController     = @"cookSoloViewController";
NSString  *chewItSessionViewController   = @"chewItSessionViewController";
NSString  *starCookViewController        = @"starCookViewController";
NSString  *searchFriendViewController    = @"searchFriendViewController";
NSString  *pendingRequestViewController  = @"pendingFriendRequestViewController";
NSString  *textChatViewController        = @"textChatViewController";
NSString  *hostEndSessionViewController  = @"groupSessionHostEndViewController";
NSString  *guestEndSessionViewController = @"groupSessionGuestEndViewController";
NSString  *imageDisplayViewController    = @"imageDisplayViewController";
NSString  *kHomeViewController           = @"HomeTabeController";
NSString  *kCookViewController           = @"CookViewController";
NSString  *kOnBoardViewController        = @"OnBoardViewController";

#pragma mark - Splash Constants

NSString *appName = @"Keychn";
float    splashDelayInSeconds = 1.0f;

#pragma mark - Table Cell Identifiers
NSString  *cellIdentifierEmailSignUpTextFields           = @"emailSignUpCellIdentifier";
NSString  *cellIdentifierForEmailSignUpReveiveNewsletter = @"emailSignUpReceiveNewsletterCell";
NSString  *cellIdentifierForEmailSignUpSignUpButton      = @"emailSignUpSignUpButtonCell";
NSString  *cellIdentifierForEmailSignInTextField         = @"emailSignInCellIdentifier";
NSString  *cellIdentifierForEmailSignInButton            = @"emailSignInButtonCellIdentifier";
NSString  *cellIdentifierForSettingWebLinks              = @"settingsLinksTableCell";
NSString  *cellIdentifierForSettingSocialAccount         = @"settingsSocialAccountTableCell";
NSString  *cellIdentifierForMainMenu                     = @"mainMenuTableViewCell";
NSString  *cellIdentifierForItemList                     = @"itemListTableCell";
NSString  *cellIdentifierForItemDetails                  = @"itemDetailsTableViewCell";
NSString  *cellIdentifierForItemIngredients              = @"ingredientListTableCell";
NSString  *cellIdentifierForItemIngredientCount          = @"ingredientCountTableCell";
NSString  *cellIdentifierForItemRecipeStep               = @"recipeStepTableCell";
NSString  *cellIdentifierForUserDaySchedule              = @"userDayScheduleTableViewCell";
NSString  *cellIdentifierForUserSlotSchedule             = @"slotScheduleTableViewCell";
NSString  *cellIdentifierForMySchedule                   = @"myScheduleTableCell";
NSString  *cellIdentifierForChangePassword               = @"changePasswordTableCell";
NSString  *cellIdentifierForMasterClass                  = @"masterClassCollectionViewCell";
NSString  *cellIdentifierForTutorial                     = @"tutorialTableViewCell";
NSString  *cellIdentiferForStarCook                      = @"starCookTableCell";
NSString  *cellIdentifierForIncomingMessage              = @"incomingMessageTableCell";
NSString  *cellIdentifierForOutgoingMessage              = @"outgoingMessageTableCell";
NSString  *cellIdentifierForIncomingImage                = @"incomingImageTableCell";
NSString  *cellIdentifierForOutgoingImage                = @"outgoingImageTableCell";
NSString  *cellIdentifierForMasterClassList              = @"MasterClassListTableCell";

#pragma mark - Collection View Cell Identifier

NSString *cellIdentifierForLeftItem         = @"leftItemCollectionViewCell";
NSString *cellIdentifierForRecipeItem       = @"recipeItemCollectionViewCell";
NSString *cellIdentifierForRightItem        = @"rightItemCollectionViewCell";
NSString *cellIdentifierForSectionHeader    = @"itemSectionHeaderCollectionViewCell";
NSString *cellIdentifierForNoSearchResult   = @"noSearchResultCollectionViewCell";
NSString  *cellIdentifierMenusCollectioView = @"menuCollectionView";
NSString  *cellIdentifierHomeItemCollection = @"HomeItemCollectionViewCell";
NSString  *cellIdentifierForOnboardCollection = @"OnBoardCollectionViewCell";

#pragma mark- Device Token

NSString *keychnDeviceToken;
NSString *keychnVoIPToken;
bool     shouldJoinConference;
NSInteger DataStreamIndentifier = 1001;


#pragma mark - Notification

NSString *kApsDictionary = @"aps";
NSString *kAlertTitle    = @"title";
NSString *kAlertMessage  = @"alert";

@end
