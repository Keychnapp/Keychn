//
//  KCTextNotifcationView.h
//  Keychn
//
//  Created by Keychn Experience SL on 02/05/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface KCTextNotifcationView : UIView


/**
 @abstract This method will show a notification view on top of the screen when a text messgae is received.
 @param User Message Dictionary, Notification Display Handler
 @return void
 */
- (void)showTextNotificationWithInfoDictionary:(NSDictionary*)messageDictionary andTapHandler:(void(^)(NSNumber* userID))notificationTapped;

@property (weak, nonatomic) IBOutlet UIImageView *appIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *keychnLabel;
@property (weak, nonatomic) IBOutlet UILabel *nowLabel;
@property (weak, nonatomic) IBOutlet UIButton *messageButton;

@end
