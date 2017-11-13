//
//  KCLoginWebManager.h
//  Keychn
//
//  Created by Keychn Experience SL on 07/01/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KCLoginWebManager : NSObject

/**
 @abstract This method will login user with user credentials and notify for the success or error
 @param user details, success handler, failure handler
 @return void
*/
- (void)signInUserWithDetails:(NSDictionary *)userDetailDictionary withCompletionHandler:(void (^)(NSDictionary *response))success failure:(void (^)(NSString *, NSString *))failed;

@end
