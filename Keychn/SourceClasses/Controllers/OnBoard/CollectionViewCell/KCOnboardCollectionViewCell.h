//
//  KCOnboardCollectionViewCell.h
//  Keychn
//
//  Created by Keychn on 14/09/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KCOnboardCollectionViewCell : UICollectionViewCell

// OnBoardCollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *outlineCircleView;
@property (weak, nonatomic) IBOutlet UIImageView *boardImageView;
@property (weak, nonatomic) IBOutlet UILabel *enTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *enDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *spTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *spDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end
