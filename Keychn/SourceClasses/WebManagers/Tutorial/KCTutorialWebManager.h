//
//  KCTutorialWebManager.h
//  Keychn
//
//  Created by Keychn Experience SL on 18/03/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import "KCWebConnection.h"

@interface KCTutorialWebManager : KCWebConnection

/**
 @abstract This method will fetch tutorials from server
 @param User ID and Autheticatin token,  Completion Handlers
 @return void
 */
- (void)fetchTutorialsWithParameter:(NSDictionary*)parameters withCompletionHandler:(void(^)(NSDictionary *responseDictionary))success andFailure:(void(^)(NSString *title, NSString *message))failed;


@end
