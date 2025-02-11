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

#define kMasterClassTimeOffSet 900 // Allow users to join MasterClass upto 15 minutes of shceduled session

#define MASTERCLASS_PRE_TEXT(s) [NSString stringWithFormat:@"Get the chance to interact with #%@ at the next #keychn #masterclass",s]
#define kBaseHeight  243
#define kBaseWidth   400
#define kAspectRatioFactor 1.64

@interface KCMasterClassViewController () {
    KCUserProfile               *_userProfile;
    KCGroupSessionWebManager    *_groupSessionManager;
    KCFacebookManager           *_facebookManager;
    KCTwitterManager            *_twitterManager;
    NSInteger                   _labelHeight;
    KCSubscription              *_subscriptionAlertView;
    IAPSubscription             *_iapSubscription;
    KCUserScheduleWebManager    *_userScheduleWebManager;
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

#pragma mark - Button Actions

- (IBAction)backButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)attendMasterclassButtonTapped:(id)sender {
    // Buy a spot for MasterClass
    
    // Show subscription alert if user hasn't purchased the subscription yet
    _iapSubscription        = [IAPSubscription subscriptionForUser:_userProfile.userID];
    if(!_iapSubscription) {
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

- (IBAction)shareButtonTapped:(UIButton*)sender {
    // Show Action Sheet for Twitter and Facebook options
    if(self.groupSession.chefName) {
        __weak id weakSelf = self;
        UIAlertController *alert =   [UIAlertController
                                      alertControllerWithTitle:AppLabel.lblShareWith
                                      message:nil
                                      preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *facebookAction = [UIAlertAction
                                         actionWithTitle:AppLabel.btnFacebook
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action)
                                         {
                                             [weakSelf shareMasterClassOnFacebook];
                                             [alert dismissViewControllerAnimated:YES completion:nil];
                                             
                                         }];
        UIAlertAction *twitterAction = [UIAlertAction
                                        actionWithTitle:AppLabel.btnTwitter
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action)
                                        {
                                            [weakSelf shareMasterClassOnTwitter];
                                            [alert dismissViewControllerAnimated:YES completion:nil];
                                            
                                        }];
        
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:AppLabel.btnCancel
                                       style:UIAlertActionStyleDestructive
                                       handler:^(UIAlertAction * action)
                                       {
                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                           
                                       }];
        
        [alert addAction:facebookAction];
        [alert addAction:twitterAction];
        [alert addAction:cancelAction];
        
        if([KCUtility getiOSDeviceType] == iPad) {
            [alert setModalPresentationStyle:UIModalPresentationPopover];
            
            UIPopoverPresentationController *popPresenter = [alert
                                                             popoverPresentationController];
            popPresenter.sourceView = sender;
            popPresenter.sourceRect = sender.bounds;
//            alert.popoverPresentationController.sourceView = self.view;
        }
        [self presentViewController:alert animated:YES completion:nil];
    }
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"masterclass_share_icon"
         properties:@{@"masterclass_id":_groupSession.sessionID, @"chef_name":self.groupSession.chefName}];
    
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

#pragma mark - Instance Methods

- (void)customizeUI {
    // Set layout, font, color etc
    self.masterClassDetailScrollView.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setMasterclassPurchaseStatus:self.hasPurhcased];
}

- (BOOL)validateMasterClassTime {
    // Validate the MasterClass time has not been expired
    NSTimeInterval timeInterval = [NSDate getSecondsFromDate:_groupSession.scheduleDate] + [NSDate getGMTOffSet];
    NSTimeInterval currentTimeInterval = [[NSDate date] timeIntervalSince1970] - kMasterClassTimeOffSet;
    if(DEBUGGING) NSLog(@"Scheduled Time Interval and Current %f Time Inteval %f",timeInterval,currentTimeInterval);
    __weak KCMasterClassViewController *weakSelf = self;
    if(timeInterval <= currentTimeInterval) {
        [KCUIAlert showInformationAlertWithHeader:AppLabel.errorTitle message:AppLabel.masterClassBookingSlotExpired withButtonTapHandler:^{
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

- (BOOL)validateKeychnPoints {
    // Validate that use has sufficient credits for buying a spot in MasterClass
    if([_userProfile.credits integerValue] < [_groupSession.amount integerValue]) {
        [KCUIAlert showAlertWithButtonTitle:AppLabel.btnBuyNow alertHeader:AppLabel.errorTitle message:AppLabel.donotHaveSufficientCredit withButtonTapHandler:^(BOOL positiveButton) {
            if(positiveButton) {
                // Goto MyPreferences for In-App purchase
                [self gotoMyPreferencesScreen];
            }
        }];
        return NO;
    }
    return YES;
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
    
    self.playVideoButton.hidden = YES;
    [self.masterchefImageView setImageWithURL:[NSURL URLWithString:_groupSession.masterChefImageURL] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.playVideoButton.hidden = NO;
    } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    self.masterchefNameLabel.text  = [_groupSession.chefName uppercaseString];
    [self.masterchefLocationButton setTitle:[NSString stringWithFormat:@"  %@", _groupSession.chefLocation] forState:UIControlStateNormal];
    
    NSTimeInterval timeInterval = [NSDate getSecondsFromDate:_groupSession.scheduleDate] + [NSDate getGMTOffSet];
    NSString  *monthName        = [NSDate getMonthFromTimeInterval:timeInterval];
    NSInteger date              = [NSDate getDateFromTimeInterval:timeInterval];
    NSString  *hour             = [NSDate getHourAndMinuteFromTimeInterval:timeInterval];
    
    self.playVideoButton.hidden = ![NSString validateString:_groupSession.videoURL];
    
    self.dateAndMonthLabel.text = [NSString stringWithFormat:@"%@ %@%@",[monthName uppercaseString], [NSNumber numberWithInteger:date],[KCUtility getValueSuffix:date]];
    self.timeLabel.text = [hour stringByAppendingString:@" ET"];
    
    NSMutableParagraphStyle *paragraphStyles = [[NSMutableParagraphStyle alloc] init];
    paragraphStyles.alignment = NSTextAlignmentLeft;
    paragraphStyles.firstLineHeadIndent = 1.0;
    NSDictionary *attributes = @{NSParagraphStyleAttributeName: paragraphStyles};
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:_groupSession.chefAttribute attributes: attributes];
    self.aboutMasterchefLabel.attributedText = attributedString;
    self.masterClassDetailScrollView.hidden = NO;
}

- (void)setMasterclassPurchaseStatus:(BOOL)hasPurhcased {
    if(hasPurhcased) {
        self.attendButton.userInteractionEnabled = NO;
        [self.attendButton setTitle:[AppLabel.lblAttending uppercaseString] forState:UIControlStateNormal];
        [self.attendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.attendButton setBackgroundColor:[UIColor appGreenColor]];
        self.attendCheckmarkImageView.hidden = NO;
    }
    else {
        // Check if the Masterclass is Full
        if(self.isFullCapacity) {
            self.attendButton.userInteractionEnabled = NO;
            [self.attendButton setTitle:[AppLabel.lblFullCapacity uppercaseString] forState:UIControlStateNormal];
            [self.attendButton setBackgroundColor:[UIColor masterclasFullButtonColor]];
        }
        else {
            self.attendButton.userInteractionEnabled = YES;
            [self.attendButton setTitle:[AppLabel.lblAttend uppercaseString] forState:UIControlStateNormal];
            [self.attendButton setBackgroundColor:[UIColor appBackgroundColor]];
        }
        self.attendCheckmarkImageView.hidden     = YES;
        [self.attendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}

- (void)openWebPageForURL:(NSString*)url {
    // Open web page to show the link
    KCAppWebViewViewController *webViewController = [self.storyboard instantiateViewControllerWithIdentifier:appWebViewController];
    webViewController.urlToOpen = url;
    [self.navigationController pushViewController:webViewController animated:YES];
}

- (void)playVideoWithURL:(NSString*)url {
    // Open web view for play the video
    KCAppWebViewViewController *webViewController = [self.storyboard instantiateViewControllerWithIdentifier:appWebViewController];
    webViewController.urlToOpen = url;
    [self presentViewController:webViewController animated:YES completion:^{
        
    }];
}

- (void)didPurchaseMasterClass {
    // Called when MasterClass purchased successfully
    self.attendButton.enabled = NO;
    
    // Refresh user schedule silently
    NSDictionary *params = @{kUserID:_userProfile.userID, kAcessToken:_userProfile.accessToken, kLanguageID:_userProfile.languageID, kCurrentDate:[NSDate getCurrentDateInUTC]};
    [_userScheduleWebManager refreshUseScheduleWithParameters:params];
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
        NSDictionary *params = @{kUserID:_userProfile.userID, kAcessToken:_userProfile.accessToken, kLanguageID:_userProfile.languageID, kMasterClassID:self.masterClassID};
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
        [KCUIAlert showInformationAlertWithHeader:AppLabel.errorTitle message:AppLabel.internetNotAvailable withButtonTapHandler:^{
            
        }];
    }
}

- (void)buyMasterClassSpot {
    // Buy a spot for MasterClass
    if(isNetworkReachable) {
        [KCProgressIndicator showProgressIndicatortWithText:AppLabel.activityRequestingAMasterClassSpot];
        NSDictionary *params = @{kUserID:_userProfile.userID, kAcessToken:_userProfile.accessToken, kLanguageID:_userProfile.languageID, kMasterClassID:self.masterClassID};
        __weak KCMasterClassViewController *weakSelf = self;
        [_groupSessionManager buyMasterClassSpotWithParameter:params withCompletionHandler:^(NSString *title, NSString *message) {
            // Request completed with success
            [KCProgressIndicator hideActivityIndicator];
            [KCUIAlert showInformationAlertWithHeader:AppLabel.alertTitleCongratulations message:AppLabel.alertMessageGetReadyWithTheFork withButtonTapHandler:^{
                
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
        [KCUIAlert showInformationAlertWithHeader:AppLabel.errorTitle message:AppLabel.internetNotAvailable withButtonTapHandler:^{
            
        }];
    }
}

@end
