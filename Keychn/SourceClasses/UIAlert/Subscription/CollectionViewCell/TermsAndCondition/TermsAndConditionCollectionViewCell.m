//
//  TermsAndConditionCollectionViewCell.m
//  Keychn
//
//  Created by Rohit Kumar on 23/11/2017.
//  Copyright © 2017 Keychn Experience. All rights reserved.
//

#import "TermsAndConditionCollectionViewCell.h"

@implementation TermsAndConditionCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    // Customize UI
    self.containerView.layer.cornerRadius = 8.0f;
    self.containerView.layer.borderWidth  = 3.0f;
    self.containerView.layer.borderColor  = [UIColor appBackgroundColor].CGColor;
}

@end
