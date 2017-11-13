//
//  KCTextMessageWebManager.h
//  Keychn
//
//  Created by Keychn Experience SL on 18/04/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KCWebConnection.h"

@interface KCTextMessageWebManager : KCWebConnection

/**
 @abstract This method will send a text message to another.
 @param User ID and Authetication token, Friend ID, Text Message and Completion Handlers
 @return void
 */
- (void)sendTextMessageWithParameter:(NSDictionary*)parameters withCompletionHandler:(void(^)(NSDictionary *responseDictionary))success andFailure:(void(^)(NSString *title, NSString *message))failed;

/**
 @abstract This method will fetch chat history from server between the logged in user and the friend
 @param User ID and Authetication token, Friend ID, Last message ID and Completion Handlers
 @return
 */
- (void)fetchChatHistoryWithParameters:(NSDictionary*)parameters withCompletionHandler:(void(^)(NSDictionary *responseDictionary))success andFailure:(void(^)(NSString *title, NSString *message))failed;

/**
 @abstract This method will mark read messages as read=1 flag on server for application badge management
 @param User ID, Friend ID, Message ID, Language ID and Access Token
 @return void
 */
- (void)markMessagesAsReadWithParameters:(NSDictionary *)parameters withCompletionHandler:(void (^)(NSDictionary *response))success andFailure:(void (^)(NSString *title, NSString *message))failed;

@end
