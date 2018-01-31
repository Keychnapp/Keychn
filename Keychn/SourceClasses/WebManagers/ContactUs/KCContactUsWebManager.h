//
//  KCContactUsWebManager.h
//  Keychn
//
//  Created by Keychn Experience SL on 16/03/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KCWebConnection.h"

@interface KCContactUsWebManager : KCWebConnection

/**
 @abstract This method will submit a user query to web server.
 @param User Profile, Query details and Completion Handlers
 @return void
 */
- (void)submitQueryWithParameter:(NSDictionary*)parameters withCompletionHandler:(void(^)(NSDictionary *responseDictionary))success andFailure:(void(^)(NSString *title, NSString *message))failed;

@end
