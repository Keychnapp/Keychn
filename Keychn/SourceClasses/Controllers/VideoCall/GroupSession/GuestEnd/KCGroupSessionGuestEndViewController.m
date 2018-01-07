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
#import "KCNavigationController.h"

typedef NS_ENUM(NSUInteger, VideoCallUpdateStatus) {
    START_CALL,
    END_CALL
};

@interface KCGroupSessionGuestEndViewController () {
    KCAgoraCallManager *_videoCallManager;
    KCUserProfile      *_userProfile;
    NSString           *_loginUsername;
    NSTimer            *_countdownTimer;
    NSInteger          _countdownSeconds;
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
@property (weak, nonatomic) IBOutlet UIView *timerView;
@property (weak, nonatomic) IBOutlet UILabel *countdownTimerLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondsLabel;
@property (weak, nonatomic) IBOutlet UILabel *masterclassStartsInLabel;
@property (weak, nonatomic) IBOutlet UIButton *joinLaterButton;
@property (weak, nonatomic) IBOutlet UIView *secondCameraView;
@property (weak, nonatomic) IBOutlet UIView *videoFeedView;
@property (weak, nonatomic) IBOutlet UIView *localPreviewView;


// Second View Constraints
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondViewLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondViewTrailingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondViewBottomConstraint;

// First View Constraints
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstViewBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstViewTrailingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstViewLeadingConstraint;



@end

@implementation KCGroupSessionGuestEndViewController

#pragma mark - Life Cycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Get instances
    _userProfile        = [KCUserProfile sharedInstance];
    _videoCallManager   = [KCAgoraCallManager sharedInstance];
    
    // Login name is comprised of Email ID, User Display Name and isHosting flag.
    _loginUsername      = [NSString stringWithFormat:@"%@",_userProfile.userID];
    
    // Customize app UI
    [self customizeUI];
    
    _countdownSeconds = self.startTimeInterval - [[NSDate date] timeIntervalSince1970];
    if (_countdownSeconds > 0) {
        // Play a countdown timer
        [self playTimer];
    }
    else {
        // Start conference process
        self.timerView.hidden = YES;
        [self.timerView removeFromSuperview];
        [self autheticateTwilioSDKWithToken:nil];
    }
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

#pragma mark - Timer

- (void)playTimer {
    // Schedule a timer for Masterclass
    NSString *timerText = [KCUtility formatSeconds:_countdownSeconds];
    [self textChangeAnimationOnLabel:self.countdownTimerLabel withText:timerText];
    _countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countdownTimer) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_countdownTimer forMode:NSRunLoopCommonModes];
}

- (void)countdownTimer {
    // Reduce the seconds and set the text with animation
    if(_countdownSeconds > 0) {
        --_countdownSeconds;
        long seconds = [self.secondsLabel.text longLongValue];
        if(seconds > 0) {
            [self textChangeAnimationOnLabel:self.secondsLabel withText:[NSString stringWithFormat:@"%ld", (long)seconds-1]];
        }
        else {
            seconds = _countdownSeconds < 60 ? _countdownSeconds :  60;
            [self textChangeAnimationOnLabel:self.secondsLabel withText:[NSString stringWithFormat:@"%ld", seconds]];
            NSString *timerText = [KCUtility formatSeconds:--_countdownSeconds];
            [self textChangeAnimationOnLabel:self.countdownTimerLabel withText:timerText];
        }
    }
    else {
        [_countdownTimer invalidate];
        _countdownTimer = nil;
        
        // Start conference process when timer elapses
        __block CGRect frame = self.timerView.frame;
        frame.origin.y = -frame.size.height;
        [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
            self.timerView.frame = frame;
            self.timerView.alpha = 0.1;
        } completion:^(BOOL finished) {
            self.timerView.alpha = 0.0;
            [self.timerView removeFromSuperview];
            [self autheticateTwilioSDKWithToken:nil];
        }];
    }
}
    
#pragma mark - Animation
    
- (void)textChangeAnimationOnLabel:(UILabel *)label withText:(NSString *)text {
    // Perform text change animation on selected label
    [UIView transitionWithView:label
                      duration:0.7f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        label.text = text;
                        
                    } completion:nil];
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

- (IBAction)joinLaterButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}


#pragma mark - Instance Method

- (void)customizeUI {
    // Customize app UI
    self.recallButton.hidden = YES;
    
    // Set background color
    self.usernameContainerView.backgroundColor      = [UIColor appBackgroundColor];
    self.questionTurnButton.backgroundColor         = [UIColor questionTurnButtonBackgroundColor];
    self.flipCameraButton.backgroundColor           = [UIColor clearColor];
    
    // Adjust font for width
    self.usernameLabel.adjustsFontSizeToFitWidth = YES;
    
    // Set corner radius
    self.questionTurnButton.layer.cornerRadius = 20;
    
    self.usernameContainerView.layer.cornerRadius = 5.0;
    self.usernameContainerView.layer.masksToBounds = YES;
    
    // Set Language Text For Timers
    self.masterclassStartsInLabel.text = NSLocalizedString(@"masterclassStartsIn", nil);
    [self.joinLaterButton setTitle:NSLocalizedString(@"joinLater", nil) forState:UIControlStateNormal];
    
    // Add a PanGesture to make User Preview moveable
    UIPanGestureRecognizer *panGestureRecognizerForUserPreview = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveUserPreviewViewWithGesture:)];
    [self.previewView addGestureRecognizer:panGestureRecognizerForUserPreview];
    
    // Add a PanGesture to make Second CameraView moveable
    UIPanGestureRecognizer *panGestureRecognizerForSecondCameraView = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveUserPreviewViewWithGesture:)];
    [self.secondCameraView addGestureRecognizer:panGestureRecognizerForSecondCameraView];
    
    // Add a PanGesture to make Remote Video Movable
    UIPanGestureRecognizer *panGestureRecognizerForRemoteCameraView = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveUserPreviewViewWithGesture:)];
    [self.remoteVideoView addGestureRecognizer:panGestureRecognizerForRemoteCameraView];
    
    // Add Tap Gesutures to remote videos views to enable swap
    UITapGestureRecognizer *tapGestureRemoteView = [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(didTapCameraSwitch:)];
    [self.remoteVideoView addGestureRecognizer:tapGestureRemoteView];
    
    UITapGestureRecognizer *tapGestureSecondCameraView = [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(didTapCameraSwitch:)];
    [self.secondCameraView addGestureRecognizer:tapGestureSecondCameraView];
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
        [self updateGroupSessionStatusForUser:_userProfile.userID accessToken:_userProfile.accessToken groupSessionID:self.sessionID andUpdateType:kEnd];
        
        //Allow screen to dim
        [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)moveUserPreviewViewWithGesture:(UIPanGestureRecognizer*)panGestureRecognizer {
    if (panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGRect frame = panGestureRecognizer.view.frame;
        CGPoint translation = [panGestureRecognizer translationInView:panGestureRecognizer.view];
        frame.origin = CGPointMake(frame.origin.x + translation.x,
                                   frame.origin.y + translation.y);
        
        if(frame.origin.x > 0 && (frame.origin.x+frame.size.width) < self.view.frame.size.width && frame.origin.y > 0 && (frame.origin.y+frame.size.height) < self.view.frame.size.height) {
            [UIView animateWithDuration:0.2 animations:^{
                panGestureRecognizer.view.frame = frame;
            }];
        }
        [panGestureRecognizer setTranslation:CGPointZero inView:panGestureRecognizer.view];
    }
}

- (void)didTapCameraSwitch:(UIGestureRecognizer *)gestureRecognizer {
    // Switch Primary and Secondry camera
    if(CGRectGetHeight(gestureRecognizer.view.frame) != CGRectGetHeight(self.view.frame)) {
        // View tapped which is not currently full screen, hence should be swapped
        [self performSelector:@selector(shuffleViewIndex:) withObject:gestureRecognizer.view afterDelay:0.5];
        if(gestureRecognizer.view == self.remoteVideoView) {
            // First view tapped
            self.firstViewTopConstraint.priority        = 900;
            self.firstViewBottomConstraint.priority     = 900;
            self.firstViewLeadingConstraint.priority    = 900;
            self.firstViewTrailingConstraint.priority   = 900;
            
            self.secondViewTopConstraint.priority       = 750;
            self.secondViewBottomConstraint.priority    = 750;
            self.secondViewLeadingConstraint.priority   = 750;
            self.secondViewTrailingConstraint.priority  = 750;
        }
        else {
            // Second view tapped
            self.firstViewTopConstraint.priority        = 600;
            self.firstViewBottomConstraint.priority     = 600;
            self.firstViewLeadingConstraint.priority    = 600;
            self.firstViewTrailingConstraint.priority   = 600;
            
            self.secondViewTopConstraint.priority       = 900;
            self.secondViewBottomConstraint.priority    = 900;
            self.secondViewLeadingConstraint.priority   = 900;
            self.secondViewTrailingConstraint.priority  = 900;
        }
        
        [UIView animateWithDuration:1 animations:^{
            [self.videoFeedView layoutIfNeeded];
        }];
    }
}

- (void)shuffleViewIndex:(UIView *)view {
    [self.videoFeedView sendSubviewToBack: view];
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

#pragma mark - Agora Call

- (void)autheticateTwilioSDKWithToken:(NSString *)token {    
    // Autheticate Twilio Token
    __weak id weakSelf = self;
    [KCProgressIndicator showProgressIndicatortWithText:NSLocalizedString(@"openingCamera", nil)];
    [_videoCallManager autheticateClientWithToken:token withRole:self.role hasAutheticated:^(BOOL status) {
        if(status) {
            // Open user preview using front camera
            [weakSelf setupUserPreview];
        }
    }];
}

- (void)setupUserPreview {
    // Set up user preview
    if(self.role == Speaker) {
        self.previewView.hidden = false;
        self.enableMikeButton.hidden = false;
        self.flipCameraButton.hidden = false;
    }
    else {
        // User joined as a Listner so no preview will be shown
        self.previewView.hidden = true;
        self.enableMikeButton.hidden = true;
        self.flipCameraButton.hidden = true;
    }
    [_videoCallManager showUserPreviewOnView:self.localPreviewView withUserIdentifier:_userProfile.userID];
    [KCProgressIndicator hideActivityIndicator];
    // Join conference
    __weak KCGroupSessionGuestEndViewController *weakSelf = self;
    _videoCallManager.isGroupSession                      = YES;
    _videoCallManager.hostID                              = [self.chefUserID integerValue];
    _videoCallManager.secondCameraId                      = kSecondCameraId;
    [_videoCallManager joinConferenceWithID:self.conferenceID userID:_userProfile.userID withRemoteVideoView:self.remoteVideoView andSecondCameraView:self.secondCameraView withCompletionHandler:^(BOOL status) {
        if(status) {
            // Joined the conference
            [weakSelf connectedToConference];
        }
    }];
    
    // If Host is disconnected then close the Question Turn Button
    [_videoCallManager monitorParticipantStaus:^(BOOL isConnected, NSString *participantID) {
        if(isConnected) {
           // Partcipant connected
            if(participantID.integerValue == kSecondCameraId) {
                weakSelf.secondCameraView.hidden = NO;
            }
        }
        else {
            // Participnat disconnected from conference
            if([participantID integerValue] == [weakSelf.chefUserID integerValue]) {
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

- (void)updateGroupSessionStatusForUser:(NSNumber *)userID accessToken:(NSString *)accessToken groupSessionID:(NSNumber *)sessionID andUpdateType:(NSString *)updateType {
    // Update Group session status on server for guest user in Group Session
    KCGroupSessionWebManager  *groupSessionWebManager = [KCGroupSessionWebManager new];
    NSDictionary *parameters = @{kUserID: userID, kAcessToken:accessToken, kSessionID:sessionID, kUpdateType:updateType};
    // Network request to update the group session status
    [groupSessionWebManager updateGroupSessionStatusWithParameter:parameters withCompletionHandler:^(NSString *title, NSString *message) {
        
    } andFailure:^(NSString *title, NSString *message) {
        
    }];
    
}

@end
