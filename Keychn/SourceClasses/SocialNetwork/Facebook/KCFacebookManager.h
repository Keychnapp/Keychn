//
//  KCFacebookManager.h
//  Keychn
//
//  Created by Keychn Experience SL on 14/12/15.
//  Copyright © 2015 Keychn Experience SL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KCFacebookManager : NSObject

/**
 @abstract Connect to facebook and get user profile
 @param Completion handler for success
 @return void
*/
- (void) connectToFacebookWithViewController:(id)viewController completionHandler:(void(^)(BOOL flag))loggedIn;

/**
 @abstract This method will verify that the native facebook is installed on the device or not
 @param No Parameters
 @return YES if intalled else NO
 */
- (BOOL) isFacebookNativeAppInstalled;

/**
 @abstract Log out from facebook and clear all session data
 @param No Parameter
 @return void
 */
- (void) logOutFacebookUser;

/**
 @abstract This method will present a Facebook share dialog to share image if user is logged into facebook app
 @param Image to be shared, Presentor view controller, Completion Handler
 @return void
 */
- (void) showFacebookShareDialogWithImage:(UIImage*)image inViewController:(UIViewController*)controller withCompletionHandler:(void(^)(BOOL status))finished;

/**
 @abstract This method will present a Facebook share dialog to share text if user is logged into facebook app
 @param Text to be shared, Presentor view controller, Completion Handler
 @return void
 */
- (void)showFacebookShareDialogWithText:(NSString*)text inViewController:(UIViewController *)controller withCompletionHandler:(void (^)(BOOL))finished;

@end
