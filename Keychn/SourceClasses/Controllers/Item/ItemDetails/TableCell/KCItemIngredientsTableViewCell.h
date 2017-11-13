//
//  KCItemIngredientsTableViewCell.h
//  Keychn
//
//  Created by Keychn Experience SL on 29/01/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KCItemIngredientsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *ingredientLabel;
@property (weak, nonatomic) IBOutlet UIButton *ingredientAvailableButton;
@property (strong, nonatomic) IBOutlet UIView *containerView;

/**
 @abstract This mehtod will add border to the container view on three side of the view except the bottom
 @param No Parameters
 @return void
 */
- (void) addBorderToView;

@end
