//
//  KCEmailSignUpButtonTableViewCell.h
//  Keychn
//
//  Created by Keychn Experience SL on 29/12/15.
//  Copyright © 2015 Keychn Experience SL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KCEmailSignUpButtonTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *signupButton;
@property (weak, nonatomic) IBOutlet UILabel *termsOfUseLabel;
@property (weak, nonatomic) IBOutlet UIButton *termsOfUseButton;
@property (weak, nonatomic) IBOutlet UIButton *privacyPolicyButton;
@property (weak, nonatomic) IBOutlet UILabel *privacyPolicyLabel;


@end
