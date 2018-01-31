//
//  KCAutoLoginManager.h
//  Keychn
//
//  Created by Keychn Experience SL on 18/01/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KCAutoLoginManager : NSObject

/**
 @abstract This method will validate the user credentials and switch to screens accordingly.
 @param No Parameter
 @return void
*/
- (void) validateUserLogin;

/**
 @abstract This method will verify App version update, if it is updated in background it will bring the app to Sign Up screen
 @param No Parameter
 @return void
 */
- (void) validateAppVersionUpdate;

@end
