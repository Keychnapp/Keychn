//
//  KCTextNotifcationView.m
//  Keychn
//
//  Created by Keychn Experience SL on 02/05/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import "KCTextNotifcationView.h"
#import "AppDelegate.h"
#import "KCLabel.h"

@interface KCTextNotifcationView () {
    NSNumber    *_senderID;
    NSString    *_senderName;
    UINavigationController *_rootViewController;
    UIWindow                     *_newWindow;
}

@property (nonatomic,copy) void (^notifactionTapHandler) (NSNumber *userID);

@end

@implementation KCTextNotifcationView

- (void)showTextNotificationWithInfoDictionary:(NSDictionary*)messageDictionary andTapHandler:(void(^)(NSNumber* userID))notificationTapped {
    
    //Retain the tap handler completion block
    self.notifactionTapHandler = notificationTapped;
    
    // Show notification on top of the screen
    self.backgroundColor    = [UIColor bannerBackgroundColor];
    
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    CGRect      windowFrame  = appDelegate.window.bounds;
    _newWindow               = [[UIWindow alloc] initWithFrame:windowFrame];
    self.frame                 = CGRectMake(0, -60, CGRectGetWidth(windowFrame), 60);
    _newWindow.windowLevel         = UIWindowLevelStatusBar+1;
    _newWindow.hidden              = NO;
    _newWindow.backgroundColor     = [UIColor clearColor];
    [_newWindow makeKeyAndVisible];
    
    // Add subiews
//    UINavigationController *rootViewController = (UINavigationController*)appDelegate.window.rootViewController;
    [_newWindow addSubview:self];
    
    // Set text
    self.nowLabel.text = [NSLocalizedString(@"now", nil) lowercaseString];
    
    // Set corner radius for imageView
    self.appIconImageView.layer.cornerRadius  = 5;
    self.appIconImageView.layer.masksToBounds = YES;
    
    // Hide notification view after 10 seconds if user does not respond
    [self performSelector:@selector(hideNotifactionView) withObject:nil afterDelay:10.0f];
    
    // Add tap gesture on notification view
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesturePerformed:)];
    [self addGestureRecognizer:tapGesture];
    self.userInteractionEnabled        = YES;
 
    // Set text
   _senderID                = [messageDictionary objectForKey:kSenderID];
    NSString *alertMessage  = [messageDictionary objectForKey:kAlertMessage];
    _senderName             = [KCUtility getUserNameFromMessage:alertMessage];
    [self.messageButton setTitle:alertMessage forState:UIControlStateNormal];
    self.messageButton.titleLabel.numberOfLines = 2;
    
    CGFloat textWidth      = [NSString getWidthForText:alertMessage withViewHeight:42 withFontSize:15];
    if(textWidth >= CGRectGetWidth(windowFrame) - 61) {
        [self.messageButton setTitleEdgeInsets:UIEdgeInsetsMake(-15, 0, 0, 0)];
        self.messageButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    }
    
    
    // Show the view
    [self showNotificationViewWithAnimation];
    
}

- (void)hideNotifactionView {
    // Hide the notification view
    __block CGRect viewFrame = self.frame;
    viewFrame.origin.y = -60;
    [UIView transitionWithView:self duration:0.3f options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction animations:^{
        self.frame = viewFrame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        _newWindow.windowLevel = UIWindowLevelNormal;
        _newWindow             = nil;
    }];
}

- (void)showNotificationViewWithAnimation {
    // Display notification view with animation
    __block CGRect viewFrame = self.frame;
    viewFrame.origin.y = 0;
    [UIView transitionWithView:self duration:0.5f options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction animations:^{
        self.frame = viewFrame;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)tapGesturePerformed:(UIGestureRecognizer*)gestureRecognizer {
    // Tap gesture perormed on view
    
    // Hide the notification view
    [self hideNotifactionView];
    
    // Cancel the scheduled selector
    [NSThread cancelPreviousPerformRequestsWithTarget:self];
    
//    self.notifactionTapHandler(_senderID);
//    self.notifactionTapHandler = nil;
    
    // Push text chat view controller
    [self pushTextChatViewController];
    
}

- (void)pushTextChatViewController {
    // Push text message view controller
    
}


@end
