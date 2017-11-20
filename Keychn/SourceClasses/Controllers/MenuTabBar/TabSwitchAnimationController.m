//
//  TabSwitchAnimationController.m
//  Keychn
//
//  Created by Rohit Kumar on 20/11/2017.
//  Copyright © 2017 Keychn Experience. All rights reserved.
//

#import "TabSwitchAnimationController.h"

@implementation TabSwitchAnimationController

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController* fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController* toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView* toView = toVC.view;
    UIView* fromView = fromVC.view;
    
    UIView* containerView = [transitionContext containerView];
    [containerView addSubview:toView];
    toView.frame = [transitionContext finalFrameForViewController:toVC];
    
    // Animate by fading
    toView.alpha = 0.0;
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         toView.alpha = 1.0;
                     }
                     completion:^(BOOL finished) {
                         toView.alpha = 1.0;
                         [fromView removeFromSuperview];
                         [transitionContext completeTransition:YES];
                     }];
}

@end

