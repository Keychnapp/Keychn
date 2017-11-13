//
//  KCBottomBar.h
//  Keychn
//
//  Created by Keychn on 01/09/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KCBottomBar : UIView

/**
 @abstract Get the shared instance of bottom bar
 @param void
 @return Instance Type
 */
+(instancetype)bottomBar;

- (void)selectScreenWithIndex:(TabIndex)index;

/**
 @abstract Instantiate a shared instance for the bottom bar
 @param CGRect frame
 @return instancetype Instance Type
 */
- (void)customizeUIWithFrame:(CGRect)frame;

/**
 @abstract Set text on tab buttons.
 @param void
 @return void
 */
- (void)setText;

@end
