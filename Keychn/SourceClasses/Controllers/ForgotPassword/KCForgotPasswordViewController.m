//
//  KCForgotPasswordViewController.m
//  Keychn
//
//  Created by Keychn Experience SL on 29/12/15.
//  Copyright © 2015 Keychn Experience SL. All rights reserved.
//

#import "KCForgotPasswordViewController.h"
#import "KCForgotPasswordWebManager.h"

@interface KCForgotPasswordViewController () <UITextFieldDelegate> {
    NSInteger _keyboardDisplacementConstant;
    KCForgotPasswordWebManager *_forgotPasswordWebManager;
}

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewBottomConstraint;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (assign, nonatomic) BOOL isProcessing;

@end

@implementation KCForgotPasswordViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Get instances
    _forgotPasswordWebManager = [KCForgotPasswordWebManager new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self registerForKeyboardNotifications]; //register Keyboard Notification
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self deregisterForKeyboardNotifications]; //deregister for keyborad notifications
}

#pragma mark - Auto rotation

- (BOOL)shouldAutorotate {
    return  false;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return  UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return  UIInterfaceOrientationPortrait;
}

#pragma mark - Text Field Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
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


- (void)deregisterForKeyboardNotifications {
    //Remove keyboard observers
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

- (void)didKeyboardAppear:(NSNotification*)notification {
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    NSInteger bottomSpace      = CGRectGetHeight(self.view.frame) - (CGRectGetMinY(self.containerView.frame) + CGRectGetHeight(self.containerView.frame));
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height-bottomSpace, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

- (void)didKeyboardDisappear:(NSNotification*)notification {
    self.scrollView.contentInset          = UIEdgeInsetsZero;
    self.scrollView.scrollIndicatorInsets = UIEdgeInsetsZero;
}

#pragma mark - Button Action

- (IBAction)resetButtonTapped:(UIButton*)sender {
    //request reset password
    if([self validateTextFields]) {
        if(isNetworkReachable) {
            [self requestResetPassword];
        }
        else {
            //internet connection not availanle
            [KCUIAlert showInformationAlertWithHeader:NSLocalizedString(@"networkError", nil) message:NSLocalizedString(@"tryReconnecting", nil) onViewController:self withButtonTapHandler:^{
                
            }];
        }
    }
    [self.emailTextField resignFirstResponder];
}

- (IBAction)backButtonTapped:(id)sender {
    [self.emailTextField resignFirstResponder];
    [self dismissViewControllerAnimated:true completion:^{
        
    }];
}

#pragma mark - Instance Methods

- (BOOL)validateTextFields {
    //all text fields should be validated
    NSString *message;
    //validate user's email address
    message         = [NSString validateEmailAddress:self.emailTextField.text];
    if(message) {
        [KCUIAlert showInformationAlertWithHeader:nil message:message onViewController:self withButtonTapHandler:^{
            
        }];
        return NO;
    }
    return YES;
}

#pragma mark - Request Completion

- (void)didResetPasswordSuccessfully {
    // Show alert to the user
    __weak KCForgotPasswordViewController *weakSelf = self;
    [KCUIAlert showInformationAlertWithHeader:@"Password Reset" message:@"Please check your inbox for a temporary password. We recommend to change it at your earliest." onViewController:self withButtonTapHandler:^{
        [weakSelf dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
}


#pragma mark - Server End Code

- (void) requestResetPassword {
    //request a new password for the entered email id
    if(self.isProcessing) {
        return;
        
    }
    self.isProcessing = true;
    __weak KCForgotPasswordViewController *weakSelf = self;
    NSDictionary *params = @{kEmailID: self.emailTextField.text};
    [self.activityIndicator startAnimating];
    [_forgotPasswordWebManager requestNewPasswordWithDetails:params withCompletionHandler:^(NSDictionary *userProfile) {
        // Password reset successfully
        [weakSelf didResetPasswordSuccessfully];
        [weakSelf.activityIndicator stopAnimating];
        weakSelf.isProcessing = false;
    } failure:^(NSString *title, NSString *message) {
        [weakSelf.activityIndicator stopAnimating];
        weakSelf.isProcessing = false;
       [KCUIAlert showInformationAlertWithHeader:title message:message onViewController:weakSelf withButtonTapHandler:^{
           
       }];
    }];
}


@end
