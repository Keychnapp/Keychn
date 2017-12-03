//
//  ImagePickerOverlayView.m
//  CustomImagePicker
//
//  Created by Keychn Experience SL on 19/02/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import "ImagePickerOverlayView.h"


@implementation ImagePickerOverlayView

- (instancetype)initWithFrame:(CGRect)frame {
    //Custom overlay for camera
   self = [super initWithFrame:frame];
    /*
    NSInteger screenWidth  = [UIScreen mainScreen].bounds.size.width;
    NSInteger screenHeight  = [UIScreen mainScreen].bounds.size.height;
    self.opaque = NO;
    self.backgroundColor = [UIColor clearColor];
    self.imagePickerButton = [[UIButton alloc] initWithFrame:CGRectMake((screenWidth-75)/2, screenHeight-110, 75, 75)];
    self.titleLabel        = [[UILabel alloc] initWithFrame:CGRectMake((screenWidth-280)/2, 0, 280, 111)];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [UIColor darkGrayColor];
    self.titleLabel.numberOfLines  = 3;
    self.alpha                     = 1.0;
    self.hidden                    = NO;
    NSString *showOffTitleText = [[NSString stringWithFormat:@"%@\n%@\n%@ %@",AppLabel.lblShowOff, AppLabel.lblHowGoodYouAre, AppLabel.lblInThe, appName] uppercaseString];
    
    NSRange range1 = [showOffTitleText rangeOfString:AppLabel.lblShowOff];
    NSRange range2 = [showOffTitleText rangeOfString:AppLabel.lblHowGoodYouAre];
    NSRange range3 = [showOffTitleText rangeOfString:AppLabel.lblInThe];
    NSRange range4 = [showOffTitleText rangeOfString:[appName uppercaseString]];
    
    NSMutableAttributedString *atrributedString = [[NSMutableAttributedString alloc] initWithString:showOffTitleText];
    [atrributedString setAttributes:@{NSFontAttributeName:[UIFont setRobotoFontRegularStyleWithSize:22]} range:range1];
    [atrributedString setAttributes:@{NSFontAttributeName:[UIFont setRobotoFontRegularStyleWithSize:22]} range:range2];
    [atrributedString setAttributes:@{NSFontAttributeName:[UIFont setRobotoFontRegularStyleWithSize:22]} range:range3];
    [atrributedString setAttributes:@{NSFontAttributeName:[UIFont setRobotoFontBoldStyleWithSize:22]} range:range4];
    self.titleLabel.attributedText = atrributedString;
    
    NSInteger titleLabelViewYPosition = 193;
    if([KCUtility getiOSDeviceType] == iPad) {
        titleLabelViewYPosition = 380;
    }
    
    self.containerView   = [[UIView alloc] initWithFrame:CGRectMake(0, titleLabelViewYPosition, screenWidth, 111)];
    self.containerView.backgroundColor = [UIColor colorWithWhite:0.8f alpha:0.7f];
    [self.containerView addSubview:self.titleLabel];
    [self addSubview:self.imagePickerButton];
    [self addSubview:self.containerView];
    [self.imagePickerButton setImage:[UIImage imageNamed:@"camera_icon.png"] forState:UIControlStateNormal];
    // Hide title label after 3 seconds
    [self performSelector:@selector(hideSubtitleLabelWithAnimation) withObject:nil afterDelay:3]; */
    return  self;
}


- (void) hideSubtitleLabelWithAnimation {
    // Hide title label
    __weak ImagePickerOverlayView *weakSelf = self;
    [UIView transitionWithView:self.containerView duration:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakSelf.titleLabel.alpha = 0;
        weakSelf.containerView.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        weakSelf.titleLabel.hidden = YES;
    }];
}

@end
