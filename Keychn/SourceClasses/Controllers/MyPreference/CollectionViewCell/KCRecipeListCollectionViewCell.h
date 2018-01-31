//
//  KCRecipeListCollectionViewCell.h
//  Keychn
//
//  Created by Rohit on 06/09/17.
//  Copyright © 2017 Keychn Experience. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KCRecipeListCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UILabel *itemTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *openRecipeButton;

@end
