//
//  KCTwitterManager.h
//  Keychn
//
//  Created by Keychn Experience SL on 30/12/15.
//  Copyright © 2015 Keychn Experience SL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KCTwitterManager : NSObject

#pragma mark - Twitter Profile Keys

extern NSString const *TWUsername;
extern NSString const *TWUserFullName;
extern NSString const *TWUserEmailID;
extern NSString const *TWIdentifier;
extern NSString const *TWUserImageURL;

- (void)loginTwiiterAccountWithCompletionHandler:(void(^)(BOOL status))finished;

- (void) openTweetSheetWithTitle:(NSString*)title andImage:(UIImage*)image inViewController:(UIViewController*)view;

/**
 @abstract This method will display a Tweet sheet. The Twitter Framework is required to be installed to use this methodl.
 @param Message, Image and Completion Handler
 @return void
 */
- (void)composeTweetWithText:(NSString *)text andImage:(UIImage *)image inViewController:(UIViewController *)controller
       withCompletionHandler:(void(^)(BOOL isTweeted))finished;
@end
