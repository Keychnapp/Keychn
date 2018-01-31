//
//  UIFont+KCFont.h
//  Keychn
//
//  Created by Keychn Experience SL on 03/12/15.
//  Copyright © 2015 Keychn Experience SL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (KCFont)

/**
 @abstract Set the custom font of Roboto family with regular style
 @param font size to be set
 @return System Font Type
 */
+ (UIFont*) setRobotoFontRegularStyleWithSize:(CGFloat)fontSize;

/**
 @abstract Set the custom font of Roboto family with bold style
 @param font size to be set
 @return System Font Type
 */
+ (UIFont*) setRobotoFontBoldStyleWithSize:(CGFloat)fontSize;

/**
 @abstract Set the custom font of Roboto family with italic style
 @param font size to be set
 @return System Font Type
 */
+ (UIFont *)setRobotoFontItalicStyleWithSize:(CGFloat)fontSize;

/**
 @abstract Set the custom font of Roboto family with light style
 @param font size to be set
 @return System Font Type
 */
+ (UIFont *)setRobotoFontLightStyleWithSize:(CGFloat)fontSize;

/**
 @abstract Set the custom font of Roboto family with medium bold style
 @param font size to be set
 @return System Font Type
 */
+(UIFont*)setRobotoMediumFontWithSize:(CGFloat)fontSize;

/**
 @abstract Set the custom font of Roboto family with thin style
 @param font size to be set
 @return System Font Type
 */
+(UIFont*)setRobotoThinFontWithSize:(CGFloat)fontSize;

/**
 @abstract Set the custom font of Roboto family with Medium Italic style
 @param font size to be set
 @return System Font Type
 */
+(UIFont*)setRobotoMediumItalicFontWithSize:(CGFloat)fontSize;

/**
 @abstract Set the custom font of Roboto family with Bold Italic style
 @param font size to be set
 @return System Font Type
 */
+(UIFont*)setRobotoBoldItalicFontWithSize:(CGFloat)fontSize;

/**
 @abstract Set the custom font of Helvetica family with bold and italic style
 @param font size to be set
 @return System Font Type
 */
+ (UIFont*) setHeleveticaBoldObliueFontWithSize:(CGFloat)fontSize;

/**
 @abstract Set the custom font of Helvetica family with light font style
 @param font size to be set
 @return System Font Type
 */
+(UIFont*)setHeleveticaLightFontWithSize:(CGFloat)fontSize;

/**
 @abstract Set the custom font of Helvetica family with medium font style
 @param font size to be set
 @return System Font Type
 */
+(UIFont*)setHeleveticaMediumFontWithSize:(CGFloat)fontSize;

/**
 @abstract Set the custom font of Helvetica family with thin font style
 @param font size to be set
 @return System Font Type
 */
+(UIFont*)setHeleveticaThinFontWithSize:(CGFloat)fontSize;

@end
