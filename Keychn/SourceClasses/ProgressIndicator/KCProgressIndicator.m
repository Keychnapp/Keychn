//
//  KCProgressIndicator.m
//  Keychn
//
//  Created by Keychn Experience SL on 31/12/15.
//  Copyright © 2015 Keychn Experience SL. All rights reserved.
//

#import "KCProgressIndicator.h"
#import "SVProgressHUD.h"

@implementation KCProgressIndicator

+ (void)showProgressIndicatortWithText:(NSString*)text {
    //show the custom progress activity indicator
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setForegroundColor:[UIColor appBackgroundColor]];
    [SVProgressHUD setBackgroundColor:[UIColor blackColorwithLightOpacity]];
    [SVProgressHUD setFont:[UIFont setRobotoFontBoldStyleWithSize:12]];
    [SVProgressHUD showWithStatus:text];
}

+(void) hideActivityIndicator {
    //hide the actiovity indicator
    [SVProgressHUD dismiss];
}

+ (void)showNonBlockingIndicator {
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD setForegroundColor:[UIColor appBackgroundColor]];
    [SVProgressHUD setRingThickness:3.0f];
    [SVProgressHUD setBackgroundColor:[UIColor clearColor]];
    [SVProgressHUD show];
}

@end
