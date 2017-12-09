//
//  LandingViewController.m
//  Keychn
//
//  Created by Rohit Kumar on 25/11/2017.
//  Copyright © 2017 Keychn Experience. All rights reserved.
//

#import "LandingViewController.h"
#import "LandingCollectionViewCell.h"
#import "KCFacebookManager.h"
#import "KCSignUpWebManager.h"
#import "KCUserProfileDBManager.h"


@interface LandingViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout> {
    KCFacebookManager       *_facebookManager;
    KCSignUpWebManager      *_signUpWebManager;
    NSArray                 *_kOnboardingTextArray;
}

#define kOnBoardImageArray @[@"onboarding_1", @"onboarding_2", @"onboarding_3"]

@property (weak, nonatomic) IBOutlet UICollectionView *onBoardingCollectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIButton *alreadyHaveAnAccountButton;


@end

@implementation LandingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _kOnboardingTextArray = @[NSLocalizedString(@"onboarding1", nil), NSLocalizedString(@"onboarding2", nil), NSLocalizedString(@"onboarding3", nil)];
    
    // Set attributed text
    NSMutableAttributedString *alreadyHaveAccountString = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"alreadyHaveAccount", nil) attributes:@{NSFontAttributeName: [UIFont setRobotoFontRegularStyleWithSize:15] , NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    NSAttributedString *signInText = [[NSAttributedString alloc] initWithString:[@" " stringByAppendingString:NSLocalizedString(@"signIn", nil)]  attributes:@{NSFontAttributeName: [UIFont setRobotoFontRegularStyleWithSize:15], NSForegroundColorAttributeName: [UIColor appBackgroundColor]}];
    [alreadyHaveAccountString appendAttributedString:signInText];
    [self.alreadyHaveAnAccountButton setAttributedTitle:alreadyHaveAccountString forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return  3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LandingCollectionViewCell *onBoardingCollectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifierForOnboardCollection forIndexPath:indexPath];
    onBoardingCollectionViewCell.onboardImageView.image = [UIImage imageNamed:[kOnBoardImageArray objectAtIndex:indexPath.row]];
    onBoardingCollectionViewCell.onBoardTextLabel.text  = [_kOnboardingTextArray objectAtIndex:indexPath.row];
    return  onBoardingCollectionViewCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.onBoardingCollectionView.bounds.size;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // Set page control current page
    CGFloat pageWidth = self.onBoardingCollectionView.frame.size.width;
    self.pageControl.currentPage = self.onBoardingCollectionView.contentOffset.x / pageWidth;
}

#pragma mark - Instance Method

- (void)pushHomeViewController {
    UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:kHomeViewController];
    AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    UINavigationController *rootViewController = (UINavigationController *) appDelegate.window.rootViewController;
    [rootViewController pushViewController:viewController animated:YES];
}

#pragma mark - Button Action

- (IBAction)loginWithFacebookButtonTapped:(id)sender {
    // Login with Facebook Button Tapped
    if(isNetworkReachable) {
        Mixpanel *mixpanel = [Mixpanel sharedInstance];
        [mixpanel track:@"login_facebook_button"
             properties:@{@"":@""}];
        _facebookManager = [[KCFacebookManager alloc] init];
        [_facebookManager connectToFacebookWithViewController:self completionHandler:^(BOOL flag) {
            //Facebook data fetched, login with facebook
            if(flag) {
                [self loginWithFacebook];
            }
        }];
    }
    else {
        //Show alert for no internet connection
        [KCUIAlert showInformationAlertWithHeader:NSLocalizedString(@"networkError", nil) message:NSLocalizedString(@"tryReconnecting", nil) onViewController:self withButtonTapHandler:^{
            
        }];
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Server End Code

- (void)loginWithFacebook {
    //Login with facebook with completion handler
    if(!_signUpWebManager) {
        _signUpWebManager = [KCSignUpWebManager new];
    }
    __weak id weakSelf = self;
    NSDictionary *userSocialProfileDictionary = [[KCUserProfile sharedInstance].facebookProfile getSocialUserProfileDictionary];
    [_signUpWebManager signUpWithSocialAccount:userSocialProfileDictionary withCompletionHandler:^(NSDictionary *response) {
        //Save user profile with social profile in local database
        KCUserProfileDBManager *userProfileDBManager = [KCUserProfileDBManager new];
        [userProfileDBManager saveUserWithSocialProfile:response];
        [weakSelf pushHomeViewController];
        
    } failure:^(NSString *title, NSString *message, BOOL shouldMerge) {
        if(shouldMerge) {
            //Social merge options
            [KCUIAlert showAlertWithButtonTitle:NSLocalizedString(@"merge", nil) alertHeader:title message:message onViewController:self withButtonTapHandler:^(BOOL positiveButton) {
                if(positiveButton) {
                    [self mergeFacebookProfile];
                }
            }];
        }
        else {
            //Request failed, show error alert
            [KCUIAlert showInformationAlertWithHeader:title message:message onViewController:self withButtonTapHandler:^{
                
            }];
        }
    }];
}

- (void)mergeFacebookProfile {
    //Merge social profile with existing Keychn account
    if(isNetworkReachable) {
        NSDictionary *userSocialProfileDictionary = [[KCUserProfile sharedInstance].facebookProfile getSocialUserProfileDictionary];
        __weak id weakSelf = self;
        [_signUpWebManager mergeSocialAccount:userSocialProfileDictionary withCompletionHandler:^(NSDictionary *response) {
            //save user profile with social profile in local database
            KCUserProfileDBManager *userProfileDBManager = [KCUserProfileDBManager new];
            [userProfileDBManager saveUserWithSocialProfile:response];
            [weakSelf pushHomeViewController];
            
        } failure:^(NSString *title, NSString *message) {
            //request failed, show error alert
            [KCUIAlert showInformationAlertWithHeader:title message:message onViewController:self withButtonTapHandler:^{
                
            }];
        }];
    }
    else {
        //Show alert for no internet connection
        [KCUIAlert showInformationAlertWithHeader:NSLocalizedString(@"networkError", nil) message:NSLocalizedString(@"tryReconnecting", nil) onViewController:self withButtonTapHandler:^{
            
        }];
    }
}


@end
