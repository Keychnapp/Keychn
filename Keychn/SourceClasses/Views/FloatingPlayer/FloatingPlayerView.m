//
//  FloatingPlayerView.m
//  Keychn
//
//  Created by Rohit Kumar on 01/07/2018.
//  Copyright © 2018 Keychn Experience. All rights reserved.
//

#import "FloatingPlayerView.h"

@interface FloatingPlayerView()


@end

@implementation FloatingPlayerView

#pragma mark - Initializer

- (instancetype)init {
    self = [super init];
    NSInteger width     = 240;
    NSInteger height    = 135;
    CGRect screenFrame  = [UIScreen mainScreen].bounds;
    NSInteger offset    = 20;
    NSInteger         x = CGRectGetWidth(screenFrame) - width;
    NSInteger         y = CGRectGetHeight(screenFrame) - height;
    self.frame          = CGRectMake(x-offset, y-offset, width, height);
    
    // Add a dark shadow
    [self.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [self.layer setShadowOpacity:0.5];
    [self.layer setShadowOffset:CGSizeZero];
    [self.layer setShadowRadius:5.0f];
    
    // Add a PanGesture to make Remote Video Movable
    UIPanGestureRecognizer *panGestureRecognizerForRemoteCameraView = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveUserPreviewViewWithGesture:)];
    [self addGestureRecognizer:panGestureRecognizerForRemoteCameraView];
    
    return self;
}

#pragma mark - Pan Gesture Movement

-(void)moveUserPreviewViewWithGesture:(UIPanGestureRecognizer*)panGestureRecognizer {
    if (panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGRect frame = panGestureRecognizer.view.frame;
        CGPoint translation = [panGestureRecognizer translationInView:panGestureRecognizer.view];
        frame.origin = CGPointMake(frame.origin.x + translation.x,
                                   frame.origin.y + translation.y);
        
        
        if(frame.origin.x > 0 && (frame.origin.x+frame.size.width) < self.superview.frame.size.width && frame.origin.y > 0 && (frame.origin.y+frame.size.height) < self.superview.frame.size.height) {
            [UIView animateWithDuration:0.2 animations:^{
                panGestureRecognizer.view.frame = frame;
            }];
        }
        [panGestureRecognizer setTranslation:CGPointZero inView:panGestureRecognizer.view];
    }
}


@end
