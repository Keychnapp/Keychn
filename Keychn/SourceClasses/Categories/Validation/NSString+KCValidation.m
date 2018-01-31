//
//  NSString+KCValidation.m
//  Keychn
//
//  Created by Keychn Experience SL on 31/12/15.
//  Copyright © 2015 Keychn Experience SL. All rights reserved.
//

#import "NSString+KCValidation.h"

#define DATABASE_STRING_NULL      @"(null)"
#define NULL_STRING               @"<null>"


@implementation NSString (KCValidation)

+ (NSString *)validateName:(NSString *)text {
    //Validate user's name
    if(text.length == 0) {
        return NSLocalizedString(@"nameEmpty", nil);
    }
    return nil;
}

+ (NSString *)validateEmailAddress:(NSString *)text {
    //Validate user's email address
    if(text.length == 0) {
        return NSLocalizedString(@"emailEmpty", nil);
    }
    NSString *regExPattern = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:text options:0 range:NSMakeRange(0, [text length])];
    if (regExMatches == 0) {
        return NSLocalizedString(@"emailInvalid", nil);
    }
    return nil;
}

+ (NSString *)validatePassword:(NSString *)text {
    //Validate password
    if(text.length < 6) {
        return NSLocalizedString(@"passwordInvalid", nil);
    }
    return nil;
}


- (NSString*)escapeSequence {
    // Escape ' character for database insertion
    return [self stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
}

+ (BOOL) validateString:(id)string {
    //Validae a string for null values
    if(
       string &&
       ![string isKindOfClass:[NSNull class]]) {
        
        if( [string isKindOfClass:[NSString class]]) {
            
            if([string length] > 0 && ![string isEqualToString:DATABASE_STRING_NULL] &&
               ![string isEqualToString:NULL_STRING] )   {
                
                return true;
            }
            else {
                return false;
            }
        }
        return true;
    }
    return false;
}

+ (CGFloat) getWidthForText:(NSString*)text withViewHeight:(CGFloat)height withFontSize:(CGFloat)fontSize {
    //Get text fit width according to text and view height
    UIFont *fontType  = [UIFont setRobotoFontBoldStyleWithSize:fontSize];
    CGSize size     = [text boundingRectWithSize:CGSizeMake(MAXFLOAT,height)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{
                                                   NSFontAttributeName :fontType
                                                   }
                                         context:nil].size;
    if(size.width > CGRectGetWidth([UIScreen mainScreen].bounds)) {
        return CGRectGetWidth([UIScreen mainScreen].bounds);
    }
    return size.width;
}

+ (CGFloat) getHeightForText:(NSString*)text withViewWidth:(CGFloat)width withFontSize:(CGFloat)fontSize {
    //Get text fit height according to text and view width
    UIFont *fontType  = [UIFont setRobotoFontRegularStyleWithSize:fontSize];
    CGSize size     = [text boundingRectWithSize:CGSizeMake(width,MAXFLOAT)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{
                                                   NSFontAttributeName :fontType
                                                   }
                                         context:nil].size;
    if(size.height > CGRectGetHeight([UIScreen mainScreen].bounds)) {
        return CGRectGetHeight([UIScreen mainScreen].bounds);
    }
    return size.height;
}

+ (CGFloat)widthForText:(NSString*)text andFontSize:(CGFloat)fontSize {
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName : [UIFont setRobotoFontBoldStyleWithSize:fontSize]}];
    return size.width;
}

@end
