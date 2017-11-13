//
//  KCLanguageOptionView.m
//  Keychn
//
//  Created by Keychn Experience SL on 30/12/15.
//  Copyright © 2015 Keychn Experience SL. All rights reserved.
//

#import "KCLanguageOptionView.h"

@implementation KCLanguageOptionView

- (instancetype)initWithFrame:(CGRect)frame {
   self  = [super initWithFrame:frame];
    self.languageSelectionImageView   = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 56, 38)];
    self.langugeSelectedBoxImageView  = [[UIImageView alloc] initWithFrame:CGRectMake(60, 26, 18, 18)];
    self.langugeSelectedBoxImageView.image = [UIImage imageNamed:@"select_icon.png"];
    [self addSubview:self.languageSelectionImageView];
    [self addSubview:self.langugeSelectedBoxImageView];
    self.languageSelectionImageView.userInteractionEnabled = YES;
    
    return self;
}

@end
