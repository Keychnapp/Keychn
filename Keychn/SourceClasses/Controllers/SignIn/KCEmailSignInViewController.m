//
//  KCEmailSignInViewController.m
//  Keychn
//
//  Created by Keychn Experience SL on 29/12/15.
//  Copyright © 2015 Keychn Experience SL. All rights reserved.
//

#import "KCEmailSignInViewController.h"
#import "KCEmailSignUpTableViewCell.h"
#import "KCEmailSignInButtonTableCell.h"
#import "KCLoginWebManager.h"
#import "KCUserProfileDBManager.h"
#import "KCAppLanguageWebManager.h"
#import "KCLanguageSelectionViewController.h"
#import "KCEmailSignUpViewController.h"


#define CELL_HEIGHT_IPHONE_6 @[@"152", @"40", @"40"]
#define CELL_HEIGHT_IPHONE_5 @[@"110", @"40", @"40"]
#define CELL_HEIGHT_IPHONE_4 @[@"60", @"40", @"40"]
#define CELL_HEIGHT_IPAD     @[@"220", @"50", @"60"]

@interface KCEmailSignInViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate> {
    BOOL                _shouldAdjustUI;
    KCAppLabel          *_appLabel;
    KCUserProfile       *_userProfile;
    KCLoginWebManager   *_loginWebManager;
    KCAppLanguageWebManager *_appLanguageWebManager;
    NSArray                 *_cellHeightArray;
}

@property (weak, nonatomic) IBOutlet UITableView *signInTableView;
@property (weak, nonatomic) IBOutlet UIView *seperatorView;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (nonatomic,strong) UITextField *editingTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation KCEmailSignInViewController

#pragma mark - Life Cycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    IOSDevices currentDevice = [KCUtility getiOSDeviceType];
    if(currentDevice == iPhone4) {
        _cellHeightArray = CELL_HEIGHT_IPHONE_4;
    }
    else if(currentDevice == iPhone5) {
        _cellHeightArray = CELL_HEIGHT_IPHONE_5;
    }
    else if(currentDevice == iPhone6 || currentDevice == iPhone6Plus) {
        _cellHeightArray = CELL_HEIGHT_IPHONE_6;
    }
    else {
        _cellHeightArray = CELL_HEIGHT_IPAD;
    }

    
    //register for keyboard notifications
    [self registerForKeyboardNotifications];
    
    _appLabel = [KCAppLabel sharedInstance];
    
    _userProfile = [KCUserProfile new];
    
    //customize UI
    [self customizeUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //set text on buttons and labels
    [self setText];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //remove keyboard notification
    [self deregisterForKeyboardNotifications];
}

#pragma mark - Table View DataSource and Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        return [[_cellHeightArray objectAtIndex:indexPath.row] integerValue];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if(indexPath.row <= cellIndexEmailSignInPassword) {
        KCEmailSignUpTableViewCell *emailSignInTextFieldCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierForEmailSignInTextField forIndexPath:indexPath];
        cell = emailSignInTextFieldCell;
        [emailSignInTextFieldCell.userDetailTextField setValue:[UIColor placeholderColorEmailSignUp]
                                           forKeyPath:@"_placeholderLabel.textColor"];
        emailSignInTextFieldCell.userDetailTextField.tag = indexPath.row;
        emailSignInTextFieldCell.userDetailTextField.font = [UIFont setRobotoFontRegularStyleWithSize:14];
        
        //add a background layer
        CALayer *border = [CALayer layer];
        CGFloat borderWidth = 1.0f;
        border.borderColor = [UIColor textFieldSeparatorColorEmailSignUp].CGColor;
        border.frame = CGRectMake(0, 29, 238, 30);
        border.borderWidth = borderWidth;
        [emailSignInTextFieldCell.userDetailTextField.layer addSublayer:border];
        emailSignInTextFieldCell.userDetailTextField.layer.masksToBounds = YES;
        emailSignInTextFieldCell.userDetailTextField.autocorrectionType  = UITextAutocorrectionTypeNo;
        
        switch (indexPath.row) {
            case cellIndexEmailSignInEmail:
                emailSignInTextFieldCell.userDetailTextField.keyboardType = UIKeyboardTypeEmailAddress;
                emailSignInTextFieldCell.userDetailTextField.returnKeyType   = UIReturnKeyNext;
                emailSignInTextFieldCell.userDetailTextField.placeholder  = _appLabel.placeholderEmail;
                emailSignInTextFieldCell.userDetailTextField.text = _userProfile.emailID;
                break;
            case cellIndexEmailSignInPassword:
                emailSignInTextFieldCell.userDetailTextField.secureTextEntry = YES;
                emailSignInTextFieldCell.userDetailTextField.returnKeyType   = UIReturnKeyDone;
                emailSignInTextFieldCell.userDetailTextField.placeholder  = _appLabel.placeholderPassword;
                emailSignInTextFieldCell.userDetailTextField.text = _userProfile.password;
                break;
        }
    }
    else {
        KCEmailSignInButtonTableCell *emailSignInButtonCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierForEmailSignInButton forIndexPath:indexPath];
        cell = emailSignInButtonCell;
        [emailSignInButtonCell.forgotPasswordButton setTitle:_appLabel.btnForgotPassword forState:UIControlStateNormal];
        emailSignInButtonCell.forgotPasswordButton.titleLabel.font = [UIFont setRobotoFontRegularStyleWithSize:14];
        [emailSignInButtonCell.forgotPasswordButton setTitleColor:[UIColor placeholderColorEmailSignUp] forState:UIControlStateNormal];
    }
    return cell;
}

#pragma mark - Text Field Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.editingTextField = textField;
}
- (IBAction)textFieldEditingChanged:(UITextField *)sender {
    switch (sender.tag) {
        case cellIndexEmailSignInEmail:
            _userProfile.emailID = sender.text;
            break;
        case cellIndexEmailSignInPassword:
            _userProfile.password = sender.text;
        default:
            break;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField.tag == cellIndexEmailSignInEmail) {
        KCEmailSignUpTableViewCell *emailSignInCell = [self.signInTableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:textField.tag+1 inSection:0]];
        [emailSignInCell.userDetailTextField becomeFirstResponder];
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
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height-40, 0.0);
    self.signInTableView.contentInset = contentInsets;
    self.signInTableView.scrollIndicatorInsets = contentInsets;
    
    if(([KCUtility getiOSDeviceType] == iPhone4|| iPhone5) && _shouldAdjustUI) {
        _shouldAdjustUI = NO;
        [self.view layoutIfNeeded];
        [UIView animateWithDuration:0.5
                         animations:^{
                             [self.view layoutIfNeeded]; // Called on parent view
                         }];
    }
}

- (void) didKeyboardDisappear:(NSNotification*)notification {
    
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.signInTableView.contentInset = contentInsets;
    self.signInTableView.scrollIndicatorInsets = contentInsets;
    
    if(([KCUtility getiOSDeviceType] == iPhone4|| iPhone5) && !_shouldAdjustUI) {
        _shouldAdjustUI = YES;
        [self.view layoutIfNeeded];
        [UIView animateWithDuration:0.5
                         animations:^{
                             [self.view layoutIfNeeded]; // Called on parent view
                         }];
    }
}


#pragma mark - Button Action

- (IBAction)backButtonTapped:(id)sender {
    [self.view endEditing:true];
    [self dismissViewControllerAnimated:true completion:^{
        
    }];
}


- (IBAction)forgotPasswordButtonTapped:(id)sender {
    [self.editingTextField resignFirstResponder];
    UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:forgotPasswordViewController];
    [self.navigationController pushViewController:viewController animated:YES];
}



- (IBAction)loginButtonTapped:(id)sender {
    if([self validateTextFields]) {
        if(isNetworkReachable) {
            [self loginWithUserDetails];
        }
        else {
            [KCUIAlert showInformationAlertWithHeader:AppLabel.errorTitle message:AppLabel.internetNotAvailable withButtonTapHandler:^{
                
            }];
        }
    }
    [self.editingTextField resignFirstResponder];
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

- (void) customizeUI {
    //customize app UI screen
    self.headerLabel.font               = [UIFont setRobotoFontRegularStyleWithSize:17];
    self.loginButton.titleLabel.font    = [UIFont setRobotoFontBoldStyleWithSize:14];
    self.seperatorView.backgroundColor  = [UIColor separatorLineColor];
}

- (void) pushNextViewController {
    //validate user fields and push next view controller
    KCUserProfile *userProfile      = [KCUserProfile sharedInstance];
    
    NSString *storyboardID = nil;
    
    if([NSString validateString:userProfile.facebookProfile.facebookID]) {
        if([NSString validateString:userProfile.languageID]) {
            storyboardID = kHomeViewController;
        }
        else {
            storyboardID = selectLangugeViewController;
        }
    }
    else if(![NSString validateString:userProfile.imageURL]) {
        storyboardID = setProfilePhotoViewController;
    }
    else if(![NSString validateString:userProfile.languageID]) {
        storyboardID = selectLangugeViewController;
    }
    
    if(storyboardID) {
        UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:storyboardID];
        if([viewController isKindOfClass:[KCLanguageSelectionViewController class]]) {
            KCLanguageSelectionViewController *languageSelectionViewController = (KCLanguageSelectionViewController*)viewController;
            languageSelectionViewController.shouldHideBackButton = YES;
        }
        
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (void) pushHomeViewController {
    UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:kHomeViewController];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (BOOL) validateTextFields {
    //all text fields should be validated
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

- (void) showValidationAlertWithMessage:(NSString*)message {
    //show pop up on any validation error
    [KCUIAlert showInformationAlertWithHeader:AppLabel.errorTitle message:message withButtonTapHandler:^{
        
    }];
}

- (void) setText {
    self.headerLabel.text  = _appLabel.lblSignIn;
    [self.loginButton setTitle:[_appLabel.lblSignIn uppercaseString] forState:UIControlStateNormal];
}


#pragma mark - Server End Code

- (void) loginWithUserDetails {
    //login user with filled details
    if(!_loginWebManager) {
        _loginWebManager = [[KCLoginWebManager alloc] init];
    }
   
    NSDictionary *params = [_userProfile getUserProfileDictionary];
    __weak id weakSelf   = self;
    [_loginWebManager signInUserWithDetails:params withCompletionHandler:^(NSDictionary *response) {
        //Sign in successfully
        KCUserProfileDBManager *userProfileDBManager = [KCUserProfileDBManager new];
        //Save user  profile
        [userProfileDBManager saveUserWithSocialProfile:response];
        KCUserProfile *loggedInUserProfile = [KCUserProfile sharedInstance];
        
        [weakSelf fetchAppLanguageLabelWithLanguageID:loggedInUserProfile.languageID];
    } failure:^(NSString *title, NSString *message) {
        //requet failed with error
        [KCUIAlert showInformationAlertWithHeader:title message:message withButtonTapHandler:^{
            
        }];
    }];
}

- (void) fetchAppLanguageLabelWithLanguageID:(NSNumber*)languageID {
    //fetch app labels from server
    if(!_appLanguageWebManager) {
        _appLanguageWebManager = [KCAppLanguageWebManager new];
    }
    __weak id weakSelf   = self;
    [_appLanguageWebManager getAppLabelsForLanguage:languageID withCompletionHandler:^(KCSupportedLanguage *supportedLanguage) {
        //language labels saved, go to the next screen
        [weakSelf pushHomeViewController];
    } andFailureBlock:^(NSString *title, NSString *message) {
        [KCUIAlert showInformationAlertWithHeader:title message:message withButtonTapHandler:^{
            
        }];
    }];
}




@end
