//
//  NSString+KCValidation.h
//  Keychn
//
//  Created by Keychn Experience SL on 31/12/15.
//  Copyright © 2015 Keychn Experience SL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (KCValidation)

/**
 @abstract This method will verify user's name for nil value
 @param User's Name
 @return Error Message on Failure else nil
*/
+ (NSString*)validateName:(NSString*)text;

/**
 @abstract This method will verify user's email address for nil value and valid email address
 @param User's Email Adress
 @return Error Message on Failure else nil
 */
+ (NSString*)validateEmailAddress:(NSString*)text;

/**
 @abstract This method will verify user's password
 @param User's Password
 @return Error Message on Failure else nil
 */
+ (NSString*)validatePassword:(NSString*)text;

/**
 @abstract This method will verify user's confirm password for nil value
 @param User's Password
 @return Error Message on Failure else nil
 */
+ (NSString*)validateConfirmPassword:(NSString*)text;

/**
 @abstract This method will compare user password and confirm password
 @param User's Password and Confrom Password
 @return Error Message on Failure else nil
 */
+(NSString*)matchPasswords:(NSString*)password andConfirmPassword:(NSString*)confirmPassword;

- (NSString*)escapeSequence;

/**
 @abstract This method will check for the null string
 @param text to be validated
 @return YES if valid else NO
 */
+ (BOOL) validateString:(id)string;

/**
 @abstract This method will calculate the text width to fit into view.
 @param Text, View Height, Font Size
 @return Text approx width
 */
+ (CGFloat) getWidthForText:(NSString*)text withViewHeight:(CGFloat)height withFontSize:(CGFloat)fontSize;

/**
 @abstract This method will calculate the text height to fit into view.
 @param Text, View width, Font Size
 @return Text approx height
 */
+ (CGFloat) getHeightForText:(NSString*)text withViewWidth:(CGFloat)width withFontSize:(CGFloat)fontSize;

+ (CGFloat)widthForText:(NSString*)text andFontSize:(CGFloat)fontSize;

@end
