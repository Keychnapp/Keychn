//
//  KCRecipeStepTableViewCell.h
//  Keychn
//
//  Created by Keychn Experience SL on 29/01/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KCRecipeStepTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *stepPositionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *recipeStepImageView;
@property (weak, nonatomic) IBOutlet UILabel *recipeProcedureLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *receipeProcedureLabelHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *receipeProcedureLabelHeightConstraintiPad;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *recipeStepImageDownloadActivityIndicator;
@property (strong, nonatomic) IBOutlet UIView *stepBackgroundView;

@end
