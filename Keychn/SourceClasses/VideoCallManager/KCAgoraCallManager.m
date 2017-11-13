//
//  KCAgoraCallManager.m
//  KeychnApp
//
//  Created by Rohit on 30/01/17.
//  Copyright © 2017 Crome Infotech. All rights reserved.
//

#import "KCAgoraCallManager.h"
#import "AFNetworking.h"
#import <AgoraRtcEngineKit/AgoraRtcEngineKit.h>

//#define DEBUGGING 1

@interface KCAgoraCallManager () <AgoraRtcEngineDelegate>

#pragma mark - SDK Vaildation

@property (nonatomic, strong) NSString *accessToken;

#pragma mark Video SDK components
@property (strong, nonatomic) AgoraRtcEngineKit *agoraKit;
@property (strong, nonatomic) AgoraRtcVideoCanvas *localVideoCanvas;

@property (nonatomic, strong) UIView *remoteView;
@property (nonatomic, strong) UIView *previewView;
@property (nonatomic, strong) void (^joinEvent) (BOOL isConnected, NSString *participantID);
@property (nonatomic, strong) void (^dataEvent) (NSInteger userID, NSArray *liveQueueArray);
@property (nonatomic, strong) void (^conneted) (BOOL isConnected);

@end

@implementation KCAgoraCallManager

#pragma mark - Singleton Instance

+ (instancetype)sharedInstance {
   static KCAgoraCallManager *twillioManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        twillioManager          = [KCAgoraCallManager new];
    });
    return twillioManager;
}

- (void)autheticateClientWithToken:(NSString *)token hasAutheticated:(void(^)(BOOL status))autheticated {
    // Autheticate Twillio client using the access token generated
    if(DEBUGGING) NSLog(@"Autheticating client SDK Version %@", [AgoraRtcEngineKit getSdkVersion]);
    self.agoraKit           = [AgoraRtcEngineKit sharedEngineWithAppId:kAgoraKeychnAppIdentifier delegate:self];
    [self.agoraKit createDataStream:&(DataStreamIndentifier) reliable:YES ordered:YES];
    [self.agoraKit setChannelProfile:AgoraRtc_ChannelProfile_Communication];
    if(self.agoraKit) {
        autheticated(YES);
        if(DEBUGGING) NSLog(@"Autheticated client");
    }
    else {
        autheticated(NO);
    }
}

#pragma mark - User Preview

- (void)showUserPreviewOnView:(UIView *)view withUserIdentifier:(NSNumber *)userID {
    if(DEBUGGING) NSLog(@"Starting preview on view");
    self.previewView  = view;
    [self.agoraKit enableVideo];
    [self.agoraKit setVideoProfile:AgoraRtc_VideoProfile_720P swapWidthAndHeight: false];
    // Default mode is disableVideo
    self.localVideoCanvas = [[AgoraRtcVideoCanvas alloc] init];
    self.localVideoCanvas.uid = [userID integerValue];
    if(DEBUGGING) NSLog(@"Start preview by uid %@",userID);
    // UID = 0 means we let Agora pick a UID for us
    
    self.localVideoCanvas.view        = self.previewView;
    self.localVideoCanvas.renderMode  = AgoraRtc_Render_Hidden;
    [self.agoraKit setupLocalVideo:self.localVideoCanvas];
    [self.agoraKit startPreview];
}

- (void)closeUserPreView {
    
}

- (void)attachPreviewOnView:(UIView *)view {
    // Attach view to video track for local preview
    [self.previewView removeFromSuperview];
    self.previewView = nil;
    self.previewView = view;
    self.localVideoCanvas.view = self.previewView;
    [self.agoraKit setupLocalVideo:self.localVideoCanvas];
}

- (void)flipCamera {
    [self.agoraKit switchCamera];
}

- (void)enabledAudio:(BOOL)shouldPlay {
    // Enable disable audio
    [self.agoraKit muteLocalAudioStream:!shouldPlay];
}

- (void)enableSpeaker:(BOOL)shouldPlay {
    // Enable disable audio playback
    [self.agoraKit setEnableSpeakerphone:shouldPlay];
}

#pragma mark - Video Session

- (void)joinConferenceWithID:(NSString *)conferenceID withCompletionHandler:(void (^)(BOOL status))joined {
    if(DEBUGGING) NSLog(@"join conference with conference ID");
    // Join a conference with conference ID
}

- (void)joinConferenceWithID:(NSString *)conferenceID  userID:(NSNumber *)userID withRemoteVideoView:(UIView *)view withCompletionHandler:(void (^)(BOOL status))joined {
    if(DEBUGGING) NSLog(@"join conference with conference ID");
    // Join a conference with conference ID
    self.remoteView = view;
    if(DEBUGGING) NSLog(@"Join channel by uid %@",userID);
    [self.agoraKit joinChannelByKey:nil channelName:conferenceID info:nil uid:[userID integerValue] joinSuccess:^(NSString *channel, NSUInteger uid, NSInteger elapsed) {
        [self.agoraKit setEnableSpeakerphone:YES];
        [UIApplication sharedApplication].idleTimerDisabled = YES;
        joined(YES);
    }];
}

- (BOOL)closeConference {
  NSInteger status =   [self.agoraKit leaveChannel:^(AgoraRtcStats *stat) {
        [UIApplication sharedApplication].idleTimerDisabled = NO;
    }];
    self.agoraKit = nil;
    return (status == 0);
}

- (void)releaseInstance {
    self.agoraKit = nil;
}

- (void)monitorParticipantStaus:(void(^)(BOOL isConnected, NSString *participantID))joinEvent {
    if(DEBUGGING) NSLog(@"Start user status monitoring");
    // Participant connected or disconnected
    self.joinEvent  = joinEvent;
}

- (void)startListeningForUserData:(void(^)(NSInteger userID, NSArray *liveQueue))dataEvent {
    self.dataEvent = dataEvent;
}

- (void)stopMonitoring {
    self.joinEvent = nil;
}

- (void)sendQuestionTurnRequestWithDetail:(id)userDetails {
    NSDictionary *userDataDictionary = @{kUserDetails:userDetails};
    NSData *data = [NSJSONSerialization dataWithJSONObject:userDataDictionary options:NSJSONWritingPrettyPrinted error:NULL];
    [self.agoraKit sendStreamMessage:DataStreamIndentifier data:data];
}

#pragma mark - Connection Delegate

- (void)rtcEngine:(AgoraRtcEngineKit *)engine firstRemoteVideoDecodedOfUid:(NSUInteger)uid size: (CGSize)size elapsed:(NSInteger)elapsed {
    NSString *participantID = [NSString stringWithFormat:@"%@", [NSNumber numberWithInteger:uid]];
    if(self.isGroupSession) {
        if(DEBUGGING) NSLog(@"rtcEngine --> Joined UID: %@ and Host ID %@", [NSNumber numberWithInteger:uid], [NSNumber numberWithInteger:self.hostID]);
        if(uid == self.hostID) {
            AgoraRtcVideoCanvas *videoCanvas = [[AgoraRtcVideoCanvas alloc] init];
            videoCanvas.uid = uid;

            videoCanvas.view = self.remoteView;
            videoCanvas.renderMode = AgoraRtc_Render_Hidden;
            [self.agoraKit setupRemoteVideo:videoCanvas];
            // Bind remote video stream to view
            self.joinEvent(YES, participantID);
        }
    }
    else {
        AgoraRtcVideoCanvas *videoCanvas = [[AgoraRtcVideoCanvas alloc] init];
        videoCanvas.uid = uid;
        
        videoCanvas.view = self.remoteView;
        videoCanvas.renderMode = AgoraRtc_Render_Hidden;
        [self.agoraKit setupRemoteVideo:videoCanvas];
        // Bind remote video stream to view
        self.joinEvent(YES, participantID);
    }
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine didOfflineOfUid:(NSUInteger)uid reason:(AgoraRtcUserOfflineReason)reason {
    // User left the conference
    NSString *participantID = [NSString stringWithFormat:@"%@", [NSNumber numberWithInteger:uid]];
    if(self.isGroupSession) {
        if(uid ==  self.hostID) {
            self.joinEvent(NO, participantID);
        }
    }
    else {
       self.joinEvent(NO, participantID);
    }
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine receiveStreamMessageFromUid:(NSUInteger)uid streamId:(NSInteger)streamId data:(NSData*)data {
    if(self.dataEvent) {
        NSArray *liveQueueArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:NULL];
        self.dataEvent(uid, liveQueueArray);
    }
}

@end
