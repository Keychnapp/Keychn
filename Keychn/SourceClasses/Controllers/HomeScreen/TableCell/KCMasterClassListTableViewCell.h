//
//  KCMasterClassListTableViewCell.h
//  Keychn
//
//  Created by Rohit on 23/08/17.
//  Copyright © 2017 Keychn Experience. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TriLabelView;

@interface KCMasterClassListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *masterclassDetailButton;
@property (weak, nonatomic) IBOutlet UILabel *masterclassLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *masterchefImageView;
@property (weak, nonatomic) IBOutlet UILabel *masterchefFirstNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *masterchefLastNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *attendButton;
@property (weak, nonatomic) IBOutlet UIImageView *attendCheckmarkImageView;
@property (weak, nonatomic) IBOutlet TriLabelView *freeClassLabel;

    

@end
