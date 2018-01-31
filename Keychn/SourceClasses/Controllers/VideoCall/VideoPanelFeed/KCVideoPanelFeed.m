//
//  KCVideoPanelFeed.m
//  Keychn
//
//  Created by Keychn Experience SL on 26/04/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import "KCVideoPanelFeed.h"

@implementation KCVideoPanelFeed

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    UIView *xibView = [[[NSBundle mainBundle] loadNibNamed:@"VideoFeedPanel"
                                                     owner:self
                                                   options:nil] objectAtIndex:0];
    xibView.frame = self.bounds;
    xibView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview: xibView];
    
    // Set corner radius
    self.usernameContainerView.layer.cornerRadius  = 6.0f;
    self.usernameContainerView.layer.masksToBounds = YES;
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

@end
