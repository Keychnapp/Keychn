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

typedef NS_ENUM(NSUInteger, SubscriptionIndex) {
    MonthlySubscription,
    YearlySubscription
};

@interface KCSubscription () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

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
    [self addGestureRecognizer:tapGesture];
    
    // Regster CollectionView Cells
    [self.subscriptionCollectionView registerNib:[UINib nibWithNibName:@"SubscriptionCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"SubscriptionPopUp"];
    [self.subscriptionCollectionView registerNib:[UINib nibWithNibName:@"TermsAndConditionCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"SubscriptionTnC"];
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
   /* self.wantToLearnLabel.text = AppLabel.lblYouWantToLearnFromExperts;
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
//    self.subscriptionTnCLabel.text = AppLabel.lblSubscriptionTermsAndConditon; */
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

#pragma mark - CollectionView Datasource and Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return  2;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return  CGSizeMake(310, 520);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0) {
        SubscriptionCollectionViewCell *tableViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SubscriptionPopUp" forIndexPath:indexPath];
        // Add Button Targets
        [tableViewCell.monthlySubscriptionButton addTarget:self action:@selector(purchaseSubscriptionButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [tableViewCell.yearlySubscriptionButton addTarget:self action:@selector(purchaseSubscriptionButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        return tableViewCell;
    }
    
    // Terms and Condition Cell
    TermsAndConditionCollectionViewCell *tncCollectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SubscriptionTnC" forIndexPath:indexPath];
    return tncCollectionViewCell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // Set page control current page
    CGFloat pageWidth = self.subscriptionCollectionView.frame.size.width;
    self.pageControl.currentPage = self.subscriptionCollectionView.contentOffset.x / pageWidth;
}


@end
