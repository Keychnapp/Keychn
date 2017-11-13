//
//  KCScheduleAlert.m
//  Keychn
//
//  Created by Keychn on 06/09/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import "KCScheduleAlert.h"

@interface KCScheduleAlert ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLabel;
@property (nonatomic, copy) void (^actionPerformed) (BOOL positiveButton);


@end

@implementation KCScheduleAlert

+ (instancetype)scheduleAlertWithFrame:(CGRect)rect {
    KCScheduleAlert *containerView = [[[NSBundle mainBundle] loadNibNamed:@"ScheduleAlertView" owner:self options:nil] lastObject];
    containerView.frame    = rect;
    return containerView;
}

- (void)showInView:(UIView *)view withItemName:(NSString *)itemName andTime:(NSString *)time andScheduleType:(PopUpScheduleType)type withCompletionHandler:(void(^)(BOOL postiveButton))buttonTapped {
    // Displays an alert for item schedule
    //Present alert view with animation
    [view addSubview:self];
    self.itemNameLabel.text             = itemName;
    self.dateTimeLabel.text             = time;
    self.actionPerformed                = buttonTapped;
    switch (type) {
        case CookingNow:
            self.titleLabel.text                = AppLabel.lblAreYouGonnaCookNow;
            break;
        case CookingLater:
            self.titleLabel.text                = AppLabel.lblAreYouSureWantToJoin;
            break;
    }
    
    self.subtitleLabel.text             = AppLabel.lblCookingSession;
    self.transform                      = CGAffineTransformMakeScale(0.001, 0.001);
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished){
        // do something once the animation finishes, put it here
    }];
}

- (void)showInView:(UIView *)view withItemName:(NSString *)itemName withCompletionHandler:(void(^)(BOOL postiveButton))buttonTapped {
    // Displays an alert for item schedule
    //Present alert view with animation
    [view addSubview:self];
    self.itemNameLabel.text             = itemName;
    self.actionPerformed                = buttonTapped;
    self.dateTimeLabel.text             = nil;
    self.titleLabel.text                = AppLabel.lblAreYouGonnaCookNow;
    self.subtitleLabel.text             = AppLabel.lblCookingSession;
    self.transform                      = CGAffineTransformMakeScale(0.001, 0.001);
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished){
        // do something once the animation finishes, put it here
    }];
}

- (void)dismiss {
    self.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.transform = CGAffineTransformMakeScale(0.001, 0.001);
    } completion:^(BOOL finished){
        // do something once the animation finishes, put it here
        [self removeFromSuperview];
    }];
}

#pragma mark - Button Action

- (IBAction)cancelButtonTapped:(id)sender {
    // NO/Cancel button tapped
    self.actionPerformed(NO);
    [self dismiss];
}

- (IBAction)okButtonTapped:(id)sender {
    // YES button tapped
    self.actionPerformed(YES);
    [self dismiss];
}

@end
