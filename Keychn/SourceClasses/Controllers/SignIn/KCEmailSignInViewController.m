//
//  KCEmailSignInViewController.m
//  Keychn
//
//  Created by Keychn Experience SL on 29/12/15.
//  Copyright © 2015 Keychn Experience SL. All rights reserved.
//

#import "KCEmailSignInViewController.h"
#import "KCLoginWebManager.h"
#import "KCUserProfileDBManager.h"
#import "KCEmailSignUpViewController.h"
#import "KCFacebookManager.h"
#import "KCSignUpWebManager.h"


@interface KCEmailSignInViewController () <UITextFieldDelegate> {
    BOOL                _shouldAdjustUI;
    KCUserProfile       *_userProfile;
    KCLoginWebManager   *_loginWebManager;
    KCFacebookManager       *_facebookManager;
    KCSignUpWebManager      *_signUpWebManager;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (assign, nonatomic) BOOL isProcessing;
@property (weak, nonatomic) IBOutlet UIButton *dontHaveAnAccountButton;


@end

@implementation KCEmailSignInViewController

#pragma mark - Life Cycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //register for keyboard notifications
    [self registerForKeyboardNotifications];
    
    // Get instances
    _userProfile     = [KCUserProfile new];
    _loginWebManager = [[KCLoginWebManager alloc] init];
    
    // Set attributed text
    NSMutableAttributedString *dontHaveAccountString = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"dontHaveAccount", nil) attributes:@{NSFontAttributeName: [UIFont setRobotoFontRegularStyleWithSize:15] , NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    NSAttributedString *signUpText = [[NSAttributedString alloc] initWithString:[@" " stringByAppendingString:NSLocalizedString(@"signUp", nil)]  attributes:@{NSFontAttributeName: [UIFont setRobotoFontRegularStyleWithSize:15], NSForegroundColorAttributeName: [UIColor darkGrayColor]}];
    [dontHaveAccountString appendAttributedString:signUpText];
    [self.dontHaveAnAccountButton setAttributedTitle:dontHaveAccountString forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //remove keyboard notification
    [self deregisterForKeyboardNotifications];
}



#pragma mark - Text Field Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField == self.emailTextField) {
        [self.passwordTextField becomeFirstResponder];
    }
    else {
        [textField resignFirstResponder];
    }
    
    return YES;
}

#pragma mark - Keyboard Notifications

- (void) registerForKeyboardNotifications {
    //register for Keyboard Notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didKeyboardAppear:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didKeyboardDisappear:)
                                                 name:UIKeyboardDidHideNotification object:nil];
}


- (void) deregisterForKeyboardNotifications {
    //Remove keyboard observers
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

- (void) didKeyboardAppear:(NSNotification*)notification {
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    NSInteger bottomSpace      = CGRectGetHeight(self.view.frame) - (CGRectGetMinY(self.containerView.frame) + CGRectGetHeight(self.containerView.frame));
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height-bottomSpace, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

- (void) didKeyboardDisappear:(NSNotification*)notification {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}


#pragma mark - Button Action

- (IBAction)backButtonTapped:(id)sender {
    [self.view endEditing:true];
    [self dismissViewControllerAnimated:true completion:^{
        
    }];
}


- (IBAction)forgotPasswordButtonTapped:(id)sender {
    [self.view endEditing:true];
}

- (IBAction)loginButtonTapped:(id)sender {
    if([self validateTextFields]) {
        if(isNetworkReachable) {
            [self loginWithUserDetails];
        }
        else {
            [KCUIAlert showInformationAlertWithHeader:NSLocalizedString(@"networkError", nil) message:NSLocalizedString(@"tryReconnecting", nil) onViewController:self withButtonTapHandler:^{
                
            }];
        }
    }
    [self.view endEditing:true];
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
        [KCUIAlert showInformationAlertWithHeader:NSLocalizedString(@"networkError", nil) message:NSLocalizedString(@"tryReconnecting", nil) onViewController:self withButtonTapHandler:^{
            
        }];
    }
}

- (IBAction)gotoSignUpButtonTapped:(id)sender {
    if(self.isPresentingAfterSignUp) {
        [self dismissViewControllerAnimated:true completion:^{
            
        }];
    }
    else {
        KCEmailSignUpViewController *signInViewController = [self.storyboard instantiateViewControllerWithIdentifier:emailSignUpViewController];
        signInViewController.isPresentingAfterSignIn = true;
        [self presentViewController:signInViewController animated:true completion:^{
            
        }];
    }
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
    // all text fields should be validated
    _userProfile.emailID  = [self.emailTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    _userProfile.password = self.passwordTextField.text;
    NSString *message;
    //validate user's email address
    message         = [NSString validateEmailAddress:_userProfile.emailID];
    if(message) {
        [self showValidationAlertWithMessage:message];
        return NO;
    }
    
    //validate password
    message         = [NSString validatePassword:_userProfile.password];
    if(message) {
        [self showValidationAlertWithMessage:message];
        return NO;
    }
    return YES;
}

- (void)showValidationAlertWithMessage:(NSString*)message {
    //show pop up on any validation error
    [KCUIAlert showInformationAlertWithHeader:nil message:message onViewController:self withButtonTapHandler:^{
        
    }];
}

#pragma mark - Request Completion

- (void)didSignInWithUserInfo:(NSDictionary *)userInfo {
    // User Signed In successfully. Save user response and go to Home Screen
    NSDictionary *userProfileResponse = [[userInfo objectForKey:kUserDetails] objectForKey:kAppUsers];
    KCUserProfile *userProfile = [KCUserProfile sharedInstance];
    [userProfile getModelFromDictionary:userProfileResponse withType:server];
    
    // Save current user in local database
    __weak KCEmailSignInViewController *weakSelf   = self;
    KCUserProfileDBManager *userProfileDBManager = [[KCUserProfileDBManager alloc] init];
    [userProfileDBManager saveCurrentUserWithCompletionHandler:^{
        [weakSelf pushHomeViewController];
    }];
}

#pragma mark - Server End Code

- (void)loginWithUserDetails {
    if(self.isProcessing) {
        return;
    }
    self.isProcessing = true;
    //login user with filled details
    NSDictionary *params = [_userProfile getUserProfileDictionary];
    __weak KCEmailSignInViewController *weakSelf   = self;
    [self.activityIndicator startAnimating];
    [_loginWebManager signInUserWithDetails:params withCompletionHandler:^(NSDictionary *response) {
        //Sign in successfully
        weakSelf.isProcessing = false;
        [weakSelf didSignInWithUserInfo:response];
        [weakSelf.activityIndicator stopAnimating];
    } failure:^(NSString *title, NSString *message) {
        //requet failed with error
        weakSelf.isProcessing = false;
        [weakSelf.activityIndicator stopAnimating];
        [KCUIAlert showInformationAlertWithHeader:title message:message onViewController:self withButtonTapHandler:^{
            
        }];
    }];
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
            [KCUIAlert showAlertWithButtonTitle:NSLocalizedString(@"merge", nil) alertHeader:title message:message onViewController:self withButtonTapHandler:^(BOOL positiveButton) {
                if(positiveButton) {
                    [self mergeFacebookProfile];
                }
            }];
        }
        else {
            //Request failed, show error alert
            [KCUIAlert showInformationAlertWithHeader:NSLocalizedString(@"networkError", nil) message:NSLocalizedString(@"tryReconnecting", nil) onViewController:self withButtonTapHandler:^{
                
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
