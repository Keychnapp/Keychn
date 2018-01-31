//
//  KCUIAlert.h
//  Keychn
//
//  Created by Keychn Experience SL on 31/12/15.
//  Copyright © 2015 Keychn Experience SL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KCUIAlert : NSObject

/**
 @abstract This method will show a UIAlert with custom postive button title and cancel button
 @param Positive Button Title, Alert Header, Alert Message, ButtonTap Handler
 @return void
*/
+ (void) showAlertWithButtonTitle:(NSString*)title alertHeader:(NSString*)header message:(NSString*)message withButtonTapHandler:(void(^)(BOOL positiveButton))buttonTapped;


+ (void)showAlertWithButtonTitle:(NSString *)title alertHeader:(NSString *)header message:(NSString *)message onViewController:(UIViewController *)viewController withButtonTapHandler:(void (^)(BOOL positiveButton))buttonTapped;

/**
 @abstract This method will show a UIAlert with one OK button.
 @param Alert Header, Alert Message, ButtonTap Handler
 @return void
 */
+ (void) showInformationAlertWithHeader:(NSString*)header message:(NSString*)message withButtonTapHandler:(void(^)(void))buttonTapped;

+ (void)showInformationAlertWithHeader:(NSString *)header message:(NSString *)message onViewController:(UIViewController *)viewController withButtonTapHandler:(void (^)(void))buttonTapped;

/**
 @abstract This method will show an alert for the User Schedule success
 @param Container View, Dismiss handler
 @return void
 */
- (void) showScheduleSuccessAlertOnView:(UIView*)view withButtonTapHandler:(void(^)(void))alertDismissed;

/**
 @abstract This method will show an alert when for a Thanks you note and user rating
 @param Container view and Dismiss Handler
 @return void
 */
- (void) showThanksAlertOnView:(UIView*)view withButtonTapHandler:(void(^)(NSInteger itemRating))alertDismissed;

/**
 @abstract This method will show an alert when for a Thanks you note, user rating and Item Title for Free/Ride
 @param Container view, current item rating and Dismiss Handler
 @return void
 */
- (void) showFreeRideThanksAlertOnView:(UIView*)view withCurrentRating:(NSInteger)currentRating withButtonTapHandler:(void(^)(NSInteger itemRating, NSString *itemTitle))alertDismissed;

/**
 @abstract This method will show an alert when for a Thanks you note, user rating and Item Title for Chew/It
 @param Container view, current item rating and Dismiss Handler
 @return void
 */
- (void)showChewItThanksAlertOnView:(UIView*)view withCurrentRating:(NSInteger)currentRating withButtonTapHandler:(void(^)(NSInteger itemRating, NSString *itemTitle))alertDismissed;

@end
