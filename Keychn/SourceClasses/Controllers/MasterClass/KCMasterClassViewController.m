//
//  KCMasterClassViewController.m
//  Keychn
//
//  Created by Keychn Experience SL on 21/03/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import "KCMasterClassViewController.h"
#import "KCGroupSessionWebManager.h"
#import "KCGroupSession.h"
#import "UIImageView+AFNetworking.h"
#import "KCFacebookManager.h"
#import "KCTwitterManager.h"
#import "KCSubscription.h"
#import "IAPSubscription.h"
#import "KCUserScheduleWebManager.h"
#import "KCUserScheduleDBManager.h"
#import "KCMySchedule.h"
#import "KCGroupSessionHostEndViewController.h"
#import "KCGroupSessionGuestEndViewController.h"
#import "AppDelegate.h"
#import "KCDeepLinkManager.h"

@import SafariServices;

#define kMasterClassTimeOffSet 900 // Allow users to join MasterClass upto 15 minutes of shceduled session

#define MASTERCLASS_PRE_TEXT(s) [NSString stringWithFormat:@"Get the chance to interact with #%@ at the next #keychn #masterclass",s]

#define kShareLiveClass(s) [NSString stringWithFormat:@"https://keychn.com/#!/livelist/%@",s]


#define kBaseHeight  243
#define kBaseWidth   400
#define kAspectRatioFactor 1.64

@interface KCMasterClassViewController ()  {
    KCUserProfile               *_userProfile;
    KCGroupSessionWebManager    *_groupSessionManager;
    KCFacebookManager           *_facebookManager;
    KCTwitterManager            *_twitterManager;
    NSInteger                   _labelHeight;
    KCSubscription              *_subscriptionAlertView;
    IAPSubscription             *_iapSubscription;
    KCUserScheduleWebManager    *_userScheduleWebManager;
    KCMySchedule                *_masterclassToJoin;
}

// New Outlets

@property (weak, nonatomic) IBOutlet UIView  *containerView;
@property (weak, nonatomic) IBOutlet UILabel *dateAndMonthLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *aboutMasterchefLabel;
@property (weak, nonatomic) IBOutlet UIButton *masterchefLocationButton;
@property (weak, nonatomic) IBOutlet UILabel *masterchefNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *masterchefImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *masterClassDetailScrollView;
@property (weak, nonatomic) IBOutlet UIButton *attendButton;
@property (weak, nonatomic) IBOutlet UIImageView *attendCheckmarkImageView;
@property (weak, nonatomic) IBOutlet UIButton *playVideoButton;
@property (weak, nonatomic) IBOutlet TriLabelView *freeClassLabel;
@property (weak, nonatomic) IBOutlet UIView *attendButtonView;
@property (weak, nonatomic) IBOutlet UIView *masterclassContainerView;


@end

@implementation KCMasterClassViewController


#pragma mark - Life Cycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Get Instances
    _userProfile            = [KCUserProfile sharedInstance];
    _groupSessionManager    = [KCGroupSessionWebManager new];
    _userScheduleWebManager = [KCUserScheduleWebManager new];
    
    // Customize app UI
    [self customizeUI];
    
    // Fetch MasterClass Details from server
    [self getMasterClassDetails];
    
    // Add right swipe gesture to navigate back
    [self addLeftSwipeGesture];
    
    // Check for the next interaction in queue
    [self getUserSchedule];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [KCProgressIndicator hideActivityIndicator];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

#pragma mark - Deep Link Delegate

- (void)configureControlWithData:(NSDictionary *)data {
    
}

#pragma mark - Button Actions

- (IBAction)backButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:true completion:^{
        
    }];
}

- (IBAction)attendMasterclassButtonTapped:(UIButton *)sender {
    // Buy a spot for MasterClass
    if(sender.isSelected) {
        // Start Masterclass now
        __weak id weakSelf = self;
        [self dismissViewControllerAnimated:YES completion:^{
            [weakSelf startGroupSession];
        }];
        
    }
    else {
        // Show subscription alert if user hasn't purchased the subscription yet
        _iapSubscription        = [IAPSubscription subscriptionForUser:_userProfile.userID];
        if(!(_groupSession.isFree || _iapSubscription)) {
            _subscriptionAlertView = [[KCSubscription alloc] initWithFrame:self.view.frame];
            [_subscriptionAlertView showInView:self.view withCompletionHandler:^(BOOL postiveButton) {
                
            }];
        }
        else {
            // Purchase the Masterclass
            BOOL isValid =  [self validateMasterClassTime];
            if(isValid) {
                [self buyMasterClassSpot];
                Mixpanel *mixpanel = [Mixpanel sharedInstance];
                [mixpanel track:@"masterclass_list_attend_button"
                     properties:@{@"masterclass_id":self.groupSession.sessionID, @"chef_name":self.groupSession.chefName}];
            }
        }
    }
}

- (IBAction)shareButtonTapped:(UIButton*)sender {
    // Show Action Sheet for Twitter and Facebook options
  /*  NSURL *shareURL = [NSURL URLWithString:kShareLiveClass(self.masterClassID)];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[shareURL] applicationActivities:nil];
    
    NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                   UIActivityTypePrint,
                                   UIActivityTypeAssignToContact,
                                   UIActivityTypeSaveToCameraRoll,
                                   UIActivityTypeAddToReadingList];
    
    activityVC.excludedActivityTypes = excludeActivities;
    
    [self presentViewController:activityVC animated:YES completion:nil];
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"masterclass_share_icon"
         properties:@{@"masterclass_id":_groupSession.sessionID, @"chef_name":self.groupSession.chefName}]; */
    
    if(_groupSession != nil) {
        NSString *canonicalURL = kShareLiveClass(_groupSession.sessionID);
        [KCDeepLinkManager shareLinkWithTitle:_groupSession.chefName content:NSLocalizedString(@"shareLiveCookingChef", nil) canonicalURL:canonicalURL imageURL:_groupSession.masterChefImageURL controller:@"LiveClass" identfier:_groupSession.sessionID presentOn:self];
        
        // Track user behavior
        Mixpanel *mixpanel = [Mixpanel sharedInstance];
        [mixpanel track:@"live_masterclass_share"
             properties:@{@"chef_name": _groupSession.chefName}];
    }
    
}

- (IBAction)facebookLinkButtonTapped:(id)sender {
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"masterclass_facebook_icon"
         properties:@{@"masterclass_id":_groupSession.sessionID, @"chef_name":self.groupSession.chefName}];
    [self openWebPageForURL:_groupSession.facebookLink];
}

- (IBAction)instagramLinkButtonTapped:(id)sender {
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"masterclass_instagram_icon"
         properties:@{@"masterclass_id":_groupSession.sessionID, @"chef_name":_groupSession.chefName}];
    [self openWebPageForURL:_groupSession.instagramLink];
}

- (IBAction)twitterLinkButtonTapped:(id)sender {
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"masterclass_twitter_icon"
         properties:@{@"masterclass_id":_groupSession.sessionID, @"chef_name":_groupSession.chefName}];
    [self openWebPageForURL:_groupSession.twitterLink];
}

- (IBAction)playVideoButtonTapped:(id)sender {
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"masterclass_list_attend_button"
         properties:@{@"masterclass_id":_groupSession.sessionID, @"chef_name":_groupSession.chefName}];
    [self playVideoWithURL:_groupSession.videoURL];
}

#pragma mark - Gesture recognizition
- (void)rightSwipeGesurePerformed:(UIGestureRecognizer *)gestureRecognizer {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Timer Check

- (void)getUserSchedule {
    // Check if the Masterclass is ready to be joined
    KCUserScheduleDBManager *userScheduleDBManager = [KCUserScheduleDBManager new];
    KCMySchedule *mySchedule = [userScheduleDBManager getNextInteraction];
    
    if([mySchedule.scheduleID integerValue] == [_groupSession.sessionID integerValue]) {
        _masterclassToJoin = mySchedule;
        NSTimeInterval currentTimeInterval  = [[NSDate date] timeIntervalSince1970];
        // Find the difference from current time
        NSTimeInterval difference           =  mySchedule.scheduleDate - currentTimeInterval;
        if(difference > kBufferTimeForCallStart) {
            difference -= kBufferTimeForCallStart;
            [self performSelector:@selector(refreshUserSchedule) withObject:nil afterDelay:difference];
        }
        else {
            [self refreshUserSchedule];
        }
    }
}

- (void)refreshUserSchedule {
    // Set Start Cooking Button
    self.attendButton.enabled  = YES;
    self.attendButton.selected = YES;
    self.attendButton.userInteractionEnabled = YES;
    [self.attendButton setTitle:[NSLocalizedString(@"startCooking", nil) uppercaseString] forState:UIControlStateSelected];
    [self.attendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.attendButton setBackgroundColor:[UIColor appGreenColor]];
}

#pragma mark - Start Call

- (void)startGroupSession {
    // Start Group Session 1:N
    
    // Get root viewcontroller
    UINavigationController *rootViewController =  (UINavigationController *) (((AppDelegate *) [UIApplication sharedApplication].delegate).window.rootViewController);
    
    if(_masterclassToJoin.isHosting) {
        KCGroupSessionHostEndViewController *gsHostEndViewController = [self.storyboard instantiateViewControllerWithIdentifier:hostEndSessionViewController];
        gsHostEndViewController.conferenceID   = _masterclassToJoin.conferenceID;
        gsHostEndViewController.groupSessionID = _masterclassToJoin.scheduleID;
        NSMutableArray *viewControllers = [self.navigationController.viewControllers mutableCopy];
        [viewControllers removeLastObject];
        [viewControllers addObject:gsHostEndViewController];
        [rootViewController pushViewController:gsHostEndViewController animated:YES];
    }
    else {
        KCGroupSessionGuestEndViewController *gsGuestEndViewController = [self.storyboard instantiateViewControllerWithIdentifier:guestEndSessionViewController];
        gsGuestEndViewController.conferenceID    = _masterclassToJoin.conferenceID;
        gsGuestEndViewController.hostName        = _masterclassToJoin.secondUsername;
        gsGuestEndViewController.sessionID       = _masterclassToJoin.scheduleID;
        gsGuestEndViewController.chefUserID      = _masterclassToJoin.secondUserID;
        UserRole role                            = _masterclassToJoin.isListner ? Listner : Speaker;
        gsGuestEndViewController.role            = role;
        NSMutableArray *viewControllers = [self.navigationController.viewControllers mutableCopy];
        [viewControllers removeLastObject];
        [viewControllers addObject:gsGuestEndViewController];
        [rootViewController pushViewController:gsGuestEndViewController animated:YES];
    }
}


#pragma mark - Instance Methods

- (void)customizeUI {
    // Set layout, font, color etc
    self.masterClassDetailScrollView.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setMasterclassPurchaseStatus:self.hasPurhcased];
    
    // Set shadow
    self.masterclassContainerView.layer.shadowColor     = [[UIColor blackColor] colorWithAlphaComponent:0.3].CGColor;
    self.masterclassContainerView.layer.shadowRadius    = 5.0f;
    self.masterclassContainerView.layer.masksToBounds   = false;
    self.masterclassContainerView.layer.shadowOpacity   = 1.0f;
    self.masterchefImageView.layer.cornerRadius         = 5.0f;
}

- (BOOL)validateMasterClassTime {
    // Validate the MasterClass time has not been expired
    NSTimeInterval timeInterval = [NSDate getSecondsFromDate:_groupSession.scheduleDate] + [NSDate getGMTOffSet];
    NSTimeInterval currentTimeInterval = [[NSDate date] timeIntervalSince1970] - kMasterClassTimeOffSet;
    if(DEBUGGING) NSLog(@"Scheduled Time Interval and Current %f Time Inteval %f",timeInterval,currentTimeInterval);
    __weak KCMasterClassViewController *weakSelf = self;
    if(timeInterval <= currentTimeInterval) {
        [KCUIAlert showInformationAlertWithHeader:NSLocalizedString(@"sorryStarcook", nil) message:NSLocalizedString(@"masterclassSessionExpired", nil) withButtonTapHandler:^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
        return NO;
    }
    return YES;
}

- (void)addLeftSwipeGesture {
    // Add a swipe gesture on superview to navigate back
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipeGesurePerformed:)];
    swipeGesture.direction                 = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeGesture];
}

- (void)shareMasterClassOnFacebook {
    // Share MaterClass on facebook
    if(!_facebookManager) {
        _facebookManager = [KCFacebookManager new];
    }
    [_facebookManager showFacebookShareDialogWithText:MASTERCLASS_PRE_TEXT([_groupSession.chefName stringByReplacingOccurrencesOfString:@" " withString:@""]) inViewController:self withCompletionHandler:^(BOOL isShared) {
        
    }];
}

- (void)shareMasterClassOnTwitter {
    // Share MasterClass on Twitter
    if(!_twitterManager) {
        _twitterManager = [KCTwitterManager new];
    }
    
    NSString *tweet = MASTERCLASS_PRE_TEXT([_groupSession.chefName stringByReplacingOccurrencesOfString:@" " withString:@""]);
    tweet           = [tweet stringByAppendingString:[NSString stringWithFormat:@"\n%@",kShareURL]];
    [_twitterManager composeTweetWithText:tweet andImage:nil inViewController:self withCompletionHandler:^(BOOL isTweeted) {
        
    }];
}

- (void)requestDidCompleteWithResponse:(NSDictionary*)response {
    // Request completd with MasterClassDetails
    NSDictionary *masterClassDetails = [response objectForKey:kMasterClassDetail];
    _groupSession = [[KCGroupSession alloc] initWithMasterclassDetail:masterClassDetails];
    
    self.masterClassDetailScrollView.hidden = NO;
    [self.masterchefImageView setImageWithURL:[NSURL URLWithString:_groupSession.masterChefImageURL] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    // Set if Masterclass is free
    if(_groupSession.isFree) {
        self.freeClassLabel.hidden = false;
        self.freeClassLabel.labelText = [NSLocalizedString(@"free", nil) uppercaseString];
        self.freeClassLabel.labelFont = [UIFont setRobotoFontBoldStyleWithSize:14];
    }
    else {
        self.freeClassLabel.hidden = true;
    }
    
    self.masterchefNameLabel.text  = [_groupSession.chefName uppercaseString];
    [self.masterchefLocationButton setTitle:[NSString stringWithFormat:@"  %@", _groupSession.chefLocation] forState:UIControlStateNormal];
    
    NSTimeInterval timeInterval = [NSDate getSecondsFromDate:_groupSession.scheduleDate] + [NSDate getGMTOffSet];
    NSString  *monthName        = [NSDate getMonthFromTimeInterval:timeInterval];
    NSInteger date              = [NSDate getDateFromTimeInterval:timeInterval];
    NSString  *hour             = [NSDate getHourAndMinuteFromTimeInterval:timeInterval];
    
    self.playVideoButton.hidden = ![NSString validateString:_groupSession.videoURL];
    
    NSString *dateText  = [NSString stringWithFormat:@"%@ %@",[monthName uppercaseString], [KCUtility getValueSuffix:date]];
    NSDate *scheduleDate = [[NSDate alloc] initWithTimeIntervalSince1970: timeInterval];
    if ([NSCalendar.currentCalendar isDateInToday:scheduleDate]) {
        dateText = [NSLocalizedString(@"today", nil) uppercaseString];
    }
    else if ([NSCalendar.currentCalendar isDateInTomorrow:scheduleDate]) {
        dateText = [NSLocalizedString(@"tomorrow", nil) uppercaseString];
    }
    self.dateAndMonthLabel.text = dateText;
    self.timeLabel.text = [hour stringByAppendingString:@" ET"];
    
    NSMutableParagraphStyle *paragraphStyles = [[NSMutableParagraphStyle alloc] init];
    paragraphStyles.alignment = NSTextAlignmentLeft;
    paragraphStyles.firstLineHeadIndent = 1.0;
    NSDictionary *attributes = @{NSParagraphStyleAttributeName: paragraphStyles};
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:_groupSession.chefAttribute attributes: attributes];
    self.aboutMasterchefLabel.attributedText = attributedString;
    self.attendButtonView.hidden             = NO;
}

- (void)setMasterclassPurchaseStatus:(BOOL)hasPurhcased {
    if(hasPurhcased) {
        self.attendButton.userInteractionEnabled = NO;
        [self.attendButton setTitle:[NSLocalizedString(@"attending", nil) uppercaseString] forState:UIControlStateNormal];
        [self.attendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.attendButton setBackgroundColor:[UIColor appGreenColor]];
        self.attendCheckmarkImageView.hidden = NO;
    }
    else {
        // Check if the Masterclass is Full
        self.attendButton.userInteractionEnabled = YES;
        [self.attendButton setTitle:[NSLocalizedString(@"attend", nil) uppercaseString] forState:UIControlStateNormal];
        [self.attendButton setBackgroundColor:[UIColor appBackgroundColor]];
        self.attendCheckmarkImageView.hidden     = YES;
        [self.attendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}

- (void)openWebPageForURL:(NSString*)url {
    // Open web page to show the link
    SFSafariViewController *safariViewController = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:url]];
    [self presentViewController:safariViewController animated:true completion:^{
        
    }];
}

- (void)playVideoWithURL:(NSString*)url {
    // Open web view for play the video
   /* KCAppWebViewViewController *webViewController = [self.storyboard instantiateViewControllerWithIdentifier:appWebViewController];
    webViewController.urlToOpen = url;
    [self presentViewController:webViewController animated:YES completion:^{
        
    }]; */
    
    SFSafariViewController *safariViewController = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:url]];
    [self presentViewController:safariViewController animated:true completion:^{
        
    }];
}

- (void)didPurchaseMasterClass {
    // Called when MasterClass purchased successfully
    self.attendButton.enabled = NO;
    
    // Refresh user schedule silently
    NSDictionary *params = @{kUserID:_userProfile.userID, kAcessToken:_userProfile.accessToken, kCurrentDate:[NSDate getCurrentDateInUTC]};
    [_userScheduleWebManager refreshUseScheduleWithParameters:params];
    [self setMasterclassPurchaseStatus:YES];
}

- (void)gotoMyPreferencesScreen {
    // Push MyPreferences screen for In-App purchase of Keychn points
    UIViewController *myPreferencesViewControlelr = [self.storyboard instantiateViewControllerWithIdentifier:myPreferenceViewController];
    [self.navigationController pushViewController:myPreferencesViewControlelr animated:YES];
}

#pragma mark - Server End Code

- (void)getMasterClassDetails {
    // Fetch MaterClass From Server
    if(isNetworkReachable) {
        __weak id weakSelf = self;
        NSDictionary *params = @{kUserID:_userProfile.userID, kAcessToken:_userProfile.accessToken, kMasterClassID:self.masterClassID};
        [KCProgressIndicator showNonBlockingIndicator];
        [_groupSessionManager getMasterClassDetailsWithParameter:params withCompletionHandler:^(NSDictionary *responseDictionary) {
            // Request completed with success
            [weakSelf requestDidCompleteWithResponse:responseDictionary];
            [KCProgressIndicator hideActivityIndicator];
        } andFailure:^(NSString *title, NSString *message) {
            // Request failed with error
            if(isNetworkReachable) {
                [weakSelf getMasterClassDetails];
            }
            else {
                [KCProgressIndicator hideActivityIndicator];
                [KCUIAlert showInformationAlertWithHeader:title message:message withButtonTapHandler:^{
                    
                }];
            }
            
        }];
    }
    else {
        [KCUIAlert showInformationAlertWithHeader:NSLocalizedString(@"networkError", nil) message:NSLocalizedString(@"tryReconnecting", nil) withButtonTapHandler:^{
            
        }];
    }
}

- (void)buyMasterClassSpot {
    // Buy a spot for MasterClass
    if(isNetworkReachable) {
        [KCProgressIndicator showProgressIndicatortWithText:NSLocalizedString(@"bookASlot", nil)];
        NSDictionary *params = @{kUserID:_userProfile.userID, kAcessToken:_userProfile.accessToken, kMasterClassID:self.masterClassID};
        __weak KCMasterClassViewController *weakSelf = self;
        [_groupSessionManager buyMasterClassSpotWithParameter:params withCompletionHandler:^(NSString *title, NSString *message) {
            // Request completed with success
            [KCProgressIndicator hideActivityIndicator];
            [KCUIAlert showInformationAlertWithHeader:NSLocalizedString(@"congrats", nil) message:NSLocalizedString(@"beReadyForMasterclass", nil) withButtonTapHandler:^{
                
            }];
            
            // Masterclass slot requested
            [weakSelf didPurchaseMasterClass];
            
        } andFailure:^(NSString *title, NSString *message) {
            // Request failed with error
            if(isNetworkReachable) {
                [weakSelf buyMasterClassSpot];
            }
            else {
                [KCProgressIndicator hideActivityIndicator];
                [KCUIAlert showInformationAlertWithHeader:title message:message withButtonTapHandler:^{
                    
                }];

            }
        }];
        
    }
    else {
        [KCUIAlert showInformationAlertWithHeader:NSLocalizedString(@"networkError", nil) message:NSLocalizedString(@"tryReconnecting", nil) withButtonTapHandler:^{
            
        }];
    }
}
     
     @end
