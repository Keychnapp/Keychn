//
//  TermsAndConditionCollectionViewCell.h
//  Keychn
//
//  Created by Rohit Kumar on 23/11/2017.
//  Copyright © 2017 Keychn Experience. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TermsAndConditionCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIScrollView *tncScrollView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *termAndConditionButton;

@end
