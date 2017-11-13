//
//  UIFont+KCFont.m
//  Keychn
//
//  Created by Keychn Experience SL on 03/12/15.
//  Copyright © 2015 Keychn Experience SL. All rights reserved.
//

#import "UIFont+KCFont.h"

#define ROBOTO_FONT_REGULAR   @"Roboto-Regular"
#define ROBOTO_FONT_BOLD      @"Roboto-Bold"
#define ROBOTO_FONT_ITALIC    @"Roboto-Italic"
#define ROBOTO_FONT_LIGHT     @"Roboto-Light"
#define HELVETICA_FONT_OBLIQUE @"Helvetica-BoldOblique"
#define HELVETICA_FONT_THIN    @"HelveticaNeue-Thin"
#define HELVETICA_FONT_LIGHT   @"HelveticaNeue-Light"
#define HELVETICA_FONT_MEDIUM  @"HelveticaNeue-Medium"
#define ROBOTO_FONT_MEDIUM     @"Roboto-Medium"
#define ROBOTO_FONT_THIN       @"Roboto-Thin"
#define ROBOTO_FONT_MEDIUM_ITALIC @"Roboto-MediumItalic"
#define ROBOTO_FONT_BOLD_ITALIC @"Roboto-BoldItalic"


@implementation UIFont (KCFont)

+ (UIFont *)setRobotoFontBoldStyleWithSize:(CGFloat)fontSize {
    return [UIFont fontWithName:ROBOTO_FONT_BOLD size:fontSize];
}

+ (UIFont *)setRobotoFontRegularStyleWithSize:(CGFloat)fontSize {
    return [UIFont fontWithName:ROBOTO_FONT_REGULAR size:fontSize];
}

+ (UIFont *)setRobotoFontItalicStyleWithSize:(CGFloat)fontSize {
    return [UIFont fontWithName:ROBOTO_FONT_ITALIC size:fontSize];
}

+ (UIFont *)setRobotoFontLightStyleWithSize:(CGFloat)fontSize {
    return [UIFont fontWithName:ROBOTO_FONT_LIGHT size:fontSize];
}

+(UIFont*)setRobotoMediumFontWithSize:(CGFloat)fontSize {
    return [UIFont fontWithName:ROBOTO_FONT_MEDIUM size:fontSize];
}

+(UIFont*)setRobotoThinFontWithSize:(CGFloat)fontSize {
    return [UIFont fontWithName:ROBOTO_FONT_THIN size:fontSize];
}

+(UIFont*)setRobotoMediumItalicFontWithSize:(CGFloat)fontSize {
    return [UIFont fontWithName:ROBOTO_FONT_MEDIUM_ITALIC size:fontSize];
}

+(UIFont*)setRobotoBoldItalicFontWithSize:(CGFloat)fontSize {
    return [UIFont fontWithName:ROBOTO_FONT_BOLD_ITALIC size:fontSize];
}

+ (UIFont*) setHeleveticaBoldObliueFontWithSize:(CGFloat)fontSize {
    return [UIFont fontWithName:HELVETICA_FONT_OBLIQUE size:fontSize];
}

+(UIFont*)setHeleveticaLightFontWithSize:(CGFloat)fontSize {
    return [UIFont fontWithName:HELVETICA_FONT_LIGHT size:fontSize];
}

+(UIFont*)setHeleveticaMediumFontWithSize:(CGFloat)fontSize {
    return [UIFont fontWithName:HELVETICA_FONT_MEDIUM size:fontSize];
}

+(UIFont*)setHeleveticaThinFontWithSize:(CGFloat)fontSize {
    return [UIFont fontWithName:HELVETICA_FONT_THIN size:fontSize];
}



@end
