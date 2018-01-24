//
//  KCGroupSessionHostEndViewController.m
//  Keychn
//
//  Created by Keychn Experience SL on 25/04/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import "KCGroupSessionHostEndViewController.h"
#import "KCVideoPanelFeed.h"
#import <AVFoundation/AVFoundation.h>
#import "KCVideoPanelFeed.h"
#import "KCGroupSessionWebManager.h"
#import "KCAgoraCallManager.h"
#import <AgoraRtcEngineKit/AgoraRtcEngineKit.h>

@interface KCGroupSessionHostEndViewController () <AgoraRtcEngineDelegate, CAAnimationDelegate> {
    KCUserProfile               *_userProfile;
    NSMutableDictionary         *_liveFeedPanelWithNameDictionary;
    KCGroupSessionWebManager    *_groupSessionWebManager;
    KCAgoraCallManager          *_videoCallManager;
    NSMutableDictionary         *_usernameDictionary;
    NSTimer                     *_countdownTimer;
    NSInteger                   _countdownSeconds;
}


@property (strong, nonatomic) IBOutletCollection(KCVideoPanelFeed) NSArray *videoFeedPanelsArray;
@property (weak, nonatomic) IBOutlet UIButton *endCallButton;
@property (weak, nonatomic) IBOutlet UIView *previewView;
@property (weak, nonatomic) IBOutlet UIView *timerView;
@property (weak, nonatomic) IBOutlet UILabel *countdownTimerLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondsLabel;
@property (weak, nonatomic) IBOutlet UILabel *masterclassStartsInLabel;
@property (weak, nonatomic) IBOutlet UIButton *joinLaterButton;




#pragma mark Video SDK components
@property (strong, nonatomic) AgoraRtcEngineKit *agoraKit;
@property (strong, nonatomic) AgoraRtcVideoCanvas *localVideoCanvas;



@end

@implementation KCGroupSessionHostEndViewController

#pragma mark - Life Cycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Get instances
    _userProfile                     = [KCUserProfile sharedInstance];
    _videoCallManager                = [[KCAgoraCallManager alloc] init];
    _liveFeedPanelWithNameDictionary = [[NSMutableDictionary alloc] init];
    _groupSessionWebManager          = [KCGroupSessionWebManager new];
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
        // Get selected participant names and user id for the current session
        [self getParticipantNames];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if(DEBUGGING) NSLog(@"didReceiveMemoryWarning in host live feed");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self registerForAppDelegateNotification];
    // Change orientation to landscape
    [[UIDevice currentDevice] setValue:@(UIInterfaceOrientationLandscapeLeft) forKey:@"orientation"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self removeAppDelegateNotification];
    // Change orientation to Portratit
    [[UIDevice currentDevice] setValue:@(UIInterfaceOrientationPortrait) forKey:@"orientation"];
}

#pragma mark - Customize UI

- (void) customizeUI {
    
    // Set Language Text For Timers
    self.masterclassStartsInLabel.text = NSLocalizedString(@"masterclassStartsIn", nil);
    [self.joinLaterButton setTitle:NSLocalizedString(@"joinLater", nil) forState:UIControlStateNormal];
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
        long long seconds = [self.secondsLabel.text longLongValue];
        if(seconds > 0) {
            [self textChangeAnimationOnLabel:self.secondsLabel withText:[NSString stringWithFormat:@"%ld", (long)seconds-1]];
        }
        else {
            seconds = _countdownSeconds < 60 ? _countdownSeconds :  60;
            [self textChangeAnimationOnLabel:self.secondsLabel withText:[NSString stringWithFormat:@"%lld", seconds]];
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
            [self getParticipantNames];
        }];
    }
}

#pragma mark - Agora Call

- (void)authenticateClientWithAppIdentifier:(NSString *)appIdentifier {
    self.agoraKit = [AgoraRtcEngineKit sharedEngineWithAppId:appIdentifier delegate:self];
    [self.agoraKit setChannelProfile:AgoraRtc_ChannelProfile_LiveBroadcasting];
    [self.agoraKit setClientRole:(AgoraRtc_ClientRole_Broadcaster) withKey:[NSString stringWithFormat:@"%ld",Masterchef]];
    [self.agoraKit createDataStream:&(DataStreamIndentifier) reliable:YES ordered:YES];
    [self setupUserPreview];
}

- (void)setupUserPreview {
    // Set up user preview
    [self.agoraKit enableVideo];
    [self.agoraKit setVideoProfile:AgoraRtc_VideoProfile_720P swapWidthAndHeight: false];
    // Default mode is disableVideo
    self.localVideoCanvas = [[AgoraRtcVideoCanvas alloc] init];
    self.localVideoCanvas.uid = [_userProfile.userID integerValue];
    
    self.localVideoCanvas.view        = self.previewView;
    self.localVideoCanvas.renderMode  = AgoraRtc_Render_Hidden;
    [self.agoraKit setupLocalVideo:self.localVideoCanvas];
    [self.agoraKit startPreview];
    
    [self joinConferenceWithID:_conferenceID];
}

- (void)joinConferenceWithID:(NSString*)conferenceID {
    if(DEBUGGING) NSLog(@"Join conference with ID %@", conferenceID);

    [self.agoraKit joinChannelByKey:nil channelName:conferenceID info:@"Host" uid:[_userProfile.userID integerValue] joinSuccess:^(NSString *channel, NSUInteger uid, NSInteger elapsed) {
        [self.agoraKit setEnableSpeakerphone:YES];
        [self.agoraKit enableAudio];
        //Keeps the screen active when the call is going on
        [UIApplication sharedApplication].idleTimerDisabled = YES;
    }];
}

#pragma mark - Agora Connection Delegate

- (void)rtcEngine:(AgoraRtcEngineKit *)engine didJoinedOfUid:(NSUInteger)uid elapsed:(NSInteger)elapsed {
    if(DEBUGGING) NSLog(@"Parcipant didJoinedOfUid with uid %@", [NSNumber numberWithInteger:uid]);
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine didJoinChannel:(NSString*)channel withUid:(NSUInteger)uid elapsed:(NSInteger) elapsed {
    if(DEBUGGING) NSLog(@"Parcipant didJoinChannel with uid %@", [NSNumber numberWithInteger:uid]);
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine firstRemoteVideoDecodedOfUid:(NSUInteger)uid size: (CGSize)size elapsed:(NSInteger)elapsed {
    if(DEBUGGING) NSLog(@"Parcipant connected with uid %@", [NSNumber numberWithInteger:uid]);
    // Show the user video feed on Small sliced panel below the focused panel
    if(uid != kSecondCameraId) {
        NSString *participantId             = [NSString stringWithFormat:@"%lu",(unsigned long)uid];
        KCVideoPanelFeed *videoFeedPanel    =  [_liveFeedPanelWithNameDictionary objectForKey:participantId];
        if(!videoFeedPanel) {
            NSInteger count = [_usernameDictionary count];
            if(count < 5) {
                [_usernameDictionary setObject:@"Starcook" forKey:participantId];
                videoFeedPanel  = [self.videoFeedPanelsArray objectAtIndex:count];
                [_liveFeedPanelWithNameDictionary setObject:videoFeedPanel forKey:participantId];
            }
        }
        
        if(videoFeedPanel) {
            videoFeedPanel.hidden               = NO;
            videoFeedPanel.usernameLabel.text   = [_usernameDictionary objectForKey:participantId];
            videoFeedPanel.videoCanvas          = [[AgoraRtcVideoCanvas alloc] init];
            videoFeedPanel.videoRender          = [[UIView alloc] initWithFrame:videoFeedPanel.bounds];
            [videoFeedPanel.videoFeedPanel addSubview:videoFeedPanel.videoRender];
            videoFeedPanel.videoCanvas.view     = videoFeedPanel.videoRender;
            videoFeedPanel.videoCanvas.renderMode    = AgoraRtc_Render_Hidden;
            videoFeedPanel.videoCanvas.uid = uid;
            [self.agoraKit setupRemoteVideo:videoFeedPanel.videoCanvas];
        }
    }
}


- (void)rtcEngine:(AgoraRtcEngineKit *)engine didOfflineOfUid:(NSUInteger)uid reason:(AgoraRtcUserOfflineReason)reason {
    // User left the conference
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine receiveStreamMessageFromUid:(NSUInteger)uid streamId:(NSInteger)streamId data:(NSData*)data {
    // Did receive question turn request
    NSDictionary *userDataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:NULL];
    NSNumber *userID = [userDataDictionary objectForKey:kUserDetails];
    [self didReceiveDataForUser:userID];
}


#pragma mark - Camera and Audio Options

- (void) askForMicPermssion {
    //Ask for mic permission
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        
    }];
}

#pragma mark - Applicate State

-(void)didEnterBackground:(NSNotification*)note {
    //App going into backgorund
    if(DEBUGGING) NSLog(@"didEnterBackground --> LiveVideoCall");
    
    //Keeps the screen active when the call is going on
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}

- (void) didEnterForeground:(NSNotification*)notification {
    //Join conference again when app comes to foreground
    [self joinConferenceWithID:self.conferenceID];
    
    //Keeps the screen active when the call is going on
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
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


- (void)didReceiveDataForUser:(NSNumber *)userID {
}

#pragma mark - Button Action

- (IBAction)endCallButtonTapped:(id)sender {
    [self.agoraKit leaveChannel:^(AgoraRtcStats *stat) {
        [UIApplication sharedApplication].idleTimerDisabled = NO;
    }];
    
    [KCProgressIndicator showNonBlockingIndicator];
    
    // Complete Group session
    [self completeGroupSession];
    [KCProgressIndicator hideActivityIndicator];
}

- (IBAction)flipCameraButtonTapped:(id)sender {
    [self.agoraKit switchCamera];
}

- (IBAction)joinLaterButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Instance Method

- (void)gotoHomeScreen {
    // Back to Home View Controller
    if(DEBUGGING) NSLog(@"gotoHomeScreen --> Host end View Controller");
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSString*)getParticipantNameFromParticipantLoginID:(NSString*)loginID {
    // Spilit the login ID to get the name of user
    NSString *username = [_usernameDictionary objectForKey:loginID];
    return [username capitalizedString];
}

#pragma mark - Request Completion

- (void)didFetchUserNamesWithResponse:(NSDictionary *)response {
    // Usernames fetched from server
    _usernameDictionary         = [[NSMutableDictionary alloc] init];
    NSArray *participantArray   = [response objectForKey:kParticipant];
    
    if([participantArray isKindOfClass:[NSArray class]]) {
        NSInteger index = 0;
        for (NSDictionary *userDictionary in participantArray) {
            NSString *userID   = [userDictionary objectForKey:kUserID];
            if(userID.integerValue != kSecondCameraId) {
                NSString *username = [userDictionary objectForKey:kName];
                [_usernameDictionary setObject:username forKey:userID];
                [_liveFeedPanelWithNameDictionary setObject:[self.videoFeedPanelsArray objectAtIndex:index] forKey:userID];
                index++;
            }
        }
    }
    
    // Authetical video SDK and start preview
    if(!self.agoraKit) {
       [self authenticateClientWithAppIdentifier:kAgoraKeychnAppIdentifier];
    }
}

#pragma mark - Server End Code

- (void)getParticipantNames {
    // Network requsest to get the parcipant names
    if(isNetworkReachable) {
        [KCProgressIndicator showNonBlockingIndicator];
        __weak KCGroupSessionHostEndViewController *weakSelf = self;
        NSDictionary *params = @{kGroupSessionID:self.groupSessionID};
        [_groupSessionWebManager getParticipantNamesWithParameter:params withCompletionHandler:^(NSDictionary *response) {
            [KCProgressIndicator hideActivityIndicator];
            [weakSelf didFetchUserNamesWithResponse:response];
            // Fetched participant names
        } andFailure:^(NSString *title, NSString *message) {
            [KCProgressIndicator hideActivityIndicator];
            // Show failure alert
            [KCUIAlert showAlertWithButtonTitle:NSLocalizedString(@"retry", nil) alertHeader:title message:message withButtonTapHandler:^(BOOL positiveButton) {
                if(positiveButton) {
                    [weakSelf getParticipantNames];
                }
                else {
                    [weakSelf.navigationController popViewControllerAnimated: YES];
                }
            }];
        }];
    }
}

- (void)completeGroupSession {
    // Completes the MasterClass or ChewIt Session on server
    if(isNetworkReachable) {
        [KCProgressIndicator showNonBlockingIndicator];
        // Network requsest
        NSDictionary *params = @{kSessionID:self.groupSessionID};
        __weak id weakSelf = self;
        [_groupSessionWebManager completeGroupSessionWithParameter:params withCompletionHandler:^(NSString *title, NSString *message) {
            // Group Session Marked as complete successfully
            [KCProgressIndicator hideActivityIndicator];
            // Back to home screen and finish the Group session
            [weakSelf gotoHomeScreen];
            
        } andFailure:^(NSString *title, NSString *message) {
            // Failed to mark complete
            [KCProgressIndicator hideActivityIndicator];
            // Show failure alert
            [KCUIAlert showInformationAlertWithHeader:title message:message withButtonTapHandler:^{
                
            }];
        }];
    }
}

@end
