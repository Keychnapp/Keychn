//
//  KCSignUpWebManager.h
//  Keychn
//
//  Created by Keychn Experience SL on 30/12/15.
//  Copyright © 2015 Keychn Experience SL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KCSignUpWebManager : NSObject

/**
 @abstract This method will register a user with user provided details.
 @param User Details, Success Block with User Profile, Failure Block with Error Title and Message
 @return void
*/
- (void) signUpUserWithDetails:(NSDictionary*)userDetailDictionary withCompletionHandler:(void(^)(NSDictionary *userProfile))success failure:(void (^)(NSString *title, NSString *message))failed;

/**
 @abstract This method will register a user with social account
 @param User Details, Success Block with User Profile, Failure Block with Error Title and Message
 @return void
 */
- (void)signUpWithSocialAccount:(NSDictionary*)userDetailDictionary withCompletionHandler:(void (^)(NSDictionary *response))success failure:(void (^)(NSString *title, NSString *message, BOOL shouldMerge))failed;

/**
 @abstract This method will merge a Keychn account with user's Keychn account
 @param User Details, Success Block with User Profile, Failure Block with Error Title and Message
 @return void
 */
- (void) mergeSocialAccount:(NSDictionary*)userDetailDictionary withCompletionHandler:(void (^)(NSDictionary *))success failure:(void (^)(NSString *title, NSString *message))failed;

/**
 @abstract This method will link user's Facebook account with already existing Keychn's account
 @param User Details, Success Block with User Profile, Failure Block with Error Title and Message
 @return void
 */
- (void) linkFacebookAccount:(NSDictionary*)userDetailDictionary withCompletionHandler:(void (^)(NSDictionary *))success failure:(void (^)(NSString *title, NSString *message))failed;

/**
 @abstract This method will change Facebook active status to YES/NO on server
 @param User Details and Completion Handlers
 @return void
 */
- (void) changeStatusForFacebookAccountWithParameters:(NSDictionary*)parameters withCompletionHandler:(void(^)(NSDictionary *))success failure:(void (^)(NSString *title, NSString *message))failed;

/**
 @abstract This method will log out user from server and user won't receive notifications after Logging Out
 @param User Profile Details and Completion Handler
 @return void
 */
- (void) logOutUserWithParameters:(NSDictionary*)parameters CompletinHandler:(void(^)(BOOL status))loggedOut;

@end
