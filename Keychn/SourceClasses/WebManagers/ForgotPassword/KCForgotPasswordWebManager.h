//
//  KCForgotPasswordWebManager.h
//  Keychn
//
//  Created by Keychn Experience SL on 07/01/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KCForgotPasswordWebManager : NSObject

/**
 @abstract This method will request a new password for the user
 @param User Details, Success Block , Failure Block with Error Title and Message
 @return void
 */
- (void) requestNewPasswordWithDetails:(NSDictionary*)params withCompletionHandler:(void(^)(NSDictionary *userProfile))success failure:(void (^)(NSString *title, NSString *message))failed;

@end
