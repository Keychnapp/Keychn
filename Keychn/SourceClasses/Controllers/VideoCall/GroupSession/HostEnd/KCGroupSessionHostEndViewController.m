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
    KCUserProfile       *_userProfile;
    NSMutableArray      *_participantIDsArray;
    NSMutableDictionary *_liveFeedPanelWithNameDictionary;
    NSMutableArray      *_liveQueueArray;
    NSString            *_focusedUserID;
    KCGroupSessionWebManager *_groupSessionWebManager;
    KCAgoraCallManager     *_videoCallManager;
    NSString            *_loginUsername;
    NSMutableDictionary *_usernameDictionary;
    NSTimer            *_countdownTimer;
    NSInteger          _countdownSeconds;
}

@property (weak, nonatomic) IBOutlet UIView *roundView;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet KCVideoPanelFeed *focusedUserPreviewPanel;
@property (strong, nonatomic) IBOutletCollection(KCVideoPanelFeed) NSArray *videoFeedPanelsArray;
@property (weak, nonatomic) IBOutlet UIButton *recallButton;
@property (weak, nonatomic) IBOutlet UIButton *endCallButton;
@property (weak, nonatomic) IBOutlet UIView *previewView;
@property (weak, nonatomic) IBOutlet UIImageView *focusedUserAvatarImageView;
@property (weak, nonatomic) IBOutlet UIView *timerView;
@property (weak, nonatomic) IBOutlet UILabel *countdownTimerLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondsLabel;



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
    _participantIDsArray             = [[NSMutableArray alloc] init];
    _liveFeedPanelWithNameDictionary = [[NSMutableDictionary alloc] init];
    _liveQueueArray                  = [[NSMutableArray alloc] init];
    _loginUsername                   = [NSString stringWithFormat:@"%@",_userProfile.userID];
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
    self.questionLabel.layer.cornerRadius  = 20;
    self.questionLabel.layer.masksToBounds = YES;
    self.recallButton.hidden               = YES;
    
    // Set borders
    for (KCVideoPanelFeed *feedPanel in self.videoFeedPanelsArray) {
        feedPanel.layer.borderWidth = 1.0f;
        feedPanel.layer.borderColor = [UIColor appBackgroundColorWithOpacity:0.5].CGColor;
    }
}

#pragma mark - Animation

- (void)animateRing {
    // Set up the shape of the circle
    int radius = 26;
    CAShapeLayer *circle = [CAShapeLayer layer];
    // Make a circular shape
    circle.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 2.0*radius, 2.0*radius)
                                             cornerRadius:radius].CGPath;
    // Center the shape in self.view
    circle.position = CGPointMake(6,4);
    
    // Configure the apperence of the circle
    circle.fillColor = [UIColor clearColor].CGColor;
    circle.strokeColor = [UIColor questionTurnButtonBackgroundColor].CGColor;
    circle.lineWidth = 5;
    
    // Add to parent layer
    [self.roundView.layer addSublayer:circle];
    
    // Configure animation
    CABasicAnimation *drawAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    drawAnimation.duration            = kAllotedTimeForUser; // animate ring for specified duration
    drawAnimation.repeatCount         = 1.0;  // Animate only once..
    drawAnimation.delegate            = self;
    
    // Animate from no part of the stroke being drawn to the entire stroke being drawn
    drawAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    drawAnimation.toValue   = [NSNumber numberWithFloat:1.0f];
    
    // Experiment with timing to get the appearence to look the way you want
    drawAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    // Add the animation to the circle
    [circle addAnimation:drawAnimation forKey:@"drawCircleAnimation"];
    
    [self performSelector:@selector(animationDidStop) withObject:nil afterDelay:kAllotedTimeForUser];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
}


- (void)animationDidStop {
    // Animation stopped then stop the focused user question and start over again
     if(DEBUGGING) NSLog(@"animationDidStop");
    // Broadcast the live queue again
    if(DEBUGGING) NSLog(@"Live quer Before removal %@", _liveQueueArray);
    [_liveQueueArray removeObject:_focusedUserID];
    [self broadCastLiveQueue];
    
    NSArray *subLayers = self.roundView.layer.sublayers;
    if([subLayers count] > 0) {
        CAShapeLayer *shapeLayer = [subLayers firstObject];
        [shapeLayer removeFromSuperlayer];
    }
    if(DEBUGGING) NSLog(@"Live quer after removal %@", _liveQueueArray);
    if([_liveQueueArray count] > 0) {
        // Changed focused user
        NSString *nextUserID = [_liveQueueArray firstObject];
        if(![nextUserID isEqualToString:_focusedUserID]) {
            [self animateRing];
          [self shuffleFocusedUser:_focusedUserID withAnotherUser:nextUserID];
        }
    }
}

- (void)removeAnimation {
    NSArray *subLayers = self.roundView.layer.sublayers;
    if([subLayers count] > 0) {
        CAShapeLayer *shapeLayer = [subLayers firstObject];
        [shapeLayer removeFromSuperlayer];
    }
    [self broadCastLiveQueue];
}

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
            [self getParticipantNames];
        }];
    }
}

#pragma mark - Agora Call

- (void)authenticateClientWithAppIdentifier:(NSString *)appIdentifier {
    self.agoraKit           = [AgoraRtcEngineKit sharedEngineWithAppId:appIdentifier delegate:self];
    [self.agoraKit setChannelProfile:AgoraRtc_ChannelProfile_Communication];
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
    NSString *participantID  = [NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:uid]];
    
    // If the username is not available with this parcipant id then fetch the name from server first
    if(![[_usernameDictionary allKeys] containsObject:participantID]) {
        [self getParticipantNames];
    }
    
    // Start live feed for joined participnat
    if(![_participantIDsArray containsObject:participantID]) {
        [_participantIDsArray addObject:participantID];
        if(DEBUGGING) NSLog(@"Participant Array %@",_participantIDsArray);
        if([_participantIDsArray count] == 1) {
            // Show the user viedo feed on focused panel
            self.focusedUserPreviewPanel.hidden = NO;
            _focusedUserID                      = [NSString stringWithFormat:@"%@",participantID];
            self.usernameLabel.text             = [self getParticipantNameFromParticipantLoginID:participantID];
            self.focusedUserPreviewPanel.videoCanvas = [[AgoraRtcVideoCanvas alloc] init];
            self.focusedUserPreviewPanel.videoRender = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 664)];
            [self.focusedUserPreviewPanel.videoFeedPanel addSubview:self.focusedUserPreviewPanel.videoRender];
            self.focusedUserPreviewPanel.videoCanvas.view = self.focusedUserPreviewPanel.videoRender;
            self.focusedUserPreviewPanel.videoCanvas.renderMode  = AgoraRtc_Render_Hidden;
            self.focusedUserPreviewPanel.videoCanvas.uid = uid;
            [_liveFeedPanelWithNameDictionary setObject:self.focusedUserPreviewPanel forKey:participantID];
            [self.agoraKit setupRemoteVideo:self.focusedUserPreviewPanel.videoCanvas];
        }
        else {
            // Show the user video feed on Small sliced panel below the focused panel
            NSInteger liveUserCount          = [_participantIDsArray count];
            NSInteger effectiveIndex         = liveUserCount - 2;
            KCVideoPanelFeed *videoFeedPanel =  [self.videoFeedPanelsArray objectAtIndex:effectiveIndex];
            videoFeedPanel.hidden              = NO;
            videoFeedPanel.shortnameLabel.text = [self getParticipantNameFirstCharFromParticipantLoginID:participantID];
            [_liveFeedPanelWithNameDictionary setObject:videoFeedPanel forKey:participantID];
            videoFeedPanel.shortnameLabel.text  = [self getParticipantNameFirstCharFromParticipantLoginID:participantID];
            videoFeedPanel.shortnameLabel.hidden     = NO;
            videoFeedPanel.questionLabel.hidden      = YES;
            videoFeedPanel.queuePositionLabel.hidden = YES;
            videoFeedPanel.videoCanvas               = [[AgoraRtcVideoCanvas alloc] init];
            videoFeedPanel.videoRender               = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 146, 180)];
            [videoFeedPanel.videoFeedPanel addSubview:videoFeedPanel.videoRender];
            videoFeedPanel.videoCanvas.view          = videoFeedPanel.videoRender;
            videoFeedPanel.videoCanvas.renderMode    = AgoraRtc_Render_Hidden;
            videoFeedPanel.videoCanvas.uid = uid;
            [self.agoraKit setupRemoteVideo:videoFeedPanel.videoCanvas];
        }
    }
}


- (void)rtcEngine:(AgoraRtcEngineKit *)engine didOfflineOfUid:(NSUInteger)uid reason:(AgoraRtcUserOfflineReason)reason {
    // User left the conference
    NSString *participantID  = [NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:uid]];
    if([_participantIDsArray containsObject:participantID]) {
        // Unbind remote video of user who left the conference
        BOOL isFocusedUser = NO;
        if([_focusedUserID isEqualToString:participantID]) {
            if(DEBUGGING) NSLog(@"Focused User Left chat");
            isFocusedUser = YES;
            [self removeAnimation];
        }
        
        [_participantIDsArray removeObject:participantID];
        [_liveQueueArray removeObject:participantID];
        [_liveFeedPanelWithNameDictionary removeObjectForKey:participantID];
        // Shuffle video feed panels when user leaves the chat
        [self didUserLeftChatWithUserType:isFocusedUser];
    }
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
    NSString *questionRequestingUserID = [NSString stringWithFormat:@"%@",userID];
    if(DEBUGGING) NSLog(@"Received Data %@", questionRequestingUserID);
    if(![_liveQueueArray containsObject:questionRequestingUserID]) {
        [_liveQueueArray addObject:questionRequestingUserID];
        
        if([_liveQueueArray count] == 1) {
            [self animateRing];
            if(![_focusedUserID isEqualToString:questionRequestingUserID]) {
                // Shuffle the video feed panels and start the animation for 2 minutes
                [self shuffleFocusedUser:_focusedUserID withAnotherUser:questionRequestingUserID];
            }
        }
        else {
            [self unhideQuestionTurnButtonWithUserID:questionRequestingUserID];
        }
    }
    [self broadCastLiveQueue];
}

#pragma mark - Button Action

- (IBAction)reconnectButtonTapped:(id)sender {
}

- (IBAction)endCallButtonTapped:(id)sender {
    [self removeAnimation];
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

- (void)unhideQuestionTurnButtonWithUserID:(NSString*)userID {
    // if the user is not fucused and asked for question turn then show the queue position and question image
    if(![_focusedUserID isEqualToString:userID]) {
        KCVideoPanelFeed *videoFeedPanel = [_liveFeedPanelWithNameDictionary objectForKey:userID];
        NSInteger queuePosition          = [_liveQueueArray indexOfObject:userID];
        videoFeedPanel.queuePositionLabel.text = [NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:queuePosition]];
        videoFeedPanel.queuePositionLabel.hidden = NO;
        videoFeedPanel.questionLabel.hidden      = NO;
    }
}

- (void)broadCastLiveQueue {
    // Send users the live queue
    NSData *data = [NSJSONSerialization dataWithJSONObject:_liveQueueArray options:NSJSONWritingPrettyPrinted error:NULL];
    [self.agoraKit sendStreamMessage:DataStreamIndentifier data:data];
}

- (void)didUserLeftChatWithUserType:(BOOL)wasFocusedUser {
    START_METHOD
    if(wasFocusedUser) {
        // If focused user left chat then make the first waiting user as focused
        if([_liveQueueArray count] > 0) {
            NSString *newFocuseUser = [_liveQueueArray firstObject];
            _focusedUserID         = newFocuseUser;
            [self setUserFeedToFocusedPanelWithPartcipantID:newFocuseUser];
            [NSThread cancelPreviousPerformRequestsWithTarget:self];
            [self removeAnimation];
            [self animateRing];
        }
        else if([_participantIDsArray count] > 0) {
           NSString *newFocuseUser = [_participantIDsArray firstObject];
            _focusedUserID         = newFocuseUser;
            [self setUserFeedToFocusedPanelWithPartcipantID:newFocuseUser];
        }
    }
    // Reshuffle all panels
    [self reshuffleAllPanels];
    if([_liveQueueArray count] > 0) {
       [self broadCastLiveQueue];
    }
    
    END_METHOD
}

- (void)setUserFeedToFocusedPanelWithPartcipantID:(NSString*)participantID {
    START_METHOD
    // Set this user as focused user
    KCVideoPanelFeed *videoPanel  =  [_liveFeedPanelWithNameDictionary objectForKey:participantID];
    videoPanel.hidden             = NO;
    [self.focusedUserPreviewPanel.videoRender removeFromSuperview];
    [videoPanel.videoRender removeFromSuperview];
    videoPanel.videoRender = nil;
    self.focusedUserPreviewPanel.videoRender = nil;
    self.focusedUserPreviewPanel.videoCanvas.view = nil;
    self.focusedUserPreviewPanel.videoCanvas = nil;
    videoPanel.videoCanvas.view              = nil;
    self.focusedUserPreviewPanel.videoRender = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 664)];
    [self.focusedUserPreviewPanel.videoFeedPanel addSubview:self.focusedUserPreviewPanel.videoRender];
    self.focusedUserPreviewPanel.videoCanvas = videoPanel.videoCanvas;
    self.focusedUserPreviewPanel.videoCanvas.view = self.focusedUserPreviewPanel.videoRender;
    videoPanel.videoCanvas                   = nil;
    [self.agoraKit setupRemoteVideo:self.focusedUserPreviewPanel.videoCanvas];
    self.usernameLabel.text     = [self getParticipantNameFromParticipantLoginID:participantID];
    [_liveFeedPanelWithNameDictionary removeObjectForKey:participantID];
    [_liveFeedPanelWithNameDictionary setObject:self.focusedUserPreviewPanel forKey:participantID];
    END_METHOD
}

- (void)reshuffleAllPanels {
    // Reshuffle all panels
    START_METHOD
    NSInteger count = [self.videoFeedPanelsArray count];
    NSMutableArray *otherParticipnatArray = [[NSMutableArray alloc] initWithArray:_participantIDsArray];
    [otherParticipnatArray removeObject:_focusedUserID];
    for (int i=0; i<count; i++) {
        KCVideoPanelFeed *videofeedPanel = [self.videoFeedPanelsArray objectAtIndex:i];
        if([otherParticipnatArray count] > i) {
            NSString *participantID          = [otherParticipnatArray objectAtIndex:i];
            KCVideoPanelFeed *unbindFeedPanel = [_liveFeedPanelWithNameDictionary objectForKey:participantID];
            
            // Remove Renderer
            [unbindFeedPanel.videoRender removeFromSuperview];
            unbindFeedPanel.videoRender = nil;
            [videofeedPanel.videoRender removeFromSuperview];
            videofeedPanel.videoRender = nil;
            
            [_liveFeedPanelWithNameDictionary removeObjectForKey:participantID];
            
            // Put back after shuffle
            videofeedPanel.videoCanvas      = unbindFeedPanel.videoCanvas;
            videofeedPanel.videoRender      = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 146, 180)];
            [videofeedPanel.videoFeedPanel addSubview:videofeedPanel.videoRender];
            videofeedPanel.videoCanvas.view = videofeedPanel.videoRender;
            [self.agoraKit setupRemoteVideo:videofeedPanel.videoCanvas];
            
            unbindFeedPanel.videoCanvas = nil;
            [_liveFeedPanelWithNameDictionary removeObjectForKey:participantID];
            [_liveFeedPanelWithNameDictionary setObject:videofeedPanel forKey:participantID];
            videofeedPanel.hidden            = NO;
            videofeedPanel.shortnameLabel.text = [self getParticipantNameFirstCharFromParticipantLoginID:participantID];
            if([_liveQueueArray containsObject:participantID]) {
                NSInteger index = [_liveQueueArray indexOfObject:participantID];
                videofeedPanel.queuePositionLabel.text = [NSString stringWithFormat:@"%@", [NSNumber numberWithInteger:index]];
                videofeedPanel.queuePositionLabel.hidden = NO;
                videofeedPanel.questionLabel.hidden      = NO;
            }
            else {
                videofeedPanel.queuePositionLabel.hidden = YES;
                videofeedPanel.questionLabel.hidden      = YES;
            }
        }
        else {
            // If there is no enough user to show hide the panels
            //            videofeedPanel.hidden                    = YES;
            videofeedPanel.queuePositionLabel.hidden = YES;
            videofeedPanel.questionLabel.hidden      = YES;
            videofeedPanel.shortnameLabel.hidden     = YES;
        }
    }
    END_METHOD
}

- (void)shuffleFocusedUser:(NSString*)focusedUserID withAnotherUser:(NSString*)otherUserID {
    // Shuffle the video feed panels of focused user and other user
    if([_participantIDsArray count] > 0) {
        KCVideoPanelFeed *secondUserPanel = [_liveFeedPanelWithNameDictionary objectForKey:otherUserID];
        
        // Remove both renderers
        [self.focusedUserPreviewPanel.videoRender removeFromSuperview];
        self.focusedUserPreviewPanel.videoRender = nil;
        [secondUserPanel.videoRender removeFromSuperview];
        secondUserPanel.videoRender = nil;
        
        
        // Exchange video canvas
        AgoraRtcVideoCanvas *videoCanvasFocusedUser = self.focusedUserPreviewPanel.videoCanvas;
        AgoraRtcVideoCanvas *videoCanvasOtherUser   = secondUserPanel.videoCanvas;
        self.focusedUserPreviewPanel.videoCanvas    = videoCanvasOtherUser;
        secondUserPanel.videoCanvas                 = videoCanvasFocusedUser;
        
        // Create new renders and add back
        
        //1. Change focused user
        self.focusedUserPreviewPanel.videoRender = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 664)];
        [self.focusedUserPreviewPanel.videoFeedPanel addSubview:self.focusedUserPreviewPanel.videoRender];
        self.focusedUserPreviewPanel.videoCanvas.view = self.focusedUserPreviewPanel.videoRender;
        [self.agoraKit setupRemoteVideo:self.focusedUserPreviewPanel.videoCanvas];
        
        // 2. Change earlier focused user
        secondUserPanel.videoRender = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 146, 180)];
        [secondUserPanel.videoFeedPanel addSubview:secondUserPanel.videoRender];
        [secondUserPanel bringSubviewToFront:secondUserPanel.videoFeedPanel];
        [secondUserPanel.videoFeedPanel bringSubviewToFront:secondUserPanel.videoRender];
        secondUserPanel.videoCanvas.view = secondUserPanel.videoRender;
        [self.agoraKit setupRemoteVideo:secondUserPanel.videoCanvas];
        
        
        // Set new object-key pair
        if([NSString validateString:focusedUserID]) {
            [_liveFeedPanelWithNameDictionary setObject:secondUserPanel forKey:focusedUserID];
        }
        if([NSString validateString:otherUserID]) {
            [_liveFeedPanelWithNameDictionary setObject:self.focusedUserPreviewPanel forKey:otherUserID];
        }
        // Set usrenames
        self.usernameLabel.text             = [self getParticipantNameFromParticipantLoginID:otherUserID];
        secondUserPanel.shortnameLabel.text = [self getParticipantNameFirstCharFromParticipantLoginID:focusedUserID];
        if([_liveQueueArray containsObject:focusedUserID]) {
            NSInteger index = [_liveQueueArray indexOfObject:focusedUserID];
            secondUserPanel.queuePositionLabel.text = [NSString stringWithFormat:@"%@", [NSNumber numberWithInteger:index]];
            secondUserPanel.queuePositionLabel.hidden = NO;
            secondUserPanel.questionLabel.hidden      = NO;
        }
        else {
            secondUserPanel.queuePositionLabel.hidden = YES;
            secondUserPanel.questionLabel.hidden      = YES;
        }
        // Set new focused user id
        _focusedUserID          = otherUserID;
    }
}


- (NSString*)getParticipantNameFromParticipantLoginID:(NSString*)loginID {
    // Spilit the login ID to get the name of user
    NSString *username = [_usernameDictionary objectForKey:loginID];
    return [username capitalizedString];
}

- (NSString*)getParticipantNameFirstCharFromParticipantLoginID:(NSString*)loginID {
    // Spilit the login ID to get the first char of the  user's name
    NSString *username = [_usernameDictionary objectForKey:loginID];
    char firstLetter   = [username characterAtIndex:0];
    NSString *firstLetterString = [NSString stringWithFormat:@"%c",firstLetter];
    return [firstLetterString uppercaseString];
}

#pragma mark - Request Completion

- (void)didFetchUserNamesWithResponse:(NSDictionary *)response {
    // Usernames fetched from server
    _usernameDictionary         = [[NSMutableDictionary alloc] init];
    NSArray *participantArray   = [response objectForKey:kParticipant];
    
    if([participantArray isKindOfClass:[NSArray class]]) {
        for (NSDictionary *userDictionary in participantArray) {
            NSString *userID   = [userDictionary objectForKey:kUserID];
            NSString *username = [userDictionary objectForKey:kName];
            [_usernameDictionary setObject:username forKey:userID];
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
        __weak id weakSelf = self;
        NSDictionary *params = @{kLanguageID:_userProfile.languageID, kGroupSessionID:self.groupSessionID};
        [_groupSessionWebManager getParticipantNamesWithParameter:params withCompletionHandler:^(NSDictionary *response) {
            [KCProgressIndicator hideActivityIndicator];
            [weakSelf didFetchUserNamesWithResponse:response];
            // Fetched participant names
        } andFailure:^(NSString *title, NSString *message) {
            [KCProgressIndicator hideActivityIndicator];
            // Show failure alert
            [KCUIAlert showInformationAlertWithHeader:title message:message withButtonTapHandler:^{
                
            }];
        }];
    }
}

- (void)completeGroupSession {
    // Completes the MasterClass or ChewIt Session on server
    if(isNetworkReachable) {
        [KCProgressIndicator showNonBlockingIndicator];
        // Network requsest
        NSDictionary *params = @{kLanguageID:_userProfile.languageID, kSessionID:self.groupSessionID};
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
