//
//  KCSubscription.h
//  Keychn
//
//  Created by Rohit on 31/08/17.
//  Copyright © 2017 Keychn Experience. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KCSubscription : UIView

- (void)showInView:(UIView *)view withCompletionHandler:(void(^)(BOOL postiveButton))buttonTapped;

@end
