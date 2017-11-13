//
//  KCUserProfileDBManager.h
//  Keychn
//
//  Created by Keychn Experience SL on 31/12/15.
//  Copyright © 2015 Keychn Experience SL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KCUserProfileDBManager : NSObject

/**
 @abstract This method will save logged in user in local database
 @param No Parameter
 @return void
*/
- (void)saveCurrentUserWithCompletionHandler:(void(^)(void))finished;

/**
 @abstract This method will fetch user profile from local database,if found, it will intialize user profile shared instance
 @param No Parameter
 @return void
 */
- (void) getLoggedInUserProfile;

/**
 @abstract This method will save user profile and user social profile into local database
 @param Response Dictionary
 @return void
 */
- (void) saveUserWithSocialProfile:(NSDictionary*)response;

/**
 @abstract This method will delete user profile and user social profile from local database
 @param No Parameter
 @return void
 */
- (void) deleteUserProfile;

/**
 @abstract This method will save user's facebook profile in local database
 @param User ID
 @return void
 */
- (void) saveFacebookProfileWithUserID:(NSNumber*)userID;

/**
 @abstract This method will update user profile in local database
 @param User Profile to be updated
 @return void
 */
- (void)updateUserProfile:(KCUserProfile*)userProfile;

@end
