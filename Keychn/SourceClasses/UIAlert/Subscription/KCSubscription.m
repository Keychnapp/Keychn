//
//  KCSubscription.m
//  Keychn
//
//  Created by Rohit on 31/08/17.
//  Copyright © 2017 Keychn Experience. All rights reserved.
//

#import "KCSubscription.h"
#import "KeychnStore.h"

typedef NS_ENUM(NSUInteger, SubscriptionIndex) {
    MonthlySubscription,
    YearlySubscription
};

@interface KCSubscription ()

@property (weak, nonatomic) IBOutlet UIView *popUpContainerView;
@property (weak, nonatomic) IBOutlet UILabel *wantToLearnLabel;
@property (weak, nonatomic) IBOutlet UILabel *subscribeToKeychLabel;
@property (weak, nonatomic) IBOutlet UIButton *get2WeeksTrialButton;
@property (weak, nonatomic) IBOutlet UILabel *cancelAnyTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthlyLabel;
@property (weak, nonatomic) IBOutlet UILabel *keychnTermsLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearlyLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *subscriptionScrollView;
@property (weak, nonatomic) IBOutlet UILabel *subscriptionTnCLabel;

@end

@implementation KCSubscription

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    UIView *containerView = [[[NSBundle mainBundle] loadNibNamed:@"Subscription" owner:self options:nil] lastObject];
    [self addSubview:containerView];
    containerView.frame    = frame;
    // Customize UI
    containerView.backgroundColor = [UIColor clearColor];
    self.popUpContainerView.layer.cornerRadius = 8.0f;
    self.popUpContainerView.layer.borderWidth  = 3.0f;
    self.popUpContainerView.layer.borderColor  = [UIColor appBackgroundColor].CGColor;
    self.subscriptionScrollView.contentInset   = UIEdgeInsetsMake(0, 0, 52, 0);
    
    // Add Tap gesture to close the view
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesturePerformedOnBlurView:)];
    [self addGestureRecognizer:tapGesture];
    
    return self;
}


- (void)showInView:(UIView *)view withCompletionHandler:(void(^)(BOOL postiveButton))buttonTapped {
    //Present alert view with animation
    [view addSubview:self];
    [self setText];
    self.transform                      = CGAffineTransformMakeScale(0.001, 0.001);
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished){
        // do something once the animation finishes, put it here
    }];
}

- (void)setText {
    // Set text on Labels and buttons
    self.wantToLearnLabel.text = AppLabel.lblYouWantToLearnFromExperts;
    [self.get2WeeksTrialButton setTitle:AppLabel.lblGetTrial forState:UIControlStateNormal];
    self.cancelAnyTimeLabel.text = AppLabel.lblCancelAnytime;
    self.monthlyLabel.text = AppLabel.lblMonthly;
    self.keychnTermsLabel.text = AppLabel.lblPremiumContentTerms;
    self.yearlyLabel.text = AppLabel.lblYearly;
    
    NSMutableAttributedString *subscribeToKeychn = [[NSMutableAttributedString alloc] initWithString:AppLabel.lblSubscribeTo attributes:@{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName:[UIFont setRobotoFontRegularStyleWithSize:15]}];
    NSAttributedString *keychn = [[NSAttributedString alloc] initWithString:[@" " stringByAppendingString:kAppName] attributes:@{NSForegroundColorAttributeName:[UIColor appBackgroundColor], NSFontAttributeName:[UIFont setRobotoFontRegularStyleWithSize:15]}];
     NSAttributedString *masterclass = [[NSAttributedString alloc] initWithString:[@" " stringByAppendingString:AppLabel.lblMasterClass] attributes:@{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName:[UIFont setRobotoFontRegularStyleWithSize:15]}];
     [subscribeToKeychn appendAttributedString:keychn];
    [subscribeToKeychn appendAttributedString:masterclass];
    self.subscribeToKeychLabel.attributedText = subscribeToKeychn;
//    self.subscriptionTnCLabel.text = AppLabel.lblSubscriptionTermsAndConditon;
}

- (void)dismiss {
    self.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.transform = CGAffineTransformMakeScale(0.001, 0.001);
    } completion:^(BOOL finished){
        // do something once the animation finishes, put it here
        [self removeFromSuperview];
    }];
}

- (void)tapGesturePerformedOnBlurView:(id)sender {
    [self dismiss];
}

- (IBAction)purchaseSubscriptionButtonTapped:(UIButton *)sender {
    [self dismiss];
    NSInteger viewIndex = sender.tag;
    NSString *productType = sender.tag == 0? @"Yearly":@"Monthly";
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"subscription_type"
         properties:@{@"type":productType}];
    
    NSString *productId = [kInAppPurchaseSusbcriptionArray objectAtIndex:viewIndex];
    KeychnStore *store  = [KeychnStore getSharedInstance];
    [store fetchAvailableProducts:productId withCompletionHandler:^(BOOL status) {
        
    }];
}



@end
