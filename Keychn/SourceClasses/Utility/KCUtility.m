//
//  KCUtility.m
//  Keychn
//
//  Created by Keychn Experience SL on 07/12/15.
//  Copyright © 2015 Keychn Experience SL. All rights reserved.
//

#import "KCUtility.h"
#import "KCUserProfileDBManager.h"
#import "AppDelegate.h"
#import "KCFacebookManager.h"
#import "KCGroupSessionGuestEndViewController.h"
#import "KCGroupSessionHostEndViewController.h"
#import "KCBottomBar.h"

@implementation KCUtility

+ (IOSDevices)getiOSDeviceType {
    //get the iOS Device Type according the screen size
    NSInteger screenHeight = CGRectGetHeight([UIScreen mainScreen].bounds);
    if(screenHeight == 480) {
        return iPhone4;
    }
    else if(screenHeight == 568) {
        return iPhone5;
    }
    else if(screenHeight == 667) {
        return iPhone6;
    }
    else if(screenHeight == 736) {
        return iPhone6Plus;
    }
    else if (screenHeight == 812) {
        return iPhoneX;
    }
    return iPad;
}

+ (void)openiOSSettings {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:^(BOOL success) {
        
    }];
}

+ (IOSVersion) getiOSVersion {
    //get the running iOS Version
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    NSInteger sysVerValue   = [systemVersion integerValue];
    if(sysVerValue == 7) {
        return iOS7;
    }
    else if(sysVerValue == 8) {
        return iOS8;
    }
    return iOS9;
}

+ (void) logOutUser {
    //log out user and delete logged in user profile
    KCUserProfileDBManager *userProfileDBManager = [KCUserProfileDBManager new];
    [userProfileDBManager deleteUserProfile];
    
    KCBottomBar *bottomBar = [KCBottomBar bottomBar];
    [bottomBar selectScreenWithIndex:Home];
    
    [[KCUserProfile sharedInstance] releseSharedInstance];
    
    //log out facebook session
    [[KCFacebookManager  new] logOutFacebookUser];
    
    // Clear notification badge
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
        
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies])
    {
        NSString* domainName = [cookie domain];
        NSRange domainRange = [domainName rangeOfString:@"facebook"];
        if(domainRange.length > 0)
        {
            [storage deleteCookie:cookie];
        }
    }
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    //remove all view controllers and set a new stack
    UIViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:signUpViewController];
    
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    UINavigationController *rootViewController = (UINavigationController*)appDelegate.window.rootViewController;
    
    NSArray *viewControllersStack   = @[viewController];
    [rootViewController setViewControllers:viewControllersStack animated:YES];
}

+ (NSString*)getValueSuffix:(NSInteger)value {
    // Get the value suffix
    NSInteger modeValue = value % 10;
    if (modeValue == 1) {
        return @"ST";
    }
    else if (modeValue == 2) {
        return @"ND";
    }
    else if (modeValue == 3) {
        return @"RD ";
    }
    return @"TH";
}

+(NSString*)getLastNameFromFullName:(NSString*)fullName {
    // Get last name of the user from full name
    fullName = [fullName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSArray *components = [fullName componentsSeparatedByString:@" "];
    if([components count] > 1) {
        return [components lastObject];
    }
    return fullName;
}

+(NSString*)getFirstNameFromFullName:(NSString*)fullName {
    // Get first name of the user from full name
    fullName = [fullName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSArray *components = [fullName componentsSeparatedByString:@" "];
    if([components count] > 1) {
        return [components firstObject];
    }
    return fullName;
}


+(NSString*)getUserNameFromMessage:(NSString*)alertMessage {
    // Get first name of the user from alert message
    alertMessage = [alertMessage stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSArray *components = [alertMessage componentsSeparatedByString:@":"];
    if([components count] > 1) {
        return [components firstObject];
    }
    return alertMessage;
}

@end
