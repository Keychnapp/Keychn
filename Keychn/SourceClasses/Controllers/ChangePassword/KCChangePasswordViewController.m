//
//  KCChangePasswordViewController.m
//  Keychn
//
//  Created by Keychn Experience SL on 14/03/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import "KCChangePasswordViewController.h"
#import "KCChangePasswordTableViewCell.h"
#import "KCUpdatePassword.h"
#import "KCUserProfileUpdateManager.h"


typedef NS_ENUM(NSUInteger, ChangePassword) {
    oldPassword,
    newPassword,
    confirmPassword
};

@interface KCChangePasswordViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate> {
    KCUpdatePassword            *_updatePassword;
    KCUserProfileUpdateManager  *_updateProfileManager;
    KCUserProfile               *_userProfile;
    NSInteger                   _rowHeight;
}

@property (weak, nonatomic) IBOutlet UITableView    *changePasswordTableView;
@property (weak, nonatomic) IBOutlet UILabel        *changePasswordLabel;
@property (weak, nonatomic) IBOutlet UIButton       *changePasswordButton;
@property (strong,nonatomic) UITextField            *editingTextField;
@property (weak, nonatomic) IBOutlet UIView *seperatorView;


@end

@implementation KCChangePasswordViewController

#pragma mark - Life Cycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Get Instances
    _updatePassword         = [KCUpdatePassword new];
    _updateProfileManager   = [KCUserProfileUpdateManager new];
    _userProfile            = [KCUserProfile sharedInstance];
    
    // Determine row height of table cell
    IOSDevices iOSDeviceType = [KCUtility getiOSDeviceType];
    switch (iOSDeviceType) {
        case iPhone4:
            _rowHeight = 103;
            break;
        case iPhone5:
            _rowHeight = 125;
            break;
        case iPhone6:
            _rowHeight =  148;
            break;
        case iPhone6Plus:
            _rowHeight = 165;
        default:
            _rowHeight = 235;
            break;
    }
    
    // Customize app UI
    [self customizeUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Set text on views
    [self setText];
    
    // Register for keyboard notifications
    [self registerForKeyboardNotifications];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // Remove keyboard notifications
    [self deregisterForKeyboardNotifications];
}

#pragma mark - TableView Datasource and Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KCChangePasswordTableViewCell *changePasswordCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierForChangePassword forIndexPath:indexPath];
    
    //Add a background layer for underline
    CALayer *border = [CALayer layer];
    CGFloat borderWidth = 1.0f;
    border.borderColor = [UIColor textFieldSeparatorColorEmailSignUp].CGColor;
    border.frame = CGRectMake(0, 29, 238, 30);
    border.borderWidth = borderWidth;
    [changePasswordCell.passwordTextField.layer addSublayer:border];
    changePasswordCell.passwordTextField.tag = indexPath.row;
    changePasswordCell.passwordTextField.adjustsFontSizeToFitWidth = YES;
    [changePasswordCell.passwordTextField setValue:[UIColor placeholderColorEmailSignUp]
                                                forKeyPath:@"_placeholderLabel.textColor"];
    switch (indexPath.row) {
        case oldPassword:
            changePasswordCell.passwordTextField.placeholder = [AppLabel.placeHolderOldPassword uppercaseString];
            changePasswordCell.passwordTextField.text        = _updatePassword.oldPassword;
            break;
        case newPassword:
            changePasswordCell.passwordTextField.placeholder = [AppLabel.placeHolderNewPassword uppercaseString];
            changePasswordCell.passwordTextField.text        = _updatePassword.newlyPassword;
            break;
        case confirmPassword:
            changePasswordCell.passwordTextField.placeholder = [AppLabel.placeHolderConfirmNewPassword uppercaseString];
            // Set keyboard return key to "Done" for last text field
            changePasswordCell.passwordTextField.returnKeyType = UIReturnKeyDone;
            changePasswordCell.passwordTextField.text        = _updatePassword.confirmNewPassword;
            break;
    }
    return changePasswordCell;
}

#pragma mark - Text Field Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.editingTextField = textField;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField.tag == confirmPassword) {
        // Resign first responder
        [textField resignFirstResponder];
    }
    else {
        // Change first responder to the next field
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:textField.tag+1 inSection:0];
        KCChangePasswordTableViewCell *changePasswordCell = [self.changePasswordTableView cellForRowAtIndexPath:indexPath];
        [changePasswordCell.passwordTextField becomeFirstResponder];
    }
    return YES;
}

- (IBAction)textFieldEditingChanged:(UITextField *)sender {
    switch (sender.tag) {
        case oldPassword:
            _updatePassword.oldPassword = sender.text;
            break;
        case newPassword:
            _updatePassword.newlyPassword = sender.text;
            break;
        case confirmPassword:
            _updatePassword.confirmNewPassword = sender.text;
            break;
    }
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
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(-45, 0.0, kbSize.height, 0.0);
    self.changePasswordTableView.contentInset = contentInsets;
}

- (void) didKeyboardDisappear:(NSNotification*)notification {
    self.changePasswordTableView.contentInset   = UIEdgeInsetsMake(-45, 0, 0, 0);
}

#pragma mark - Button Actions

- (IBAction)backButtonTapped:(id)sender {
    [self.editingTextField resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)changePasswordButtonTapped:(id)sender {
    [self.editingTextField resignFirstResponder];
    
    // Validate text fields
    BOOL status =  [self validateTextFields];
    if(status) {
       // Text field validated, update new password on server
        [self updatePassword];
    }
}

#pragma mark - Instance Methods

- (void)customizeUI {
    // Customize app UI for font and color
    self.changePasswordLabel.font               = [UIFont setRobotoFontRegularStyleWithSize:17];
    self.changePasswordButton.titleLabel.font   = [UIFont setRobotoFontBoldStyleWithSize:15];
    self.changePasswordButton.backgroundColor   = [UIColor appBackgroundColor];
    self.changePasswordTableView.contentInset   = UIEdgeInsetsMake(-45, 0, 0, 0);
    self.seperatorView.backgroundColor          = [UIColor separatorLineColor];
}

- (void)setText {
    // Set text on buttons and labels
    self.changePasswordLabel.text       = AppLabel.lblChagePassword;
    [self.changePasswordButton setTitle:[AppLabel.lblChagePassword uppercaseString] forState:UIControlStateNormal];
}

- (BOOL) validateTextFields {
    //all text fields should be validated
    NSString *message;
    //validate user's email address
    message         = [NSString validatePassword:_updatePassword.oldPassword];
    if(message) {
        [self showValidationAlertWithMessage:message];
        return NO;
    }
    
    //validate password
    message         = [NSString validatePassword:_updatePassword.newlyPassword];
    if(message) {
        [self showValidationAlertWithMessage:message];
        return NO;
    }
    
    //validate password
    message         = [NSString validateConfirmPassword:_updatePassword.confirmNewPassword];
    if(message) {
        [self showValidationAlertWithMessage:message];
        return NO;
    }
    
    // Match both password
    message         = [NSString matchPasswords:_updatePassword.newlyPassword andConfirmPassword:_updatePassword.confirmNewPassword];
    if(message) {
        [self showValidationAlertWithMessage:message];
        return NO;
    }
    
    return YES;
}

- (void) showValidationAlertWithMessage:(NSString*)message {
    //show pop up on any validation error
    [KCUIAlert showInformationAlertWithHeader:AppLabel.errorTitle message:message withButtonTapHandler:^{
        
    }];
}

#pragma mark - Server End Code

- (void)updatePassword {
    // Update the password on server
    if(isNetworkReachable) {
        // Request to update password on server
        NSDictionary *parameters = @{kUserID:_userProfile.userID, kAcessToken:_userProfile.accessToken, kLanguageID:_userProfile.languageID, kPassword:_updatePassword.newlyPassword, kCurrentPassword:_updatePassword.oldPassword};
        __weak KCChangePasswordViewController *weakSelf = self;
        [KCProgressIndicator showProgressIndicatortWithText:AppLabel.activityUpdatingPassword];
        [_updateProfileManager updateUserPasswordWithParameters:parameters withCompletionHandler:^(NSString *title, NSString *message) {
            [KCProgressIndicator hideActivityIndicator];
            [KCUIAlert showInformationAlertWithHeader:title message:message withButtonTapHandler:^{
                // Show alert and exit from the screen to the previous screen
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
        } failure:^(NSString *title, NSString *message) {
            // Show failure alert with reason
            [KCProgressIndicator hideActivityIndicator];
            [KCUIAlert showInformationAlertWithHeader:title message:message withButtonTapHandler:^{
                
            }];
        }];
    }
    else {
        // Show alert for no internet connectivity
        [KCUIAlert showInformationAlertWithHeader:AppLabel.errorTitle message:AppLabel.internetNotAvailable withButtonTapHandler:^{
            
        }];
    }
}


@end
