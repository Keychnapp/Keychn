//
//  SubscriptionCollectionViewCell.m
//  Keychn
//
//  Created by Rohit Kumar on 23/11/2017.
//  Copyright © 2017 Keychn Experience. All rights reserved.
//

#import "SubscriptionCollectionViewCell.h"

@implementation SubscriptionCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    // Customize UI
    self.popupContainerView.layer.cornerRadius = 8.0f;
    self.popupContainerView.layer.borderWidth  = 3.0f;
    self.popupContainerView.layer.borderColor  = [UIColor appBackgroundColor].CGColor;
    
    NSMutableAttributedString *subscribeToKeychn = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"subscribeTo", nil) attributes:@{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName:[UIFont setRobotoFontRegularStyleWithSize:15]}];
    NSAttributedString *keychn = [[NSAttributedString alloc] initWithString:[@" " stringByAppendingString:kAppName] attributes:@{NSForegroundColorAttributeName:[UIColor appBackgroundColor], NSFontAttributeName:[UIFont setRobotoFontRegularStyleWithSize:15]}];
    NSAttributedString *masterclass = [[NSAttributedString alloc] initWithString:[@" " stringByAppendingString:NSLocalizedString(@"masterclass", nil)] attributes:@{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName:[UIFont setRobotoFontRegularStyleWithSize:15]}];
    [subscribeToKeychn appendAttributedString:keychn];
    [subscribeToKeychn appendAttributedString:masterclass];
    self.subscribeToKeychLabel.attributedText = subscribeToKeychn;
}

@end
