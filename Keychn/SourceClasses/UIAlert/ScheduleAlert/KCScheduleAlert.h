//
//  KCScheduleAlert.h
//  Keychn
//
//  Created by Keychn on 06/09/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PopUpScheduleType) {
    CookingNow,
    CookingLater
};

@interface KCScheduleAlert : UIView


+ (instancetype)scheduleAlertWithFrame:(CGRect)rect;

/**
 @abstract Present alert with animation.
 @param UIView Container View
 @return void
 */
- (void)showInView:(UIView *)view withItemName:(NSString *)itemName andTime:(NSString *)time andScheduleType:(PopUpScheduleType)type withCompletionHandler:(void(^)(BOOL postiveButton))buttonTapped;

- (void)showInView:(UIView *)view withItemName:(NSString *)itemName withCompletionHandler:(void(^)(BOOL postiveButton))buttonTapped;

- (void)dismiss;


@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *OkButton;


@end
