//
//  KCGroupSessionWebManager.h
//  Keychn
//
//  Created by Keychn Experience SL on 22/03/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import "KCWebConnection.h"

@interface KCGroupSessionWebManager : KCWebConnection

/**
 @abstract This method will fetch MasterClass details from server
 @param User ID and Authetication token, MasterClass ID  Completion Handlers
 @return void
 */
- (void)getMasterClassDetailsWithParameter:(NSDictionary*)parameters withCompletionHandler:(void(^)(NSDictionary *responseDictionary))success andFailure:(void(^)(NSString *title, NSString *message))failed;


/**
 @abstract This method will fetch buy a spot for MasterClass
 @param User ID and Authetication token, MasterClass ID, Languge ID,  Completion Handlers
 @return void
 */
- (void)buyMasterClassSpotWithParameter:(NSDictionary*)parameters withCompletionHandler:(void(^)(NSString *title, NSString *message))success andFailure:(void(^)(NSString *title, NSString *message))failed;

/**
 @abstract Get parcipant names for this group session from server.
 */
- (void)getParticipantNamesWithParameter:(NSDictionary*)parameters withCompletionHandler:(void(^)(NSDictionary *response))success andFailure:(void(^)(NSString *title, NSString *message))failed;

/**
 @abstract This method will mark any Group Session i.e. MasterClass or Chew/It Session complete on server, This is only called from the host end.
 @param Session ID and Language ID
 @return void
 */
- (void)completeGroupSessionWithParameter:(NSDictionary*)parameters withCompletionHandler:(void(^)(NSString *title, NSString *message))success andFailure:(void(^)(NSString *title, NSString *message))faile;

/**
 @abstract This method will update Group Session status for each individual user
 @param NSDictionary Web Paramaters
 @return void
 */
- (void)updateGroupSessionStatusWithParameter:(NSDictionary*)parameters withCompletionHandler:(void(^)(NSString *title, NSString *message))success andFailure:(void(^)(NSString *title, NSString *message))failed;


@end
