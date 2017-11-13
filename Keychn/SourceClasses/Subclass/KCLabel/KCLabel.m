//
//  KCLabel.m
//  Keychn
//
//  Created by Keychn Experience SL on 28/01/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import "KCLabel.h"

@implementation KCLabel


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    NSInteger textInset = 12;
    UIEdgeInsets insets = UIEdgeInsetsMake(0, textInset, 0, 0);;
//    if(self.tag == 0) {
//      insets = UIEdgeInsetsMake(0, 0, 0, textInset);
//    }
//    else {
//      
//    }
    
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}


@end
