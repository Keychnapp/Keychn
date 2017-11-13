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
#import "KCSignUpWebManager.h"
#import "KCUserProfileDBManager.h"

#define CELL_HEIGHT_ARRAY_IPHONE @[@"75", @"75", @"75", @"75", @"75", @"143"]
#define CELL_HEIGHT_ARRAY_IPAD   @[@"110", @"110", @"110", @"110", @"95", @"213"]

@interface KCEmailSignUpViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate> {
    KCUserProfile           *_userProfile;
    NSString                *_confirmPassword;
    KCSignUpWebManager      *_signUpManager;
    KCAppLabel              *_appLabel;
    NSArray                 *_cellHeightArray;
}

@property (weak, nonatomic) IBOutlet UILabel *signUpLabel;
@property (weak, nonatomic) IBOutlet UITableView *signUpTableView;
@property (weak, nonatomic) IBOutlet UILabel *headeLabel;
@property (nonatomic,strong) UITextField     *editingTextField;
@property (weak, nonatomic) IBOutlet UIView *lineSeparatorView;

@end

@implementation KCEmailSignUpViewController

#pragma mark - Life Cycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //customize App UI
    [self customizeUI];
    
    //allocate instances
    _userProfile = [KCUserProfile new];
    _appLabel    = [KCAppLabel sharedInstance];
    
    //default value
    _userProfile.receiveNewsletter = [NSNumber numberWithBool:YES];
    
    if([KCUtility getiOSDeviceType] == iPad) {
        _cellHeightArray = CELL_HEIGHT_ARRAY_IPAD;
    }
    else {
        _cellHeightArray = CELL_HEIGHT_ARRAY_IPHONE;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //register for keybord notifications
    [self registerForKeyboardNotifications];
    
    //set text on views
    [self setTextOnViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self deregisterForKeyboardNotifications];
}

- (void) customizeUI {
    //customize app UI screen
    self.headeLabel.font  = [UIFont setRobotoFontRegularStyleWithSize:17];
    self.lineSeparatorView.backgroundColor = [UIColor separatorLineColor];
}

- (void) setTextOnViews {
    //sets text on all labels and buttons
    self.headeLabel.text = _appLabel.lblSignUpText;
}


#pragma mark - Table View DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [[_cellHeightArray objectAtIndex:indexPath.row] integerValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    KCEmailSignUpTableViewCell *emailSignUpCell = nil;
    KCEmailSignUpButtonTableViewCell *signUpButtonCell = nil;
    KCEmailSignUpNewsletterTableViewCell *receiveNewsletterCell = nil;
    
    if(indexPath.row <= cellIndexEmailSignUpConfirmPassword) {
        //customize text fields cell
        emailSignUpCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierEmailSignUpTextFields forIndexPath:indexPath];
        cell = emailSignUpCell;
        
        //add a background layer
        CALayer *border = [CALayer layer];
        CGFloat borderWidth = 1.0f;
        border.borderColor = [UIColor textFieldSeparatorColorEmailSignUp].CGColor;
        border.frame = CGRectMake(0, 29, 238, 30);
        border.borderWidth = borderWidth;
        [emailSignUpCell.userDetailTextField.layer addSublayer:border];
        emailSignUpCell.userDetailTextField.layer.masksToBounds = YES;
        emailSignUpCell.userDetailTextField.tag = indexPath.row;
        [emailSignUpCell.userDetailTextField setValue:[UIColor placeholderColorEmailSignUp]
                        forKeyPath:@"_placeholderLabel.textColor"];
        emailSignUpCell.userDetailTextField.font = [UIFont setRobotoFontRegularStyleWithSize:14];
        emailSignUpCell.userDetailTextField.autocorrectionType  = UITextAutocorrectionTypeNo;
        
        //customize keyboard and text field entry
        switch (indexPath.row) {
            case cellIndexEmailSignUpName:
                emailSignUpCell.userDetailTextField.placeholder = _appLabel.placeholderName;
                emailSignUpCell.userDetailTextField.text = _userProfile.username;
                break;
            case cellIndexEmailSignUpEmail:
                emailSignUpCell.userDetailTextField.keyboardType = UIKeyboardTypeEmailAddress;
                emailSignUpCell.userDetailTextField.placeholder = _appLabel.placeholderEmail;
                emailSignUpCell.userDetailTextField.text = _userProfile.emailID;
                break;
            case cellIndexEmailSignUpPassword:
                emailSignUpCell.userDetailTextField.secureTextEntry = YES;
                emailSignUpCell.userDetailTextField.placeholder = _appLabel.placeholderPassword;
                emailSignUpCell.userDetailTextField.text = _userProfile.password;
                break;
            case cellIndexEmailSignUpConfirmPassword:
                emailSignUpCell.userDetailTextField.secureTextEntry = YES;
                emailSignUpCell.userDetailTextField.returnKeyType = UIReturnKeyDone;
                emailSignUpCell.userDetailTextField.placeholder = _appLabel.placeholderConfirmPassword;
                emailSignUpCell.userDetailTextField.text = _confirmPassword;
                break;
        }
    }
    else if(indexPath.row == cellIndexEmailSignUpReceiveNewsletter) {
        //customize newsletter cell
        receiveNewsletterCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierForEmailSignUpReveiveNewsletter forIndexPath:indexPath];
        receiveNewsletterCell.receiveNewsletterLabel.text = _appLabel.receiveNewsletter;
        receiveNewsletterCell.receiveNewsletterLabel.font = [UIFont setRobotoFontRegularStyleWithSize:13];
        receiveNewsletterCell.receiveNewsletterLabel.textColor = [UIColor placeholderColorEmailSignUp];
        receiveNewsletterCell.newsletterPreferenceSwitch.onTintColor = [UIColor blackColor];
        cell = receiveNewsletterCell;
    }
    else {
        //customzie sign up cell
        signUpButtonCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierForEmailSignUpSignUpButton forIndexPath:indexPath];
        cell = signUpButtonCell;
        signUpButtonCell.signupButton.layer.cornerRadius  = 18;
        signUpButtonCell.signupButton.layer.masksToBounds = YES;
        [signUpButtonCell.signupButton setTitle:[_appLabel.lblSignUpText uppercaseString] forState:UIControlStateNormal];
        signUpButtonCell.signupButton.titleLabel.font   = [UIFont setRobotoFontBoldStyleWithSize:13];
        signUpButtonCell.signupButton.backgroundColor   = [UIColor appBackgroundColor];
        
        NSString *termsOfUseText = [[[[_appLabel.lblTermsAndConditions stringByAppendingString:@" "]stringByAppendingString:_appLabel.lblSignUpTerms] stringByAppendingString:@" "] stringByAppendingString:_appLabel.lblAgreeToThe];
        NSRange range1 = [termsOfUseText rangeOfString:_appLabel.lblTermsAndConditions];
        NSRange range2 = [termsOfUseText rangeOfString:_appLabel.lblSignUpTerms];
        NSRange range3 = [termsOfUseText rangeOfString:_appLabel.lblAgreeToThe];
        
        NSInteger fontSize = 12;
        
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:termsOfUseText];
        [attributedText setAttributes:@{NSFontAttributeName:[UIFont setRobotoFontRegularStyleWithSize:fontSize], NSForegroundColorAttributeName: [UIColor placeholderColorEmailSignUp]}
                                range:range1];
        [attributedText setAttributes:@{NSFontAttributeName:[UIFont setRobotoFontBoldStyleWithSize:fontSize], NSForegroundColorAttributeName: [UIColor placeholderColorEmailSignUp]}
                                range:range2];
        [attributedText setAttributes:@{NSFontAttributeName:[UIFont setRobotoFontRegularStyleWithSize:fontSize], NSForegroundColorAttributeName: [UIColor placeholderColorEmailSignUp]}
                                range:range3];
        signUpButtonCell.termsOfUseButton.titleLabel.font = [UIFont setRobotoFontRegularStyleWithSize:fontSize];
        signUpButtonCell.privacyPolicyButton.titleLabel.font = [UIFont setRobotoFontRegularStyleWithSize:fontSize];
        [signUpButtonCell.privacyPolicyButton setTitleColor:[UIColor termsOfUseForegroundColor] forState:UIControlStateNormal];
        signUpButtonCell.termsOfUseLabel.attributedText = attributedText;
        
        NSString *termsOfUseFullText = [NSString stringWithFormat:@"%@ %@ %@",_appLabel.lblTermsOfUse,_appLabel.lblAnd,_appLabel.lblPrivacyPolicy];
        attributedText  = [[NSMutableAttributedString alloc] initWithString:termsOfUseFullText];
        range1 = [termsOfUseFullText rangeOfString:_appLabel.lblTermsOfUse];
        range2 = [termsOfUseFullText rangeOfString:_appLabel.lblAnd];
        range3 = [termsOfUseFullText rangeOfString:_appLabel.lblPrivacyPolicy];
        [attributedText setAttributes:@{NSFontAttributeName:[UIFont setRobotoFontRegularStyleWithSize:fontSize], NSForegroundColorAttributeName: [UIColor termsOfUseForegroundColor]}
                                range:range1];
        [attributedText setAttributes:@{NSFontAttributeName:[UIFont setRobotoFontRegularStyleWithSize:fontSize], NSForegroundColorAttributeName: [UIColor placeholderColorEmailSignUp]}
                                range:range2];
        [attributedText setAttributes:@{NSFontAttributeName:[UIFont setRobotoFontRegularStyleWithSize:fontSize], NSForegroundColorAttributeName: [UIColor termsOfUseForegroundColor]}
                                range:range3];
        
        signUpButtonCell.privacyPolicyLabel.attributedText = attributedText;
    }
    
    return cell;
}

#pragma mark - Text Field Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField.tag < cellIndexEmailSignUpConfirmPassword) {
        KCEmailSignUpTableViewCell *emailSignUpCell = [self.signUpTableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:textField.tag+1 inSection:0]];
        [emailSignUpCell.userDetailTextField becomeFirstResponder];
    }
    else {
        [textField resignFirstResponder];
    }
    return YES;
}

- (IBAction)textFieldEditingChanged:(UITextField*)sender {
    //customize keyboard and text field entry
    switch (sender.tag) {
        case cellIndexEmailSignUpName:
            _userProfile.username = sender.text;
            break;
        case cellIndexEmailSignUpEmail:
            _userProfile.emailID = sender.text;
            break;
        case cellIndexEmailSignUpPassword:
            _userProfile.password = sender.text;
            break;
        case cellIndexEmailSignUpConfirmPassword:
            _confirmPassword = sender.text;
            break;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.editingTextField = textField;
}

#pragma mark - Button Actions

- (IBAction)backButtonTapped:(id)sender {
    [self.editingTextField resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)newsletterPreferencesSwitchTapped:(UISwitch*)sender {
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"signup_newsletter_toggle"
         properties:@{@"is_subscribed":@(sender.isOn)}];
    [self.editingTextField resignFirstResponder];
    _userProfile.receiveNewsletter = [NSNumber numberWithBool:sender.isOn];
}

- (IBAction)termsOfUseButtonTapped:(id)sender {
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"signup_terms_link"
         properties:@{@"":@""}];
    [self.editingTextField resignFirstResponder];
    KCAppWebViewViewController *webViewController = [self.storyboard instantiateViewControllerWithIdentifier:appWebViewController];
//    assign Web URL
    webViewController.urlToOpen = termsOfUsePolicy;
    [self.navigationController pushViewController:webViewController animated:YES];
}

- (IBAction)privacyPolicyButtonTapped:(id)sender {
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"signup_privacy_link"
         properties:@{@"":@""}];
    [self.editingTextField resignFirstResponder];
    KCAppWebViewViewController *webViewController = [self.storyboard instantiateViewControllerWithIdentifier:appWebViewController];
    //assign Web URL
    webViewController.urlToOpen = privacyPolicyURL;
    [self.navigationController pushViewController:webViewController animated:YES];
}


- (IBAction)signUpButtonTapped:(id)sender {
    [self.editingTextField resignFirstResponder];
    if([self validateTextFields]) {
        if(isNetworkReachable) {
            Mixpanel *mixpanel = [Mixpanel sharedInstance];
            [mixpanel track:@"login_signup_button"
                 properties:@{@"":@""}];
            //text field validated, try to register user
            if(!_signUpManager) {
                _signUpManager = [KCSignUpWebManager new];
            }
            NSDictionary *userProfileDictionary = [_userProfile getUserProfileDictionary];
            [_signUpManager signUpUserWithDetails:userProfileDictionary withCompletionHandler:^(NSDictionary *userProfile) {
                //get user model from response
                KCUserProfile *userProfileModel = [KCUserProfile sharedInstance];
                [userProfileModel getModelFromDictionary:userProfile withType:server];
                
                //save current user in local database
                KCUserProfileDBManager *userProfileDBManager = [[KCUserProfileDBManager alloc] init];
                [userProfileDBManager saveCurrentUserWithCompletionHandler:^{
                    
                }];
                
                //push next view controller
                [self pushSetProfilePhotoViewController];
                
            } failure:^(NSString *title, NSString *message) {
                [KCUIAlert showInformationAlertWithHeader:title message:message withButtonTapHandler:^{
                    
                }];
            }];
        }
        else {
            //show alert for no internet connection
            [KCUIAlert showInformationAlertWithHeader:AppLabel.errorTitle message:AppLabel.internetNotAvailable withButtonTapHandler:^{
                
            }];
        }
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
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height+5, 0.0);
    self.signUpTableView.contentInset = contentInsets;
    self.signUpTableView.scrollIndicatorInsets = contentInsets;
}

- (void) didKeyboardDisappear:(NSNotification*)notification {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.signUpTableView.contentInset = contentInsets;
    self.signUpTableView.scrollIndicatorInsets = contentInsets;
}

#pragma mark - Instance Method

- (void) pushSetProfilePhotoViewController {
    UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:setProfilePhotoViewController];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (BOOL) validateTextFields {
    //all text fields should be validated
    
    //validate user's name
    NSString *message = [NSString validateName:_userProfile.username];
    if(message) {
        [self showValidationAlertWithMessage:message];
        return NO;
    }
    
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
    
    //validate confirm password
    message         = [NSString validateConfirmPassword:_confirmPassword];
    if(message) {
        [self showValidationAlertWithMessage:message];
        return NO;
    }
    
    //match both passwords
    message         = [NSString matchPasswords:_userProfile.password andConfirmPassword:_confirmPassword];
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

@end
