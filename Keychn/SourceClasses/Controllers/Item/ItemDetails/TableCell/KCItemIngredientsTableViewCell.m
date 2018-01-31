//
//  KCItemIngredientsTableViewCell.m
//  Keychn
//
//  Created by Keychn Experience SL on 29/01/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import "KCItemIngredientsTableViewCell.h"

@implementation KCItemIngredientsTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)addBorderToView {
    // Top border
    CALayer *topBorder = [CALayer layer];
    topBorder.frame = CGRectMake(0.0f, 0.0f, 330.0f, 1.0f);
    topBorder.backgroundColor = [UIColor separatorLineColor].CGColor;
    
    // Left side border
    CALayer *leftSideBorder = [CALayer layer];
    leftSideBorder.frame      = CGRectMake(0, 0, 1, 55);
    leftSideBorder.backgroundColor = [UIColor separatorLineColor].CGColor;
    
    // Right side border
    CALayer *rightSideBorder = [CALayer layer];
    rightSideBorder.frame      = CGRectMake(329, 0, 1, 55);
    rightSideBorder.backgroundColor = [UIColor separatorLineColor].CGColor;
    
    [self.containerView.layer addSublayer:topBorder];
    [self.containerView.layer addSublayer:leftSideBorder];
    [self.containerView.layer addSublayer:rightSideBorder];
}

@end
