//
//  SubscriptionCollectionViewCell.h
//  Keychn
//
//  Created by Rohit Kumar on 23/11/2017.
//  Copyright © 2017 Keychn Experience. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubscriptionCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *popupContainerView;
@property (weak, nonatomic) IBOutlet UILabel *wantToLearnLabel;
@property (weak, nonatomic) IBOutlet UILabel *subscribeToKeychLabel;
@property (weak, nonatomic) IBOutlet UIButton *get2WeeksTrialButton;
@property (weak, nonatomic) IBOutlet UILabel *cancelAnyTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthlyLabel;
@property (weak, nonatomic) IBOutlet UILabel *keychnTermsLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearlyLabel;
;
@property (weak, nonatomic) IBOutlet UIButton *yearlySubscriptionButton;
@property (weak, nonatomic) IBOutlet UIButton *monthlySubscriptionButton;


@end
