//
//  KCAppLabel.h
//  Keychn
//
//  Created by Keychn Experience SL on 06/01/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KCAppLabel : NSObject

/**
 @abstract This method will retunrn singleton instance of the underlying class
 @param No Parameter
 @return Instance Type
*/
+ (instancetype) sharedInstance;

#pragma mark - App Labels

#pragma mark - Sign Up Screen Texts

@property (nonatomic,copy) NSString *lblWeHighlyRecommend;
@property (nonatomic,copy) NSString *btnConnectWithFacebook;
@property (nonatomic,copy) NSString *btnSignInWithTwitter;
@property (nonatomic,copy) NSString *lblOr;
@property (nonatomic,copy) NSString *btnSignUpWithEmail;
@property (nonatomic,copy) NSString *lblAlreadySignedUp;
@property (nonatomic,copy) NSString *btnLoginNow;

#pragma mark - Email Sign Up Screen Texts

@property (nonatomic,copy) NSString *lblSignUpText;
@property (nonatomic,copy) NSString *placeholderName;
@property (nonatomic,copy) NSString *placeholderEmail;
@property (nonatomic,copy) NSString *placeholderPassword;
@property (nonatomic,copy) NSString *placeholderConfirmPassword;
@property (nonatomic,copy) NSString *receiveNewsletter;
@property (nonatomic,copy) NSString *lblTermsAndConditions;
@property (nonatomic,copy) NSString *lblSignUpTerms;
@property (nonatomic,copy) NSString *lblAgreeToThe;
@property (nonatomic,copy) NSString *lblTermsOfUse;
@property (nonatomic,copy) NSString *lblAnd;
@property (nonatomic,copy) NSString *lblPrivacyPolicy;

#pragma mark - Email Sign In Screen Text

@property (nonatomic,copy) NSString *lblSignIn;
@property (nonatomic,copy) NSString *btnForgotPassword;

#pragma mark - Reset Password Screen Text

@property (nonatomic,copy) NSString *lblForgotPassword;
@property (nonatomic,copy) NSString *btnReset;
@property (nonatomic,copy) NSString *lblPasswordReset;
@property (nonatomic,copy) NSString *lblPasswordSentToEmail;

#pragma mark - Set Profile Image Screen Text

@property (nonatomic,copy) NSString *lblProfilePhoto;
@property (nonatomic,copy) NSString *addAProfilePicture;
@property (nonatomic,copy) NSString *placeholderSetLocation;
@property (nonatomic,copy) NSString *actionSheetTitleSetPicture;
@property (nonatomic,copy) NSString *actionSheetButtonGallery;
@property (nonatomic,copy) NSString *actionSheetButtonCamera;
@property (nonatomic,copy) NSString *btnCancel;
@property (nonatomic,copy) NSString *btnNextStep;
@property (nonatomic,copy) NSString *chnageProfilePicture;

#pragma mark - Select Language Screen Text

@property (nonatomic,copy) NSString *lblSelectALanguage;
@property (nonatomic,copy) NSString *lblLanguageOfTheApp;
@property (nonatomic,copy) NSString *lblLanguageYouSpeak;
@property (nonatomic,copy) NSString *lblSelectMoreThanOne;
@property (nonatomic,copy) NSString *btnDone;
@property (nonatomic,copy) NSString *btnIAmDone;
@property (nonatomic,copy) NSString *btnRetry;

#pragma mark - InstAction Screen
@property (nonatomic,copy) NSString *lblChopChop;
@property (nonatomic,copy) NSString *lblChewIt;
@property (nonatomic,copy) NSString *lblCookWithSomeOne;
@property (nonatomic,copy) NSString *lblEatWithSomeOne;
@property (nonatomic,copy) NSString *lblUsersInteracting;
@property (nonatomic,copy) NSString *lblSeeTheRecipe;
@property (nonatomic,copy) NSString *lblTutorial;
@property (nonatomic,copy) NSString *lblChef;
@property (nonatomic,copy) NSString *lblSoldOut;
@property (nonatomic,copy) NSString *lblMasterClass;
@property (nonatomic,copy) NSString *lblDelicious;
@property (nonatomic,copy) NSString *lblchewItSession;
@property (nonatomic,copy) NSString *lblEatNowWithAnotherUser;
@property (nonatomic,copy) NSString *lblEatLaterWithAnotherUser;

#pragma mark - Menu Screen Text
@property (nonatomic,copy) NSString *btnInstaAction;
@property (nonatomic,copy) NSString *btnMenus;
@property (nonatomic,copy) NSString *lblFreeRide;
@property (nonatomic,copy) NSString *noRecipeAttached;
@property (nonatomic,copy) NSString *lblDragToLoadMore;
@property (nonatomic,copy) NSString *lblNo;

#pragma mark - Now Schedule POP Up Text
@property (nonatomic,copy) NSString *lblStartFreeRide;
@property (nonatomic,copy) NSString *lblCookNowSubtitle;
@property (nonatomic,copy) NSString *lblCookLaterSubtitle;

#pragma mark - Item Details Screen
@property (nonatomic,copy) NSString *btnScheduleNow;
@property (nonatomic,copy) NSString *btnReschedule;
@property (nonatomic,copy) NSString *btnScheduleForLater;
@property (nonatomic,copy) NSString *lblYummylicious;
@property (nonatomic,copy) NSString *lblMinutes;
@property (nonatomic,copy) NSString *lblDifficulty;
@property (nonatomic,copy) NSString *lblServings;
@property (nonatomic,copy) NSString *lblTotalIngredientsAvailable;
@property (nonatomic,copy) NSString *lblStep;
@property (nonatomic,copy) NSString *lblSteps;

#pragma mark - My Schedule
@property (nonatomic,copy) NSString *lblMySchedule;
@property (nonatomic,copy) NSString *lblNextInteraction;
@property (nonatomic,copy) NSString *titleMySchedule;
@property (nonatomic,copy) NSString *lblChoose;
@property (nonatomic,copy) NSString *lblType;
@property (nonatomic,copy) NSString *btnCancelInteraction;
@property (nonatomic,copy) NSString *btnRescheduleInteraction;
@property (nonatomic,copy) NSString *lblNoInteractionScheduled;
@property (nonatomic,copy) NSString *lblTapToAddInteaction;

#pragma mark - My Preference
@property (nonatomic,copy) NSString *btnEdit;
@property (nonatomic,copy) NSString *btnStarCook;
@property (nonatomic,copy) NSString *lblInteraction;
@property (nonatomic,copy) NSString *lblFavorite;
@property (nonatomic,copy) NSString *btnGetMore;
@property (nonatomic,copy) NSString *lblDishofTheWeek;
@property (nonatomic,copy) NSString *lblNoCookedRecipes;
@property (nonatomic,copy) NSString *lblLetsGetCooking;
@property (nonatomic,copy) NSString *lblKeychnPoints;
@property (nonatomic,copy) NSString *lblAvailable;
@property (nonatomic,copy) NSString *lblChat;
@property (nonatomic,copy) NSString *lblCookWithMe;
@property (nonatomic,copy) NSString *lblEatWithMe;
@property (nonatomic,copy) NSString *lblPoints;
@property (nonatomic,copy) NSString *btnConifirmPurchase;
@property (nonatomic,copy) NSString *lblBuyKeychPoints;

#pragma User Schedule
@property (nonatomic,copy) NSString *lblPickADay;
@property (nonatomic,copy) NSString *lblPickAShift;
@property (nonatomic,copy) NSString *btnSchedule;
@property (nonatomic,copy) NSString *sunday;
@property (nonatomic,copy) NSString *monday;
@property (nonatomic,copy) NSString *tuesday;
@property (nonatomic,copy) NSString *wednesday;
@property (nonatomic,copy) NSString *thursday;
@property (nonatomic,copy) NSString *friday;
@property (nonatomic,copy) NSString *saturday;
@property (nonatomic,copy) NSString *breakfast;
@property (nonatomic,copy) NSString *lunch;
@property (nonatomic,copy) NSString *dinner;
@property (nonatomic,copy) NSString *lblKeyInteractionScheduled;
@property (nonatomic,copy) NSString *lblWeWillNotifyForMatch;
@property (nonatomic,copy) NSString *btnKnifesUp;
@property (nonatomic,copy) NSString *keychnInteraction;
@property (nonatomic,copy) NSString *btnShowMe;
@property (nonatomic,copy) NSString *messageInteractionScheduled;

#pragma mark - User Call

@property (nonatomic,copy) NSString *lblFindingStarcook;
@property (nonatomic,copy) NSString *lblCallingStarCook;
@property (nonatomic,copy) NSString *lblNoCookAvailable;
@property (nonatomic,copy) NSString *lblUserBusyOnCall;
@property (nonatomic,copy) NSString *btnCookSolo;
@property (nonatomic,copy) NSString *btnEatSolo;
@property (nonatomic,copy) NSString *btnFindPeer;
@property (nonatomic,copy) NSString *lblCalling;
@property (nonatomic,copy) NSString *lblCooking;
@property (nonatomic,copy) NSString *lblEating;
@property (nonatomic,copy) NSString *lblWhyHangedUp;
@property (nonatomic,copy) NSString *btnReportAbuse;
@property (nonatomic,copy) NSString *btnWeFinished;
@property (nonatomic,copy) NSString *btnNoReason;
@property (nonatomic,copy) NSString *lblShowOffHowGoodYouAre;
@property (nonatomic,copy) NSString *lblShowOff;
@property (nonatomic,copy) NSString *lblHowGoodYouAre;
@property (nonatomic,copy) NSString *lblInThe;
@property (nonatomic,copy) NSString *btnOtherUser;
@property (nonatomic,copy) NSString *btnFacebook;
@property (nonatomic,copy) NSString *btnInstagram;
@property (nonatomic,copy) NSString *btnTwitter;
@property (nonatomic,copy) NSString *lblShareWith;
@property (nonatomic,copy) NSString *lblYouAreAStar;
@property (nonatomic,copy) NSString *lblPleaseRateTheRecipe;
@property (nonatomic,copy) NSString *lblPleaseRateTheInteraction;
@property (nonatomic,copy) NSString *lblPleaseTellUsWhatDidYouCook;
@property (nonatomic,copy) NSString *lblPleaseTellUsWhatDidYouEat;
@property (nonatomic,copy) NSString *btnThankYou;
@property (nonatomic,copy) NSString *lblNotAnswering;

#pragma mark - Settings Screen
@property (nonatomic,copy) NSString *lblSettings;
@property (nonatomic,copy) NSString *btnLogOut;
@property (nonatomic,copy) NSString *lblChagePassword;
@property (nonatomic,copy) NSString *lblAboutUs;
@property (nonatomic,copy) NSString *lblLanguages;
@property (nonatomic,copy) NSString *lblContactUs;
@property (nonatomic,copy) NSString *lblPrivacy;

#pragma mark - Contact Us Screen
@property (nonatomic,copy) NSString *btnSend;
@property (nonatomic,copy) NSString *lblHowCanWeHelp;

#pragma mark - Change Password Screen
@property (nonatomic,copy) NSString *placeHolderOldPassword;
@property (nonatomic,copy) NSString *placeHolderNewPassword;
@property (nonatomic,copy) NSString *placeHolderConfirmNewPassword;

#pragma mark - Tutorial Screen
@property (nonatomic,copy) NSString *lblHowTo;

#pragma mark - MasterClass Details
@property (nonatomic,copy) NSString *btnShare;
@property (nonatomic,copy) NSString *btnBuyASpot;
@property (nonatomic,copy) NSString *btnAttend;

#pragma mark - Search Recipe
@property (nonatomic,copy) NSString *lblSearchResult;
@property (nonatomic,copy) NSString *lblPlaceholderSearchItems;
@property (nonatomic,copy) NSString *lblSearchByIngredients;
@property (nonatomic,copy) NSString *lblSearchByRecipe;
@property (nonatomic,copy) NSString *lblSearchByCategory;

#pragma mark - Manage Friend
@property (nonatomic,copy) NSString *lblFriendRequests;
@property (nonatomic,copy) NSString *btnDelete;
@property (nonatomic,copy) NSString *btnBlock;
@property (nonatomic,copy) NSString *btnAddFriend;
@property (nonatomic,copy) NSString *btnRequestSent;
@property (nonatomic,copy) NSString *placeholderSearchUser;
@property (nonatomic,copy) NSString *lblNoFriends;
@property (nonatomic,copy) NSString *lblSearchFriends;

#pragma mark - Text Chat
@property (nonatomic,copy) NSString *lblYourMessage;
@property (nonatomic,copy) NSString *btnStartCooking;
@property (nonatomic,copy) NSString *btnStartEating;
@property (nonatomic,copy) NSString *lblNow;

#pragma mark - Home Screen

@property (nonatomic,copy) NSString *lblJoinCookingSession;
@property (nonatomic,copy) NSString *lblFindACookingCompanion;
@property (nonatomic,copy) NSString *lblLearnFromExperts;
@property (nonatomic,copy) NSString *lblOurNextMasterClassesAre;
@property (nonatomic,copy) NSString *lblAreYouSureWantToJoin;
@property (nonatomic,copy) NSString *lblAreYouGonnaCookNow;
@property (nonatomic,copy) NSString *lblCookingSession;

#pragma mark - Cook Screen

@property (nonatomic,copy) NSString *lblRecipesFromTheWorld;
@property (nonatomic,copy) NSString *lblChooseAndCook;
@property (nonatomic,copy) NSString *lblWatchOurTutorials;
@property (nonatomic,copy) NSString *lblYouCanLearnMoreAbout;

#pragma mark - Screen Tabs

@property (nonatomic,copy) NSString *btnHomeTab;
@property (nonatomic,copy) NSString *btnRecipesTab;
@property (nonatomic,copy) NSString *btnCookTab;
@property (nonatomic,copy) NSString *btnMyScheduleTab;
@property (nonatomic,copy) NSString *btnProfileTab;

#pragma mark - Alert Titles
@property (nonatomic,copy) NSString *errorTitle;
@property (nonatomic,copy) NSString *informationTitle;
@property (nonatomic,copy) NSString *confirmationTitle;
@property (nonatomic,copy) NSString *loginWithFacebookFailed;
@property (nonatomic,copy) NSString *mergingFacebookAccount;

#pragma mark - Alert Messages

@property (nonatomic,copy) NSString *unexpectedErrorMessage;
@property (nonatomic,copy) NSString *twitterAccountAccessDenied;
@property (nonatomic,copy) NSString *noTwitterAccountSetup;
@property (nonatomic,copy) NSString *nameEmpty;
@property (nonatomic,copy) NSString *emailIDEmpty;
@property (nonatomic,copy) NSString *emailIDInvalidFormat;
@property (nonatomic,copy) NSString *passwordInvalid;
@property (nonatomic,copy) NSString *confirmPasswordEmpty;
@property (nonatomic,copy) NSString *passwordDoesNotMatch;
@property (nonatomic,copy) NSString *internetNotAvailable;
@property (nonatomic,copy) NSString *profileImageNotSelected;
@property (nonatomic,copy) NSString *locationEmpty;
@property (nonatomic,copy) NSString *speakingLanguageNotSelected;
@property (nonatomic,copy) NSString *bookingSlotNotSelected;
@property (nonatomic,copy) NSString *nativeFacebookAppNotInstalled;
@property (nonatomic,copy) NSString *nativeInstagramAppNotInstalled;
@property (nonatomic,copy) NSString *pleaseProvideItemTitle;
@property (nonatomic,copy) NSString *passwordUpdatedSuccessfully;
@property (nonatomic,copy) NSString *minumumCharsRequiredForQuery;
@property (nonatomic,copy) NSString *querySubmittedSuccessfully;
@property (nonatomic,copy) NSString *pickADifferentTimeSlotToChange;
@property (nonatomic,copy) NSString *donotHaveSufficientCredit;
@property (nonatomic,copy) NSString *masterClassBookingSlotExpired;
@property (nonatomic,copy) NSString *masterClassSlotBooked;
@property (nonatomic,copy) NSString *chewItSessionSlotBooked;
@property (nonatomic,copy) NSString *typeMoreCharactersToSearch;
@property (nonatomic,copy) NSString *joinConferenceAfterSomeTime;
@property (nonatomic,copy) NSString *userInteractionScheduled;

#pragma mark - Group Conference

@property (nonatomic,copy) NSString *lblSpeakNow;
@property (nonatomic,copy) NSString *moreUserForYourTurn;
@property (nonatomic,copy) NSString *lblWaitForYourTurn;

#pragma mark - Alert Button Titles

@property (nonatomic,copy) NSString *btnOk;
@property (nonatomic,copy) NSString *btnMerge;
@property (nonatomic,copy) NSString *btnSettings;
@property (nonatomic,copy) NSString *btnConfirm;
@property (nonatomic,copy) NSString *btnBuyNow;

#pragma mark - Activity Indicator Texts

@property (nonatomic,copy) NSString *activitySigningIn;
@property (nonatomic,copy) NSString *activitySigningUp;
@property (nonatomic,copy) NSString *activityLoggingInwithTwitter;
@property (nonatomic,copy) NSString *activityLoggigngInWithFacebook;
@property (nonatomic,copy) NSString *activityUpdatingProfile;
@property (nonatomic,copy) NSString *activityUpdatingAppLanguage;
@property (nonatomic,copy) NSString *activityUpdatingLanguageList;
@property (nonatomic,copy) NSString *activityMergingFacebookAccount;
@property (nonatomic,copy) NSString *activityRequestingNewPassword;
@property (nonatomic,copy) NSString *activityUserScheduling;
@property (nonatomic,copy) NSString *activityOpenCamera;
@property (nonatomic,copy) NSString *activityReportingAbuseForThisUser;
@property (nonatomic,copy) NSString *activitySavingItemRating;
@property (nonatomic,copy) NSString *activitySavingChewItRating;
@property (nonatomic,copy) NSString *activityUploadingImage;
@property (nonatomic,copy) NSString *activityUpdatingPassword;
@property (nonatomic,copy) NSString *activityLoggingOut;
@property (nonatomic,copy) NSString *activitySubmittingQuery;
@property (nonatomic,copy) NSString *activityRequestingAMasterClassSpot;
@property (nonatomic,copy) NSString *activityCancellingInteraction;
@property (nonatomic,copy) NSString *activityPleaseWaitAMoment;

#pragma mark - New Labels V2.0

@property (nonatomic,copy) NSString *alertTitleCongratulations;
@property (nonatomic,copy) NSString *alertMessageGetReadyWithTheFork;
@property (nonatomic,copy) NSString *lblAttend;
@property (nonatomic,copy) NSString *lblFullCapacity;
@property (nonatomic,copy) NSString *lblAttending;
@property (nonatomic,copy) NSString *lblRestorePurchase;
@property (nonatomic,copy) NSString *lblMasterclasses;
@property (nonatomic,copy) NSString *lblLive;
@property (nonatomic,copy) NSString *lblLearnWithMasterchef;
@property (nonatomic,copy) NSString *lblFree;
@property (nonatomic,copy) NSString *lblRecipesForAll;
@property (nonatomic,copy) NSString *lblYour;
@property (nonatomic,copy) NSString *lblGetTrial;
@property (nonatomic,copy) NSString *lblCancelAnytime;
@property (nonatomic,copy) NSString *lblSubscribe;
@property (nonatomic,copy) NSString *lblAddFavoriteRecipe;
@property (nonatomic,copy) NSString *lblNoMasterclassesAdded;
@property (nonatomic,copy) NSString *lblAddMasterclasses;
@property (nonatomic,copy) NSString *lblCalendar;
@property (nonatomic,copy) NSString *lblMonthly;
@property (nonatomic,copy) NSString *lblYearly;
@property (nonatomic,copy) NSString *lblYouWantToLearnFromExperts;
@property (nonatomic,copy) NSString *lblSubscribeTo;
@property (nonatomic,copy) NSString *lblPremiumContentTerms;
@property (nonatomic,copy) NSString *lblFavoriteRecipe;
@property (nonatomic,copy) NSString *lblSearchKeychnMasterclass;
@property (nonatomic,copy) NSString *alertTitleConfirmCancellation;
@property (nonatomic,copy) NSString *alertMessageConfirmCancellation;
@property (nonatomic,copy) NSString *lblSubscriptionTermsAndConditon;


@end
