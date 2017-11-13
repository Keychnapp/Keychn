//
//  KCitemIngredientCountTableViewCell.h
//  Keychn
//
//  Created by Keychn Experience SL on 29/01/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KCitemIngredientCountTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *ingredientAvailabelLabel;
@property (strong, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet UILabel *ingredientAvailableCount;
@end
