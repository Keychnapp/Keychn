//
//  RecordedMasterclassTableViewCell.m
//  Keychn
//
//  Created by Rohit Kumar on 12/05/2018.
//  Copyright © 2018 Keychn Experience. All rights reserved.
//

#import "RecordedMasterclassTableViewCell.h"

@implementation RecordedMasterclassTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.masterclassImageView.layer.cornerRadius    = 5.0f;
    self.masterclassImageView.layer.masksToBounds   = YES;
    self.masterchefImageView.layer.cornerRadius     = 20.0f;
    self.masterchefImageView.layer.masksToBounds    = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
