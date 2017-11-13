//
//  KCTextMessageWebManager.m
//  Keychn
//
//  Created by Keychn Experience SL on 18/04/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import "KCTextMessageWebManager.h"
#import "KCTextChatDBManager.h"

@implementation KCTextMessageWebManager

- (void)sendTextMessageWithParameter:(NSDictionary *)parameters withCompletionHandler:(void (^)(NSDictionary *))success andFailure:(void (^)(NSString *, NSString *))failed {
    // Send a message to the selected friend
    [self sendDataToServerWithAction:sendTextMessageAction withParameters:parameters success:^(NSDictionary *response) {
        // Network request completed
        BOOL status = [self isFinishedWithError:response];
        if(status) {
            //Requested completed with error
            if([response isKindOfClass:[NSDictionary class]]) {
                NSDictionary *errorDictionary = [response objectForKey:kErrorDetails];
                NSString *title   = [errorDictionary objectForKey:kTitle];
                NSString *message = [errorDictionary objectForKey:kMessage];
                if(DEBUGGING) NSLog(@"Failed with response %@",errorDictionary);
                failed(title,message);
            }
        }
        else {
            // Text message sent successfully
            if(DEBUGGING) NSLog(@"Text message sent successfully %@",response);
            success(response);
        }
        
    } failure:^(NSString *response) {
        // Network request failed
        failed(AppLabel.errorTitle, AppLabel.unexpectedErrorMessage);
    }];
}

- (void)fetchChatHistoryWithParameters:(NSDictionary *)parameters withCompletionHandler:(void (^)(NSDictionary *response))success andFailure:(void (^)(NSString *, NSString *))failed {
    // Fetch chat history from server between logged in user and friend
    START_METHOD
    __weak id weakSelf = self;
    [self sendDataToServerWithAction:getTextMessageHistoryAction withParameters:parameters success:^(NSDictionary *response) {
        // Network request completed
        BOOL status = [self isFinishedWithError:response];
        if(status) {
            //Requested completed with error
            if([response isKindOfClass:[NSDictionary class]]) {
                NSDictionary *errorDictionary = [response objectForKey:kErrorDetails];
                NSString *title   = [errorDictionary objectForKey:kTitle];
                NSString *message = [errorDictionary objectForKey:kMessage];
                if(DEBUGGING) NSLog(@"Failed with response %@",errorDictionary);
                failed(title,message);
            }
        }
        else {
            // Fetched chat history from server
            if(DEBUGGING) NSLog(@"Chat history fetched %@",response);
            // Save chat history to local database
            [weakSelf saveChatHistoryWithResponse:response];
            success(response);
        }
        
    } failure:^(NSString *response) {
        // Network request failed
        failed(AppLabel.errorTitle, AppLabel.unexpectedErrorMessage);
    }];
    END_METHOD
}

- (void)markMessagesAsReadWithParameters:(NSDictionary *)parameters withCompletionHandler:(void (^)(NSDictionary *response))success andFailure:(void (^)(NSString *title, NSString *message))failed {
    // Mark messages as read on server for Application Badge Management
    START_METHOD
    [self sendDataToServerWithAction:markMessagesAsReadAction withParameters:parameters success:^(NSDictionary *response) {
        // Network request completed
        BOOL status = [self isFinishedWithError:response];
        if(status) {
            //Requested completed with error
            if([response isKindOfClass:[NSDictionary class]]) {
                NSDictionary *errorDictionary = [response objectForKey:kErrorDetails];
                NSString *title   = [errorDictionary objectForKey:kTitle];
                NSString *message = [errorDictionary objectForKey:kMessage];
                if(DEBUGGING) NSLog(@"Failed with response %@",errorDictionary);
                failed(title,message);
            }
        }
        else {
            // Fetched chat history from server
            if(DEBUGGING) NSLog(@"Messages marked as read %@",response);
            success(response);
        }
        
    } failure:^(NSString *response) {
        // Network request failed
        failed(AppLabel.errorTitle, AppLabel.unexpectedErrorMessage);
    }];
    END_METHOD
}

- (void)saveChatHistoryWithResponse:(NSDictionary*)response {
    // Save user chat history in local database
    START_METHOD
    NSArray *chatMessagesArray = [response objectForKey:kChatDetails];
    if([chatMessagesArray isKindOfClass:[NSArray class]] && [chatMessagesArray count] > 0) {
        KCTextChatDBManager *textChatDBManager = [KCTextChatDBManager new];
        @autoreleasepool {
            for (NSDictionary *textMessageDictionary in chatMessagesArray) {
                NSNumber *senderID   = [textMessageDictionary objectForKey:kUserID];
                NSNumber *receiverID = [textMessageDictionary objectForKey:kFriendID];
                NSString *imageURL   = [textMessageDictionary objectForKey:kImageURL];
                NSString *message    = [textMessageDictionary objectForKey:kTextMessage];
                NSNumber *messageID  = [textMessageDictionary objectForKey:kIdentifier];
                NSTimeInterval timestamp  = [[textMessageDictionary objectForKey:kMessageDate] doubleValue];
                
                // Insert new messages to local database
                [textChatDBManager saveMessageWithMessage:message rowIdentifier:messageID senderID:senderID receiverID:receiverID imageURL:imageURL andTimestamp:timestamp];
            }
        }
    }
    END_METHOD
}

@end
