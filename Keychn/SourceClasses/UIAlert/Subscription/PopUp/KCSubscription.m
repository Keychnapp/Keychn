//
//  KCSubscription.m
//  Keychn
//
//  Created by Rohit on 31/08/17.
//  Copyright © 2017 Keychn Experience. All rights reserved.
//

#import "KCSubscription.h"
#import "KeychnStore.h"
#import "SubscriptionCollectionViewCell.h"
#import "TermsAndConditionCollectionViewCell.h"
#import "AppDelegate.h"
#import "TTTAttributedLabel.h"

@import SafariServices;

typedef NS_ENUM(NSUInteger, SubscriptionIndex) {
    MonthlySubscription,
    YearlySubscription
};

@interface KCSubscription () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, TTTAttributedLabelDelegate, UIGestureRecognizerDelegate>

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

#pragma mark - IB Outlets

@property (weak, nonatomic) IBOutlet UICollectionView *subscriptionCollectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *subscriptionLabel;



@end

@implementation KCSubscription

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    UIView *containerView = [[[NSBundle mainBundle] loadNibNamed:@"KeychnSubscription" owner:self options:nil] lastObject];
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
    tapGesture.delegate = self;
    [self addGestureRecognizer:tapGesture];
    
    // Set T&C Label
    self.subscriptionLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    NSRange range = [self.subscriptionLabel.text rangeOfString:@"Privacy Policy"];
    [self.subscriptionLabel addLinkToURL:[NSURL URLWithString:privacyPolicyURL] withRange:range];
    range = [self.subscriptionLabel.text rangeOfString:@"Terms of Service"];
    [self.subscriptionLabel addLinkToURL:[NSURL URLWithString:termsOfUsePolicy] withRange:range];
    
    
    // Regster CollectionView Cells
    [self.subscriptionCollectionView registerNib:[UINib nibWithNibName:@"SubscriptionCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"SubscriptionPopUp"];
    return self;
}


- (void)showInView:(UIView *)view withCompletionHandler:(void(^)(BOOL postiveButton))buttonTapped {
    //Present alert view with animation
    [view addSubview:self];
    self.transform                      = CGAffineTransformMakeScale(0.001, 0.001);
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished){
        // do something once the animation finishes, put it here
    }];
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
    NSString *productType = sender.tag == 0? @"Monthly":@"Yearly";
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"subscription_type"
         properties:@{@"type":productType}];
    
    NSString *productId = [kInAppPurchaseSusbcriptionArray objectAtIndex:viewIndex];
    KeychnStore *store  = [KeychnStore getSharedInstance];
    [store fetchAvailableProducts:productId withCompletionHandler:^(BOOL status) {
        
    }];
}

- (IBAction)privacyPolicyButtonTapped:(id)sender {
    SFSafariViewController *safariViewController = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:privacyPolicyURL]];
    AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    UINavigationController *rootViewController = (UINavigationController *) appDelegate.window.rootViewController;
    [rootViewController presentViewController:safariViewController animated:true completion:^{
        
    }];
}

- (void)termsAndConditionButtonTapped:(id)sender {
    SFSafariViewController *safariViewController = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:termsOfUsePolicy]];
    AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    UINavigationController *rootViewController = (UINavigationController *) appDelegate.window.rootViewController;
    [rootViewController presentViewController:safariViewController animated:true completion:^{
        
    }];
}

#pragma mark - CollectionView Datasource and Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return  1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return  CGSizeMake(310, 446);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
        SubscriptionCollectionViewCell *tableViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SubscriptionPopUp" forIndexPath:indexPath];
        // Add Button Targets
        [tableViewCell.monthlySubscriptionButton addTarget:self action:@selector(purchaseSubscriptionButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [tableViewCell.yearlySubscriptionButton addTarget:self action:@selector(purchaseSubscriptionButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        // Set the Attributed text
        NSMutableAttributedString *subscribeTo = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"subscribeTo", nil) attributes:@{NSFontAttributeName: [UIFont setRobotoFontRegularStyleWithSize:14] , NSForegroundColorAttributeName: [UIColor blackColor]}];
        NSAttributedString *keychn = [[NSAttributedString alloc] initWithString:[@" " stringByAppendingString:NSLocalizedString(@"Keychn", nil)]  attributes:@{NSFontAttributeName: [UIFont setRobotoFontRegularStyleWithSize:14], NSForegroundColorAttributeName: [UIColor appBackgroundColor]}];
        NSAttributedString *masterclass = [[NSAttributedString alloc] initWithString:[@" " stringByAppendingString:NSLocalizedString(@"Masterclass", nil)]  attributes:@{NSFontAttributeName: [UIFont setRobotoFontRegularStyleWithSize:14], NSForegroundColorAttributeName: [UIColor blackColor]}];
        [subscribeTo appendAttributedString:keychn];
        [subscribeTo appendAttributedString:masterclass];
        tableViewCell.subscribeToKeychLabel.attributedText = subscribeTo;
        
        return tableViewCell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // Set page control current page
    CGFloat pageWidth = self.subscriptionCollectionView.frame.size.width;
    self.pageControl.currentPage = self.subscriptionCollectionView.contentOffset.x / pageWidth;
}

#pragma mark - TTTAttributedLabelDelegate

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    // Open URL
    SFSafariViewController *safariViewController = [[SFSafariViewController alloc] initWithURL:url];
    AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    UINavigationController *rootViewController = (UINavigationController *) appDelegate.window.rootViewController;
    [rootViewController presentViewController:safariViewController animated:true completion:^{
        
    }];
}

#pragma mark - Gesture Delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if([touch.view isKindOfClass:[TTTAttributedLabel class]]) {
        return  false;
    }
    return  true;
}

@end
