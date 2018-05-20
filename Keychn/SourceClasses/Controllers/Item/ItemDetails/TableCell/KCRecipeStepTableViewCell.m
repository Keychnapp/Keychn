//
//  KCRecipeStepTableViewCell.m
//  Keychn
//
//  Created by Keychn Experience SL on 29/01/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import "KCRecipeStepTableViewCell.h"

@implementation KCRecipeStepTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
    // Customize UI
    self.stepPositionLabel.layer.borderWidth    = 3.0f;
    self.stepPositionLabel.layer.borderColor    = [UIColor stepPositionColor].CGColor;
    self.stepPositionLabel.layer.cornerRadius   = self.stepPositionLabel.frame.size.width/2;
    self.stepPositionLabel.layer.masksToBounds  = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
