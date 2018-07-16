//
//  KCItemDetailTableViewCell.h
//  Keychn
//
//  Created by Keychn Experience SL on 29/01/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KCItemDetailTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UIButton *itemLikeButton;
@property (weak, nonatomic) IBOutlet UILabel *itemTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeCounterButton;
@property (weak, nonatomic) IBOutlet UIButton *cookCounterButton;
@property (weak, nonatomic) IBOutlet UILabel *yummliciousLabel;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *ratingStarImageViewArray;
@property (weak, nonatomic) IBOutlet UILabel *recipeMinuteLabel;
@property (weak, nonatomic) IBOutlet UILabel *minutesTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *recipeDifficultyLabel;
@property (weak, nonatomic) IBOutlet UILabel *difficultyLabel;
@property (weak, nonatomic) IBOutlet UILabel *recipeServingLabel;
@property (weak, nonatomic) IBOutlet UILabel *servingsLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *itemImageDownloadActivityIndicator;
@property (weak, nonatomic) IBOutlet UIView *itemDetailContainerView;
@property (strong, nonatomic) IBOutlet UIImageView *scrollContentImageView;
@property (weak, nonatomic) IBOutlet UILabel *cookingNowLabel;
@property (weak, nonatomic) IBOutlet UIButton *playVideoButton;
@property (weak, nonatomic) IBOutlet UIView *videoPlayerView;

@end
