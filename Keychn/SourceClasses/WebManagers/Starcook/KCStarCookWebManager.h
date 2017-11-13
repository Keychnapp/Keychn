//
//  KCStarCookWebManager.h
//  Keychn
//
//  Created by Keychn Experience SL on 08/04/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import "KCWebConnection.h"

@interface KCStarCookWebManager : KCWebConnection

/**
 @abstract This method search starcook based on the search string input by user
 @param User ID and Authetication token, Search String and  Completion Handlers
 @return void
 */
- (void)searchStarCookWithParameter:(NSDictionary*)parameters withCompletionHandler:(void(^)(NSDictionary *responseDictionary))success andFailure:(void(^)(NSString *title, NSString *message))failed;


/**
 @abstract This method will send friend request to the receiver id
 @param User ID and Authetication token, Receiver User ID and  Completion Handlers
 @return void
 */
- (void)sendFriendRequestWithParameter:(NSDictionary*)parameters withCompletionHandler:(void(^)(NSDictionary *responseDictionary))success andFailure:(void(^)(NSString *title, NSString *message))failed;

/**
 @abstract This method will fetch the list of user friend
 @param User ID, Authetication token, Language ID and Completion Handlers
 @return void
 */
- (void)getFriendListWithParameter:(NSDictionary*)parameters withCompletionHandler:(void(^)(NSDictionary *responseDictionary))success andFailure:(void(^)(NSString *title, NSString *message))failed;

/**
 @abstract This method will fetch pending requests from server
 @param User ID, Language ID and Authetication token
 @return Array with Starcook models
 */
- (void)getPendingFriendRequestWithParameter:(NSDictionary*)parameters withCompletionHandler:(void(^)(NSDictionary *responseDictionary))success andFailure:(void(^)(NSString *title, NSString *message))failed;


/**
 @abstract This method will update pending friend list of user. User can Accept or Deny the Frined Request
 @param User ID, Language ID and Authetication token, Receiver ID, is_accept (YES|NO)
 @return void
 */
- (void)acceptDenyFriendRequestWithParameter:(NSDictionary*)parameters withCompletionHandler:(void(^)(NSDictionary *responseDictionary))success andFailure:(void(^)(NSString *title, NSString *message))failed;

/**
 @abstract This method will update friend list on server. A friend will be blocked or removed
 @param User ID, Language ID and Authetication token, Receiver ID, is_removed (YES|NO)
 @return void
 */
- (void)blockRemoveFriendWithParameter:(NSDictionary*)parameters withCompletionHandler:(void(^)(NSDictionary *responseDictionary))success andFailure:(void(^)(NSString *title, NSString *message))failed;

/**
 @abstract Parse Starcook model with server response
 @param Server Response Array
 @return Array with Starcook models
 */
- (NSArray*)getStarCookModelsWithResponse:(NSArray*)responseArray;


@end
