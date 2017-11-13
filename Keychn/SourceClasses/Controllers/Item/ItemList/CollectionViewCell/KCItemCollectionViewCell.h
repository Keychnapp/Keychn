//
//  KCItemCollectionViewCell.h
//  Keychn
//
//  Created by Keychn Experience SL on 21/01/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KCLabel.h"

@interface KCItemCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet KCLabel *itemTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *itemTitleLabelHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *itemTitleLabelHeightConstraintiPad;
@property (weak, nonatomic) IBOutlet UIView *itemSeparatorView;

@property (weak, nonatomic) IBOutlet UIView *schduledItemView;
@property (weak, nonatomic) IBOutlet UILabel *schedulteItemLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *imageDownloadProgressIndicatorView;


@end
