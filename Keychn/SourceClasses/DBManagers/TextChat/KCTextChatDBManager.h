//
//  KCTextChatDBManager.h
//  Keychn
//
//  Created by Keychn Experience SL on 18/04/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KCTextChatDBManager : NSObject

/**
 @abstract This method will save message message in local database.
 @param Text Message, Row Identifier, Sender ID, Receiver ID, Image URL and Timestamp
 @return void
 */
- (void)saveMessageWithMessage:(NSString*)text rowIdentifier:(NSNumber*)messageID senderID:(NSNumber*)senderID receiverID:(NSNumber*)receiverID imageURL:(NSString *)imageURL andTimestamp:(NSTimeInterval)timeInterval;

/**
 @abstract This method will fetch chat history between two users.
 @param User ID and Friend ID
 @return NSMutable Dictionary of user messages
 */
- (NSMutableDictionary*)loadChatHisoryForUser:(NSNumber*)userID withFriend:(NSNumber*)friendID;

/**
 @abstract This method will get the last recevied message id from the local database.
 @param User ID and Friend ID
 @return
 */
- (NSNumber*)getLastMessageIDForUser:(NSNumber*)userID withFriend:(NSNumber*)friendID;

/**
 @abstract This method will delete a text conversion between the two users
 @param User ID and Friend ID
 @return void
 */
- (void)deleteChatHistioryForUser:(NSNumber*)userID andFriendID:(NSNumber*)friendID;

@end
