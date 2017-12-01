//
//  KCEmailSignUpViewController.m
//  Keychn
//
//  Created by Keychn Experience SL on 28/12/15.
//  Copyright © 2015 Keychn Experience SL. All rights reserved.
//

#import "KCEmailSignUpViewController.h"
#import "KCEmailSignUpTableViewCell.h"
#import "KCEmailSignUpButtonTableViewCell.h"
#import "KCEmailSignUpNewsletterTableViewCell.h"
#import "KCUserProfileDBManager.h"
#import "KCEmailSignInViewController.h"
#import "TOMSMorphingLabel.h"
#import "KCFacebookManager.h"
#import "KCSignUpWebManager.h"


@interface KCEmailSignUpViewController () <UITextFieldDelegate> {
    KCUserProfile           *_userProfile;
    KCSignUpWebManager      *_signUpManager;
    KCFacebookManager       *_facebookManager;
    KCSignUpWebManager      *_signUpWebManager;
}

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (assign, nonatomic) BOOL isProcessing;
@property (weak, nonatomic) IBOutlet TOMSMorphingLabel *starcookLabel;

@end

@implementation KCEmailSignUpViewController

#pragma mark - Life Cycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Allocate instances
    _userProfile    = [KCUserProfile new];
    _signUpManager  = [KCSignUpWebManager new];
    
    // Default value
    _userProfile.receiveNewsletter = [NSNumber numberWithBool:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //register for keybord notifications
    [self registerForKeyboardNotifications];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self deregisterForKeyboardNotifications];
}

#pragma mark - Text Field Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField == self.nameTextField) {
        [self.emailTextField becomeFirstResponder];
    }
    else if(textField == self.emailTextField) {
        [self.passwordTextField becomeFirstResponder];
    }
    else {
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.nameTextField) {
        [self.starcookLabel setText:[@"Hello " stringByAppendingString:self.nameTextField.text] withCompletionBlock:^{
            
        }];
    }
}

#pragma mark - Button Actions

- (IBAction)backButtonTapped:(id)sender {
    [self.view endEditing:true];
    [self dismissViewControllerAnimated:true completion:^{
        
    }];
}

- (IBAction)termsOfUseButtonTapped:(id)sender {
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"signup_terms_link"
         properties:@{@"":@""}];
    KCAppWebViewViewController *webViewController = [self.storyboard instantiateViewControllerWithIdentifier:appWebViewController];
    // Assign Web URL
    webViewController.urlToOpen = termsOfUsePolicy;
    [self.navigationController pushViewController:webViewController animated:YES];
}

- (IBAction)privacyPolicyButtonTapped:(id)sender {
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"signup_privacy_link"
         properties:@{@"":@""}];
    KCAppWebViewViewController *webViewController = [self.storyboard instantiateViewControllerWithIdentifier:appWebViewController];
    //assign Web URL
    webViewController.urlToOpen = privacyPolicyURL;
    [self.navigationController pushViewController:webViewController animated:YES];
}


- (IBAction)signUpButtonTapped:(id)sender {
    if(self.isProcessing) {
        return;
    }
    [self.view endEditing:true];
    if([self validateTextFields]) {
        self.isProcessing = true;
        if(isNetworkReachable) {
            [self.activityIndicator startAnimating];
            Mixpanel *mixpanel = [Mixpanel sharedInstance];
            [mixpanel track:@"signup_button"
                 properties:@{@"":@""}];
            // Text field validated, try to register user
            __weak KCEmailSignUpViewController *weakSelf = self;
            NSDictionary *userProfileDictionary = [_userProfile getUserProfileDictionary];
            [_signUpManager signUpUserWithDetails:userProfileDictionary withCompletionHandler:^(NSDictionary *userProfile) {
                // Get user model from response
                [weakSelf.activityIndicator stopAnimating];
                weakSelf.isProcessing = false;
                KCUserProfile *userProfileModel = [KCUserProfile sharedInstance];
                [userProfileModel getModelFromDictionary:userProfile withType:server];
                
                // Save current user in local database
                KCUserProfileDBManager *userProfileDBManager = [[KCUserProfileDBManager alloc] init];
                [userProfileDBManager saveCurrentUserWithCompletionHandler:^{
                    
                }];
                
                // Go to Home Screen
                [weakSelf pushHomeViewController];
                
            } failure:^(NSString *title, NSString *message) {
                weakSelf.isProcessing = false;
                [weakSelf.activityIndicator stopAnimating];
                [KCUIAlert showInformationAlertWithHeader:title message:message onViewController:weakSelf withButtonTapHandler:^{
                    
                }];
            }];
        }
        else {
            // Show alert for no internet connection
            [KCUIAlert showInformationAlertWithHeader:AppLabel.errorTitle message:AppLabel.internetNotAvailable onViewController:self withButtonTapHandler:^{
                
            }];
        }
    }
}

- (IBAction)gotoSignInButtonTapped:(id)sender {
    // Go to Sign In Screen
    if(self.isPresentingAfterSignIn) {
        [self dismissViewControllerAnimated:true completion:^{
            
        }];
    }
    else {
        KCEmailSignInViewController *signInViewController = [self.storyboard instantiateViewControllerWithIdentifier:emailLoginViewController];
        signInViewController.isPresentingAfterSignUp = true;
        [self presentViewController:signInViewController animated:true completion:^{
            
        }];
    }
}

- (IBAction)loginWithFacebookButtonTapped:(id)sender {
    //Facebook Login, get user facebook profile
    [self.view endEditing:true];
    if(isNetworkReachable) {
        Mixpanel *mixpanel = [Mixpanel sharedInstance];
        [mixpanel track:@"login_facebook_button"
             properties:@{@"":@""}];
        _facebookManager = [[KCFacebookManager alloc] init];
        if(DEBUGGING) NSLog(@"fbLoginButtonTapped --> User language ID %@",_userProfile.languageID);
        [_facebookManager connectToFacebookWithViewController:self completionHandler:^(BOOL flag) {
            //Facebook data fetched, login with facebook
            if(flag) {
                [self loginWithFacebook];
            }
        }];
    }
    else {
        //Show alert for no internet connection
        [KCUIAlert showInformationAlertWithHeader:AppLabel.errorTitle message:AppLabel.internetNotAvailable onViewController:self withButtonTapHandler:^{
            
        }];
    }
}

#pragma mark - Keyboard Notifications

- (void)registerForKeyboardNotifications {
    //register for Keyboard Notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didKeyboardAppear:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didKeyboardDisappear:)
                                                 name:UIKeyboardDidHideNotification object:nil];
}


- (void)deregisterForKeyboardNotifications {
    //Remove keyboard observers
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

- (void)didKeyboardAppear:(NSNotification*)notification {
    // Keyboard appearance
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSInteger bottomSpace   = CGRectGetHeight(self.view.frame) - (CGRectGetMinY(self.containerView.frame) + CGRectGetHeight(self.containerView.frame));
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height-bottomSpace, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

- (void)didKeyboardDisappear:(NSNotification*)notification {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

#pragma mark - Instance Method

- (void)pushHomeViewController {
    [self dismissViewControllerAnimated:true completion:^{
        UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:kHomeViewController];
        AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
        UINavigationController *rootViewController = (UINavigationController *) appDelegate.window.rootViewController;
        [rootViewController pushViewController:viewController animated:YES];
    }];
}

- (BOOL)validateTextFields {
    // All text fields should be validated
    _userProfile.emailID  = [self.emailTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    _userProfile.username = [self.nameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    _userProfile.password = self.passwordTextField.text;
    
    // Validate user's name
    NSString *message = [NSString validateName:_userProfile.username];
    if(message) {
        [self showValidationAlertWithMessage:message];
        return NO;
    }
    
    // Validate user's email address
    message         = [NSString validateEmailAddress:_userProfile.emailID];
    if(message) {
        [self showValidationAlertWithMessage:message];
        return NO;
    }
    
    // Validate password
    message         = [NSString validatePassword:_userProfile.password];
    if(message) {
        [self showValidationAlertWithMessage:message];
        return NO;
    }
    
    return YES;
}

- (void)showValidationAlertWithMessage:(NSString*)message {
    // Show pop up on any validation error
    [KCUIAlert showInformationAlertWithHeader:AppLabel.errorTitle message:message onViewController:self withButtonTapHandler:^{
        
    }];
}

#pragma mark - Navigation

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    return NO;
}

#pragma mark - Server End Code

- (void)loginWithFacebook {
    //Login with facebook with completion handler
    if(!_signUpWebManager) {
        _signUpWebManager = [KCSignUpWebManager new];
    }
    __weak id weakSelf = self;
    NSDictionary *userSocialProfileDictionary = [[KCUserProfile sharedInstance].facebookProfile getSocialUserProfileDictionary];
    if(DEBUGGING) NSLog(@"loginWithFacebook --> User language ID %@",_userProfile.languageID);
    [_signUpWebManager signUpWithSocialAccount:userSocialProfileDictionary withCompletionHandler:^(NSDictionary *response) {
        //Save user profile with social profile in local database
        if(DEBUGGING) NSLog(@"loginWithFacebook --> Completion Handler --> User language ID %@",_userProfile.languageID);
        KCUserProfileDBManager *userProfileDBManager = [KCUserProfileDBManager new];
        [userProfileDBManager saveUserWithSocialProfile:response];
        [weakSelf pushHomeViewController];
        
    } failure:^(NSString *title, NSString *message, BOOL shouldMerge) {
        if(shouldMerge) {
            //Social merge options
            [KCUIAlert showAlertWithButtonTitle:AppLabel.btnMerge alertHeader:title message:message onViewController:self withButtonTapHandler:^(BOOL positiveButton) {
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
        [KCUIAlert showInformationAlertWithHeader:AppLabel.errorTitle message:AppLabel.internetNotAvailable onViewController:self withButtonTapHandler:^{
            
        }];
    }
}


@end
