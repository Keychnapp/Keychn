//
//  KCProgressIndicator.h
//  Keychn
//
//  Created by Keychn Experience SL on 31/12/15.
//  Copyright © 2015 Keychn Experience SL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KCProgressIndicator : NSObject

/**
 @abstract This mehtod will show the activity indicator with text
 @param text to be displayed
 @return void
*/
+ (void) showProgressIndicatortWithText:(NSString*)text;

/**
 @abstract This method will hide the activity indicator
 @param No Parameter
 @return void
 */
+(void) hideActivityIndicator;


/**
 @abstract This method will show an activity indicator without masking the user interaction
 @param No Parameter
 @return void
 */
+ (void) showNonBlockingIndicator;

@end
