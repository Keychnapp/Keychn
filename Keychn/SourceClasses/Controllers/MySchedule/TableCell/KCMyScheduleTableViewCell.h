//
//  KCMyScheduleTableViewCell.h
//  Keychn
//
//  Created by Keychn Experience SL on 02/03/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KCLabel.h"

@interface KCMyScheduleTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *itemPictureImageView;
@property (strong, nonatomic) IBOutlet UIButton *chatButton;
@property (strong, nonatomic) IBOutlet UILabel *dayTimeLabel;
@property (strong, nonatomic) IBOutlet UIButton *itemTitleButton;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *imageDownloadIndicator;
@property (strong, nonatomic) IBOutlet UIButton *chatBubble;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *startCookingLabel;
@property (weak, nonatomic) IBOutlet UIButton *startCookingButton;

@end
