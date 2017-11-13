//
//  KCSignUpViewController.m
//  Keychn
//
//  Created by Keychn Experience SL on 09/12/15.
//  Copyright © 2015 Keychn Experience SL. All rights reserved.
//

#import "KCSignUpViewController.h"
#import "KCFacebookManager.h"
#import "KCTwitterManager.h"
#import "KCSignUpWebManager.h"
#import "KCUserProfileDBManager.h"
#import "KCLanguageSelectionViewController.h"
#import "KCAppLanguageWebManager.h"

@interface KCSignUpViewController () {
    KCFacebookManager       *_facebookManager;
    KCTwitterManager        *_twitterManager;
    KCSignUpWebManager      *_signUpWebManager;
    KCUserProfile           *_userProfile;
    KCAppLanguageWebManager *_appLanguageWebManager;
}
@property (weak, nonatomic) IBOutlet UIButton *loginWithEmailButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpWithEmailButton;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UILabel *socialSignUpRecommendedLabel;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *alreadySignedUpLabel;

@end

#pragma mark - Life Cycle Methods

@implementation KCSignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Set text, image, fonts, font colors etc.
    [self customizeUI];
    _userProfile = [KCUserProfile sharedInstance];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Present infographic images
    [self presentInfographicsImages];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //Set text on labels and buttons
    [self setTextOnViews];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    //Adjust UI for iPhone 4
    if([KCUtility getiOSDeviceType] == iPhone4) {
        CGRect containerFrame = self.containerView.frame;
        containerFrame.origin.y += 45;
        self.containerView.frame = containerFrame;
    }
}

#pragma mark - Customize UI

- (void) customizeUI {
    //Set text, image, font, font color etc
    self.view.backgroundColor = [UIColor appBackgroundColor];
    self.signUpWithEmailButton.titleLabel.font      = [UIFont setRobotoFontBoldStyleWithSize:12];
    self.loginWithEmailButton.titleLabel.font       = [UIFont setRobotoFontBoldStyleWithSize:12];
    [self.signUpWithEmailButton setBackgroundColor:[UIColor emailSignUpButtonBackgroundColor]];
    [self.signUpWithEmailButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.socialSignUpRecommendedLabel.font          = [UIFont setRobotoFontRegularStyleWithSize:11];
    self.alreadySignedUpLabel.font                  = [UIFont setRobotoFontItalicStyleWithSize:13];
    self.facebookButton.titleLabel.font = [UIFont setRobotoFontBoldStyleWithSize:12];
    self.facebookButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.facebookButton.titleLabel.lineBreakMode    = NSLineBreakByClipping;
    self.loginWithEmailButton.backgroundColor       = [UIColor signInWithEmailButtonColor];
}

- (void) setTextOnViews {
    //Sets text on all labels and buttons
    KCAppLabel *appLabel = [KCAppLabel sharedInstance];
    self.socialSignUpRecommendedLabel.text  = appLabel.lblWeHighlyRecommend;
    self.alreadySignedUpLabel.text          = AppLabel.lblAlreadySignedUp;
    [self.facebookButton setTitle:appLabel.btnConnectWithFacebook forState:UIControlStateNormal];
    [self.signUpWithEmailButton setTitle:appLabel.btnSignUpWithEmail forState:UIControlStateNormal];
    [self.loginWithEmailButton setTitle:appLabel.btnLoginNow forState:UIControlStateNormal];
}

#pragma mark - IBActions Methods

- (IBAction)fbLoginButtonTapped:(id)sender {
    //Facebook Login, get user facebook profile
    if(isNetworkReachable) {
        Mixpanel *mixpanel = [Mixpanel sharedInstance];
        [mixpanel track:@"login_facebook_button"
             properties:@{@"":@""}];
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
        _facebookManager = [[KCFacebookManager alloc] init];
        if(DEBUGGING) NSLog(@"fbLoginButtonTapped --> User language ID %@",_userProfile.languageID);
        [_facebookManager connectToFacebookWithViewController:self completionHandler:^(BOOL flag) {
            //Facebook data fetched, login with facebook
            if(flag) {
                [self loginWithFacebook];
            }
            else {
                //Show alert for facebook login failed
                [KCUIAlert showInformationAlertWithHeader:AppLabel.errorTitle message:AppLabel.loginWithFacebookFailed withButtonTapHandler:^{
                    
                }];
            }
        }];
    }
    else {
        //Show alert for no internet connection
        [KCUIAlert showInformationAlertWithHeader:AppLabel.errorTitle message:AppLabel.internetNotAvailable withButtonTapHandler:^{
            
        }];
    }
}

- (IBAction)twitterLoginButtonTapped:(id)sender {
    //Twitter Login, get User Twitter Profile
     _twitterManager = [[KCTwitterManager alloc] init];
    [_twitterManager loginTwiiterAccountWithCompletionHandler:^(BOOL granted) {
        
    }];
}

- (IBAction)signUpWithEmailButtonTapped:(id)sender {
    //Open Email Sign Up Screen
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"login_signup_button"
         properties:@{@"":@""}];
    UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:emailSignUpViewController];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)emailSignInButtonTapped:(id)sender {
    //Open Email Sign In Screen
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"login_email_button"
         properties:@{@"":@""}];
    UIViewController *emailSignInViewController = [self.storyboard instantiateViewControllerWithIdentifier:emailLoginViewController];
    [self.navigationController pushViewController:emailSignInViewController animated:YES];
}

#pragma mark - Instance Methods

- (void) pushNextViewController {
    if([NSString validateString:_userProfile.languageID] && [_userProfile.languageID integerValue] > 0) {
        //Push main menu view controller
        UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:menuSegmentsViewController];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else {
      //Push the language selection view controller
        KCLanguageSelectionViewController *languageOptionViewController = [self.storyboard instantiateViewControllerWithIdentifier:selectLangugeViewController];
        languageOptionViewController.shouldHideBackButton = YES;
        [self.navigationController pushViewController:languageOptionViewController animated:YES];
    }
}

#pragma mark - Infographics Images

- (void)presentInfographicsImages {
    // Present Infographics images
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL isPresented             = [[userDefaults objectForKey:kIsPresented] boolValue];
    
    if(!isPresented) {
        // Show infographics image
        [userDefaults setValue:[NSNumber numberWithBool:YES] forKey:kIsPresented];
        UIViewController *paperOnboardViewController = [self.storyboard instantiateViewControllerWithIdentifier:kOnBoardViewController];
        [self presentViewController:paperOnboardViewController animated:YES completion:^{
            
        }];
    }
}

#pragma mark - Server End Code

- (void) loginWithFacebook {
    //Login with facebook with completion handler
    if(!_signUpWebManager) {
        _signUpWebManager = [KCSignUpWebManager new];
    }
    __weak id weakSelf = self;
    NSDictionary *userSocialProfileDictionary = [_userProfile.facebookProfile getSocialUserProfileDictionary];
    if(DEBUGGING) NSLog(@"loginWithFacebook --> User language ID %@",_userProfile.languageID);
    [_signUpWebManager signUpWithSocialAccount:userSocialProfileDictionary withCompletionHandler:^(NSDictionary *response) {
        //Save user profile with social profile in local database
        if(DEBUGGING) NSLog(@"loginWithFacebook --> Completion Handler --> User language ID %@",_userProfile.languageID);
        KCUserProfileDBManager *userProfileDBManager = [KCUserProfileDBManager new];
        [userProfileDBManager saveUserWithSocialProfile:response];
        
        //Fetch app labels
        if([NSString validateString:_userProfile.languageID] && [_userProfile.languageID integerValue] > 0) {
           [weakSelf fetchAppLanguageLabel];
        }
        else {
            [weakSelf pushNextViewController];
        }
        
    } failure:^(NSString *title, NSString *message, BOOL shouldMerge) {
        if(shouldMerge) {
            //Social merge options
            [KCUIAlert showAlertWithButtonTitle:AppLabel.btnMerge alertHeader:title message:message withButtonTapHandler:^(BOOL positiveButton) {
                if(positiveButton) {
                    [self mergeFacebookProfile];
                }
            }];
        }
        else {
            //Request failed, show error alert
            [KCUIAlert showInformationAlertWithHeader:title message:message withButtonTapHandler:^{
                
            }];
        }
        
    }];
}

- (void) mergeFacebookProfile {
    //Merge social profile with existing Keychn account
    if(isNetworkReachable) {
        NSDictionary *userSocialProfileDictionary = [_userProfile.facebookProfile getSocialUserProfileDictionary];
        [_signUpWebManager mergeSocialAccount:userSocialProfileDictionary withCompletionHandler:^(NSDictionary *response) {
            //save user profile with social profile in local database
            KCUserProfileDBManager *userProfileDBManager = [KCUserProfileDBManager new];
            [userProfileDBManager saveUserWithSocialProfile:response];
            
            //fetch app language label
            [self fetchAppLanguageLabel];
            
        } failure:^(NSString *title, NSString *message) {
            //request failed, show error alert
            [KCUIAlert showInformationAlertWithHeader:title message:message withButtonTapHandler:^{
                
            }];
        }];
    }
    else {
        //Show alert for no internet connection
        [KCUIAlert showInformationAlertWithHeader:AppLabel.errorTitle message:AppLabel.internetNotAvailable withButtonTapHandler:^{
            
        }];
    }
}

- (void) fetchAppLanguageLabel {
    //Fetch app labels from server
    if(!_appLanguageWebManager) {
        _appLanguageWebManager = [KCAppLanguageWebManager new];
    }
    KCUserProfile *userProfile = [KCUserProfile sharedInstance];
    [_appLanguageWebManager getAppLabelsForLanguage:userProfile.languageID withCompletionHandler:^(KCSupportedLanguage *supportedLanguage) {
        //language labels saved, go to the next screen
        [self pushNextViewController];
    } andFailureBlock:^(NSString *title, NSString *message) {
        [KCUIAlert showInformationAlertWithHeader:title message:message withButtonTapHandler:^{
            
        }];
    }];
}

@end
