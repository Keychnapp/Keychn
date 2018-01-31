//
//  KCMasterclassPreview.m
//  Keychn
//
//  Created by Rohit Kumar on 30/01/2018.
//  Copyright © 2018 Keychn Experience. All rights reserved.
//

#import "KCMasterclassPreview.h"
#import <AgoraRtcEngineKit/AgoraRtcEngineKit.h>

@interface KCMasterclassPreview () <AgoraRtcEngineDelegate>

@property (strong, nonatomic) AgoraRtcEngineKit *agoraKit;

@end

@implementation KCMasterclassPreview

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    // Intialize Xib
    UIView *previewView = [[NSBundle mainBundle] loadNibNamed:@"MasterclassPreview" owner:self options:nil].firstObject;
    previewView.frame   = self.bounds;
    [self addSubview:previewView];
    
    // Add a dark shadow
    
    [self.layer setShadowOffset:CGSizeMake(0, 0)];
    [self.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [self.layer setShadowOpacity:0.5];
    
    // Add a PanGesture to make Remote Video Movable
    UIPanGestureRecognizer *panGestureRecognizerForRemoteCameraView = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveUserPreviewViewWithGesture:)];
    [self addGestureRecognizer:panGestureRecognizerForRemoteCameraView];

    return self;
}

-(void)moveUserPreviewViewWithGesture:(UIPanGestureRecognizer*)panGestureRecognizer {
    if (panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGRect frame = panGestureRecognizer.view.frame;
        CGPoint translation = [panGestureRecognizer translationInView:panGestureRecognizer.view];
        frame.origin = CGPointMake(frame.origin.x + translation.x,
                                   frame.origin.y + translation.y);
        
        
        
        if(frame.origin.x > 0 && (frame.origin.x+frame.size.width) < self.superview.frame.size.width && frame.origin.y > 0 && (frame.origin.y+frame.size.height) < self.superview.frame.size.height) {
            [UIView animateWithDuration:0.2 animations:^{
                panGestureRecognizer.view.frame = frame;
            }];
        }
        [panGestureRecognizer setTranslation:CGPointZero inView:panGestureRecognizer.view];
    }
}

- (void)closePreview {
    [self closeConference];
    [UIView animateWithDuration:0.5 animations:^{
        self.transform = CGAffineTransformMakeScale(0.1, 0.1);
        self.alpha     = 0.0f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)presentWithAnimation {
    self.transform = CGAffineTransformMakeScale(0.1, 0.1);
    self.alpha     = 0.0f;
    [self setHidden:NO];
    [UIView animateWithDuration:0.5 animations:^{
        self.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.alpha     = 1.0f;
    } completion:^(BOOL finished) {
        
    }];
}

- (IBAction)dismissPreview:(id)sender {
    [self closePreview];
}

#pragma mark -  Masterclass Preview

- (void)joinConferenceWithId:(NSString *)conferenceId forUser:(NSNumber *)userId {
    // Join Masterclass for preview
    self.agoraKit   = [AgoraRtcEngineKit sharedEngineWithAppId:kAgoraKeychnAppIdentifier delegate:self];
    [self.agoraKit createDataStream:&(DataStreamIndentifier) reliable:YES ordered:YES];
    [self.agoraKit setClientRole:AgoraRtc_ClientRole_Audience withKey:[NSString stringWithFormat:@"%lu",(unsigned long)Listner]];
    [self.agoraKit setChannelProfile:AgoraRtc_ChannelProfile_LiveBroadcasting];
    [self.agoraKit muteLocalAudioStream: YES];
    [self.agoraKit setEnableSpeakerphone:NO];
    [self.agoraKit joinChannelByKey:nil channelName:conferenceId info:nil uid:[userId integerValue] joinSuccess:^(NSString *channel, NSUInteger uid, NSInteger elapsed) {
        [UIApplication sharedApplication].idleTimerDisabled = YES;
    }];
}

- (BOOL)closeConference {
    NSInteger status =   [self.agoraKit leaveChannel:^(AgoraRtcStats *stat) {
        [UIApplication sharedApplication].idleTimerDisabled = NO;
    }];
    self.agoraKit = nil;
    return (status == 0);
}

#pragma mark - Connection Delegate

- (void)rtcEngine:(AgoraRtcEngineKit *)engine firstRemoteVideoDecodedOfUid:(NSUInteger)uid size: (CGSize)size elapsed:(NSInteger)elapsed {
    if(uid == self.hostId) {
        // Setup remote videos for Host Video and Second Camera Video
        AgoraRtcVideoCanvas *videoCanvas = [[AgoraRtcVideoCanvas alloc] init];
        videoCanvas.uid  = uid;
        videoCanvas.view = self.containerView;
        videoCanvas.renderMode = AgoraRtc_Render_Hidden;
        [self.agoraKit setupRemoteVideo:videoCanvas];
        [self presentWithAnimation];
    }
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine didOfflineOfUid:(NSUInteger)uid reason:(AgoraRtcUserOfflineReason)reason {
    // User left the conference
    if(uid ==  self.hostId) {
        [self closePreview];
    }
}

@end
