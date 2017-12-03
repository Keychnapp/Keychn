//
//  KCGroupSessionGuestEndViewController.m
//  Keychn
//
//  Created by Keychn Experience SL on 25/04/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import "KCGroupSessionGuestEndViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "KCGroupSessionWebManager.h"
#import "KCAgoraCallManager.h"


typedef NS_ENUM(NSUInteger, VideoCallUpdateStatus) {
    START_CALL,
    END_CALL
};

@interface KCGroupSessionGuestEndViewController () {
    KCAgoraCallManager *_videoCallManager;
    KCUserProfile      *_userProfile;
    NSString           *_loginUsername;
}

@property (weak, nonatomic) IBOutlet UIButton *questionTurnButton;
@property (weak, nonatomic) IBOutlet UILabel  *usernameLabel;
@property (weak, nonatomic) IBOutlet UIView *previewView;
@property (weak, nonatomic) IBOutlet UIView *remoteVideoView;
@property (weak, nonatomic) IBOutlet UIView *usernameContainerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *questionTurnContainerViewWidthConstraint;
@property (weak, nonatomic) IBOutlet UIView *questionTurnContainerView;
@property (weak, nonatomic) IBOutlet UILabel *haveAQuestionLabel;
@property (weak, nonatomic) IBOutlet UILabel *waitingCounterLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *questionTurnWidthConstraintiPad;
@property (weak, nonatomic) IBOutlet UIButton *recallButton;
@property (weak, nonatomic) IBOutlet UIButton *endCallButton;
@property (weak, nonatomic) IBOutlet UIButton *enableMikeButton;
@property (weak, nonatomic) IBOutlet UIButton *flipCameraButton;

@end

@implementation KCGroupSessionGuestEndViewController

#pragma mark - Life Cycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Get instances
    _userProfile        = [KCUserProfile sharedInstance];
    _videoCallManager   = [KCAgoraCallManager sharedInstance];
    // Login name is comprised of Email ID, User Display Name and isHosting flag.
    _loginUsername      = [NSString stringWithFormat:@"%@",_userProfile.userID];
    // Customize app UI
    [self customizeUI];
    
    // Start conference process
    [self autheticateTwilioSDKWithToken:nil];
    
    if(DEBUGGING) NSLog(@"Guest END --> viewDidLoad --> Chef ID %@",self.chefUserID);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Set text when view apppears
    [self setText];
    
    [self registerForAppDelegateNotification];
    
//    [self expandContractQuestionTurnBoxWithStatus:YES];
    
    // Change orientation to landscape
    [[UIDevice currentDevice] setValue:@(UIInterfaceOrientationLandscapeLeft) forKey:@"orientation"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self removeAppDelegateNotification];
    
    // Change orientation to Portratit
    [[UIDevice currentDevice] setValue:@(UIInterfaceOrientationPortrait) forKey:@"orientation"];
}


#pragma mark - Button Actions

- (IBAction)questionTurnButtonTapped:(id)sender {
    // Send a request for question
    [_videoCallManager sendQuestionTurnRequestWithDetail:_userProfile.userID];
}

- (IBAction)endCallButtonTapped:(id)sender {
    // Leave chat group
    [self leaveChatGroup];
}

- (IBAction)reconnectCallButtonTapped:(id)sender {
    
}

- (IBAction)enableMikeButtonTapped:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if(sender.isSelected) {
        [self unmuteUserVoice];
    }
    else {
        [self muteUserVoice];
    }
}


- (IBAction)flipCameraButtonTapped:(id)sender {
    [_videoCallManager flipCamera];
}


#pragma mark - Instance Method

- (void)customizeUI {
    // Customize app UI
    self.recallButton.hidden = YES;
    
    // Set background color
    self.usernameContainerView.backgroundColor      = [UIColor chefNameLabelBackgroundColor];
    self.questionTurnButton.backgroundColor         = [UIColor questionTurnButtonBackgroundColor];
    self.flipCameraButton.backgroundColor           = [UIColor clearColor];
    
    // Adjust font for width
    self.usernameLabel.adjustsFontSizeToFitWidth = YES;
    
    // Set corner radius
    self.questionTurnButton.layer.cornerRadius = 20;
}

- (void)setText {
    // Set text on buttons and labels
    self.usernameLabel.text = [KCUtility getFirstNameFromFullName:self.hostName];
}

- (void)expandContractQuestionTurnBoxWithStatus:(BOOL)shouldContract {
    if(shouldContract) {
        self.questionTurnContainerViewWidthConstraint.constant = 100;
        self.questionTurnWidthConstraintiPad.constant          = 148;
        self.waitingCounterLabel.text   = NSLocalizedString(@"waitForYourTurn", nil);
        self.waitingCounterLabel.hidden = YES;
        self.haveAQuestionLabel.hidden  = YES;
    }
    else {
        self.questionTurnContainerViewWidthConstraint.constant = 300;
        self.questionTurnWidthConstraintiPad.constant          = 300;
        self.waitingCounterLabel.hidden = NO;
        self.haveAQuestionLabel.hidden  = NO;
    }
    __weak KCGroupSessionGuestEndViewController *weakSelf = self;
    [UIView transitionWithView:self.questionTurnContainerView duration:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [weakSelf.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)leaveChatGroup {
    // Leave conference room gracefully
   BOOL status =  [_videoCallManager closeConference];
    
    if(status) {
        // Mark call end for this user on server
        [self updateGroupSessionStatusForUser:_userProfile.userID accessToken:_userProfile.accessToken languageID:_userProfile.languageID groupSessionID:self.sessionID andUpdateType:kEnd];
        
        //Allow screen to dim
        [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - App Delegate Notification

- (void)registerForAppDelegateNotification {
    //Register for app delegate notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterBackground:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterForeground:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)removeAppDelegateNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

-(void)didEnterBackground:(NSNotification*)note {
    //App going into backgorund
    if(DEBUGGING) NSLog(@"didEnterBackground --> LiveVideoCall");
    [self expandContractQuestionTurnBoxWithStatus:YES];
    
    //Keeps the screen active when the call is going on
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}

- (void) didEnterForeground:(NSNotification*)notification {
    //Join conference again when app comes to foreground
    [self expandContractQuestionTurnBoxWithStatus:YES];
    self.questionTurnContainerViewWidthConstraint.constant = 100;
    self.questionTurnWidthConstraintiPad.constant          = 148;
    [self.questionTurnContainerView updateConstraints];
    
    //Keeps the screen active when the call is going on
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}

#pragma mark - Twilio Call

- (void)autheticateTwilioSDKWithToken:(NSString *)token {
    // Autheticate Twilio Token
    __weak id weakSelf = self;
    [KCProgressIndicator showProgressIndicatortWithText:NSLocalizedString(@"openingCamera", nil)];
    [_videoCallManager autheticateClientWithToken:token hasAutheticated:^(BOOL status) {
        if(status) {
            // Open user preview using front camera
            [weakSelf setupUserPreview];
        }
    }];
}

- (void)setupUserPreview {
    // Set up user preview
    [_videoCallManager showUserPreviewOnView:self.previewView withUserIdentifier:_userProfile.userID];
    [KCProgressIndicator hideActivityIndicator];
    // Join conference
    __weak KCGroupSessionGuestEndViewController *weakSelf = self;
    _videoCallManager.isGroupSession = YES;
    _videoCallManager.hostID         = [self.chefUserID integerValue];
    [_videoCallManager joinConferenceWithID:self.conferenceID userID:_userProfile.userID withRemoteVideoView:self.remoteVideoView withCompletionHandler:^(BOOL status) {
        if(status) {
            // Joined the conference
            [weakSelf connectedToConference];
        }
    }];
    
    // If Host is disconnected then close the Question Turn Button
    [_videoCallManager monitorParticipantStaus:^(BOOL isConnected, NSString *participantID) {
        if(!isConnected) {
            // Participnat disconnected from conference
            if([participantID integerValue] == [self.chefUserID integerValue]) {
                // Chef disconnected from conference, leave chat and back to Home Screen
                [weakSelf leaveChatGroup];
            }
        }
    }];
}

- (void)connectedToConference {
    //Keeps the screen active when the call is going on
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    // User joined the conference. By default the audio of this user is silent but he can hear the voice
    [_videoCallManager enabledAudio:NO];
    
    // Listen for user data
    __weak id weakSelf = self;
    [_videoCallManager startListeningForUserData:^(NSInteger userID, NSArray *userData) {
        [weakSelf didReceiveData:userID data:userData];
    }];
}


#pragma mark - Camera and Audio Options

- (void) askForMicPermssion {
    //Ask for mic permission
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        
    }];
}


- (void)muteUserVoice {
    // Mutes user voice so that other user are not get disturbed
    [_videoCallManager enabledAudio:NO];
}

- (void)unmuteUserVoice {
    // Unmutes user voice when the turn comes up
    [_videoCallManager enabledAudio:YES];
}

- (void)didReceiveData:(NSInteger)uid data:(NSArray *)liveQueueArray {
    // Live queue postiion retrieved
    if([liveQueueArray isKindOfClass:[NSArray class]] && [liveQueueArray count] > 0 && [liveQueueArray containsObject:_loginUsername]) {
       NSInteger myPosition    = [liveQueueArray indexOfObject:_loginUsername];
        if(myPosition == 0) {
            self.waitingCounterLabel.text = NSLocalizedString(@"speakNow", nil);
            [self unmuteUserVoice];
            [self performSelector:@selector(muteUserVoice) withObject:nil afterDelay:kAllotedTimeForUser];
        }
        else {
            self.waitingCounterLabel.text = [NSString stringWithFormat:@"%@ %@", [NSNumber numberWithInteger:myPosition], NSLocalizedString(@"moreUsersBeforeYourTurn", nil)];
        }
        [self expandContractQuestionTurnBoxWithStatus:NO];
    }
    else {
        [self expandContractQuestionTurnBoxWithStatus:YES];
    }
    if(DEBUGGING) NSLog(@"didReceiveData %@", liveQueueArray);
}

#pragma mark - Server End

- (void)updateGroupSessionStatusForUser:(NSNumber *)userID accessToken:(NSString *)accessToken languageID:(NSNumber *)languageID groupSessionID:(NSNumber *)sessionID andUpdateType:(NSString *)updateType {
    // Update Group session status on server for guest user in Group Session
    KCGroupSessionWebManager  *groupSessionWebManager = [KCGroupSessionWebManager new];
    NSDictionary *parameters = @{kUserID: userID, kAcessToken:accessToken, kLanguageID:languageID, kSessionID:sessionID, kUpdateType:updateType};
    // Network request to update the group session status
    [groupSessionWebManager updateGroupSessionStatusWithParameter:parameters withCompletionHandler:^(NSString *title, NSString *message) {
        
    } andFailure:^(NSString *title, NSString *message) {
        
    }];
    
}

@end
