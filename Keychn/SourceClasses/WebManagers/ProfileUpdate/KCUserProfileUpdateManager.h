//
//  KCUserProfileUpdateManager.h
//  Keychn
//
//  Created by Keychn Experience SL on 06/01/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KCUserProfileUpdateManager : NSObject

/**
 @abstract This method will upload user image on server and also updates the current location
 @param File data,params and completion handlers
 @return void
*/
- (void)updateUserProfileWithImageData:(NSData*)fileData andParams:(NSDictionary*)params withCompletionHandler:(void(^)(NSDictionary *userProfile))success failure:(void (^)(NSString *title, NSString *message))failed;


/**
 @abstract This mehtod will update user password on server
 @param Current password and new password
 @return void
 */
- (void)updateUserPasswordWithParameters:(NSDictionary*)parameters withCompletionHandler:(void(^)(NSString *title, NSString *message))success failure:(void (^)(NSString *title, NSString *message))failed;

@end
