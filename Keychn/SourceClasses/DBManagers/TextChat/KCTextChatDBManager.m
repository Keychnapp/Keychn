//
//  KCTextChatDBManager.m
//  Keychn
//
//  Created by Keychn Experience SL on 18/04/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import "KCTextChatDBManager.h"
#import "KCDatabaseOperation.h"


@implementation KCTextChatDBManager

- (void)saveMessageWithMessage:(NSString *)text rowIdentifier:(NSNumber *)messageID senderID:(NSNumber *)senderID receiverID:(NSNumber *)receiverID imageURL: (NSString *)imageURL andTimestamp:(NSTimeInterval)timeInterval {
    // Save message in local database
    KCDatabaseOperation *dbOperation = [KCDatabaseOperation sharedInstance];
    NSString *date                   = [NSDate getFullDateFromTimeInterval:timeInterval];
    if([NSString validateString:text]) {
        text                             = [text stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    }
    NSString *insertQuery            = [NSString stringWithFormat:@"INSERT INTO text_message (message_id, text, sender_id, receiver_id, received_on, image_url, timestamp) VALUES ('%@', '%@', '%@','%@', '%@', '%@', '%f')",messageID, text, senderID, receiverID, date, imageURL, timeInterval];
    [dbOperation executeSQLQuery:insertQuery];
}

- (NSMutableDictionary*)loadChatHisoryForUser:(NSNumber *)userID withFriend:(NSNumber *)friendID {
    // Load chat history between two users
    
    // 1. Find distict dates in chat history first
    NSString *clause                 = @"GROUP BY received_on ORDER BY timestamp DESC LIMIT 30";
    KCDatabaseOperation *dbOperation = [KCDatabaseOperation sharedInstance];
    NSArray *messageDatesArray       =  [dbOperation fetchColumnDataFromTable:@"text_message" andColumnName:@"received_on" withClause:clause];
    if([messageDatesArray count] > 0) {
        // 2. Find messages on distinct dates
        NSMutableDictionary *textMessagesDictionary = [[NSMutableDictionary alloc] init];
        @autoreleasepool {
            for (NSString *messageDate in messageDatesArray) {
                NSString *fetchClause = [NSString stringWithFormat:@"WHERE received_on = '%@' AND ((sender_id = '%@' AND receiver_id = '%@') OR (sender_id = '%@' AND receiver_id = '%@')) ORDER BY timestamp",messageDate,userID,friendID,friendID,userID];
                NSArray *messageArray = [dbOperation fetchDataInUTFStringFormatFromTable:@"text_message" withClause:fetchClause];
                // Add distinct date as key (Date string) and messages on that day as object (NSArray  - Message Rows)
                if([messageArray count] > 0) {
                   [textMessagesDictionary setObject:messageArray forKey:messageDate];
                }
            }
        }
        return textMessagesDictionary;
    }
    return nil;
}

- (NSNumber*)getLastMessageIDForUser:(NSNumber*)userID withFriend:(NSNumber*)friendID {
    // Get last message id from local database
    KCDatabaseOperation *dbOperation = [KCDatabaseOperation sharedInstance];
    NSString *clause                 = [NSString stringWithFormat:@"WHERE sender_id = '%@' AND receiver_id = '%@' ORDER BY message_id DESC LIMIT 1",friendID, userID];
    NSArray *messageIDArray          = [dbOperation fetchColumnDataFromTable:@"text_message" andColumnName:@"message_id" withClause:clause];
    if(messageIDArray && [messageIDArray count] > 0) {
        return [messageIDArray firstObject];
    }
    return @0;
}

- (void)deleteChatHistioryForUser:(NSNumber *)userID andFriendID:(NSNumber *)friendID {
    // Delete chat history between users
    KCDatabaseOperation *dbOperation = [KCDatabaseOperation sharedInstance];
    NSString *query = [NSString stringWithFormat:@"DELETE FROM text_message WHERE (sender_id = '%@' AND receiver_id = '%@') OR (sender_id = '%@' AND receiver_id = '%@')",userID,friendID,friendID,userID];
    [dbOperation executeSQLQuery:query];
}

@end
