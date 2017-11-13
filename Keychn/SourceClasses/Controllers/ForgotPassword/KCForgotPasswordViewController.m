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
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewTopConstraint;
@property (weak, nonatomic) IBOutlet UIView *passwordResetConfirmationView;
@property (weak, nonatomic) IBOutlet UILabel *passwordResetLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordSentToEmailLabel;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIView *lineSeparatorView;

@end

@implementation KCForgotPasswordViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customizeUI]; //customize app UI
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if([KCUtility getiOSDeviceType] == iPhone4) {
        [self registerForKeyboardNotifications]; //register Keyboard Notification
    }
    
    //set texts on views
    [self setText];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if([KCUtility getiOSDeviceType] == iPhone4) {
        [self deregisterForKeyboardNotifications]; //deregister for keyborad notifications
    }
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


- (void) deregisterForKeyboardNotifications {
    //Remove keyboard observers
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

- (void) didKeyboardAppear:(NSNotification*)notification {
    if([KCUtility getiOSDeviceType] == iPhone4) {
        _keyboardDisplacementConstant = 40;
        [self.view layoutIfNeeded];
        self.containerViewTopConstraint.constant -= _keyboardDisplacementConstant;
        [UIView animateWithDuration:0.5
                         animations:^{
                             [self.view layoutIfNeeded]; // Called on parent view
                         }];
    }
    
}

- (void) didKeyboardDisappear:(NSNotification*)notification {
    if([KCUtility getiOSDeviceType] == iPhone4) {
        [self.view layoutIfNeeded];
        self.containerViewTopConstraint.constant += _keyboardDisplacementConstant;
        [UIView animateWithDuration:0.5
                         animations:^{
                             [self.view layoutIfNeeded]; // Called on parent view
                         }];
    }
}

#pragma mark - Button Action

- (IBAction)resetButtonTapped:(UIButton*)sender {
    if(sender.isSelected) {
        //pop view controller
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        //request reset password
        if([self validateTextFields]) {
            if(isNetworkReachable) {
                [self requestResetPassword];
            }
            else {
                //internet connection nov availanle
                [KCUIAlert showInformationAlertWithHeader:AppLabel.errorTitle message:AppLabel.internetNotAvailable withButtonTapHandler:^{
                    
                }];
            }
        }
    }
    [self.emailTextField resignFirstResponder];
}

- (IBAction)backButtonTapped:(id)sender {
    [self.emailTextField resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Instance Methods

- (void) customizeUI {
    //customize app UI
    self.headerLabel.font  = [UIFont setRobotoFontRegularStyleWithSize:17];
    [self.emailTextField setValue:[UIColor placeholderColorEmailSignUp]
                       forKeyPath:@"_placeholderLabel.textColor"];
    self.emailTextField.font = [UIFont setRobotoFontRegularStyleWithSize:14];
    self.resetButton.titleLabel.font = [UIFont setRobotoFontBoldStyleWithSize:14];
    
    self.passwordResetLabel.font            = [UIFont setRobotoFontRegularStyleWithSize:12];
    self.passwordSentToEmailLabel.font      = [UIFont setRobotoFontRegularStyleWithSize:12];
    self.passwordResetLabel.textColor       = [UIColor blackColorwithLightOpacity];
    self.passwordSentToEmailLabel.textColor = [UIColor blackColorwithLightOpacity];
    self.lineSeparatorView.backgroundColor  = [UIColor separatorLineColor];
    
    //add a background layer
    CALayer *border = [CALayer layer];
    CGFloat borderWidth = 1;
    border.borderColor = [UIColor textFieldSeparatorColorEmailSignUp].CGColor;
    border.frame = CGRectMake(0, 29, 238, 30);
    border.borderWidth = borderWidth;
    [self.emailTextField.layer addSublayer:border];
    self.emailTextField.layer.masksToBounds = YES;
}

- (void) setText {
    //set text on buttons and labels and placeholders on text field
    self.headerLabel.text                   = AppLabel.lblForgotPassword;
    self.emailTextField.placeholder         = AppLabel.placeholderEmail;
    self.passwordResetLabel.text            = AppLabel.lblPasswordReset;
    self.passwordSentToEmailLabel.text      = AppLabel.lblPasswordSentToEmail;
    [self.resetButton setTitle:AppLabel.btnReset forState:UIControlStateNormal];
    [self.resetButton setTitle:[AppLabel.btnOk uppercaseString] forState:UIControlStateSelected];
}

- (BOOL) validateTextFields {
    //all text fields should be validated
    NSString *message;
    //validate user's email address
    message         = [NSString validateEmailAddress:self.emailTextField.text];
    if(message) {
        [KCUIAlert showInformationAlertWithHeader:AppLabel.errorTitle message:message withButtonTapHandler:^{
            
        }];
        return NO;
    }
    return YES;
}

- (void) showPasswordResetViewWithAnimation {
    //show password reset confirmation with animation
    self.emailTextField.hidden                = YES;
    self.passwordResetConfirmationView.alpha  = 0;
    self.passwordResetConfirmationView.hidden = NO;
    [self.resetButton setTitle:[AppLabel.btnOk uppercaseString] forState:UIControlStateNormal];
    self.backButton.hidden                    = YES;
    self.resetButton.selected   = YES; //change button state to change behavior
    [UIView transitionWithView:self.passwordResetConfirmationView duration:1.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.passwordResetConfirmationView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - Server End Code

- (void) requestResetPassword {
    //request a new password for the entered email id
    if(!_forgotPasswordWebManager) {
        _forgotPasswordWebManager = [KCForgotPasswordWebManager new];
    }
    NSDictionary *params = @{kEmailID: self.emailTextField.text};
    [_forgotPasswordWebManager requestNewPasswordWithDetails:params withCompletionHandler:^(NSDictionary *userProfile) {
        [self performSelector:@selector(showPasswordResetViewWithAnimation) withObject:nil afterDelay:0.5f];
    } failure:^(NSString *title, NSString *message) {
       [KCUIAlert showInformationAlertWithHeader:title message:message withButtonTapHandler:^{
           
       }];
    }];
}


@end
