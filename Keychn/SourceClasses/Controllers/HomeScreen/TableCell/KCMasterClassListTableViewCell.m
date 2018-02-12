//
//  KCMasterClassListTableViewCell.m
//  Keychn
//
//  Created by Rohit on 23/08/17.
//  Copyright © 2017 Keychn Experience. All rights reserved.
//

#import "KCMasterClassListTableViewCell.h"


@implementation KCMasterClassListTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.previewContainerView.layer.cornerRadius = 5.0f;
    self.previewContainerView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
