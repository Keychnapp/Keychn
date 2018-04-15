//
//  KCAgoraCallManager.h
//  KeychnApp
//
//  Created by Rohit on 30/01/17.
//  Copyright © 2017 Crome Infotech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KCAgoraCallManager : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, assign) BOOL isGroupSession;
@property (nonatomic, assign) NSInteger hostID;
@property (nonatomic, assign) NSInteger secondCameraId;

- (void)autheticateClientWithToken:(NSString *)token withRole:(UserRole)role hasAutheticated:(void(^)(BOOL status))autheticated;

- (void)joinConferenceWithID:(NSString *)conferenceID withCompletionHandler:(void (^)(BOOL status))joined;

- (void)joinConferenceWithID:(NSString *)conferenceID userID:(NSNumber *)userID withRemoteVideoView:(UIView *)view andSecondCameraView:(UIView *)secondCameraView withCompletionHandler:(void (^)(BOOL status))joined;

- (void)showUserPreviewOnView:(UIView *)view withUserIdentifier:(NSNumber *)userID;

- (void)closeUserPreView;

- (void)attachPreviewOnView:(UIView *)view;

- (BOOL)closeConference;

- (void)releaseInstance;

- (void)enabledAudio:(BOOL)shouldPlay;

- (void)enableSpeaker:(BOOL)shouldPlay;

- (void)flipCamera;

- (void)sendQuestionTurnRequestWithDetail:(id)userDetails;

- (void)monitorParticipantStaus:(void(^)(BOOL isConnected, NSString *participantID))joinEvent;

- (void)startListeningForUserData:(void(^)(NSInteger userID, NSArray *liveQueueArray))dataEvent;

- (void)closeTemporaryWithCompletionHandler:(void (^)(BOOL status))closed;

@end
