//
//  KCContactUsViewController.m
//  Keychn
//
//  Created by Keychn Experience SL on 16/03/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import "KCContactUsViewController.h"
#import "KCContactUsWebManager.h"


@interface KCContactUsViewController () <UITextViewDelegate> {
    KCUserProfile               *_userProfile;
    KCContactUsWebManager       *_contactUsWebManager;
    UIToolbar                   *_inputViewToolBar;
}

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *messageTextView;
@property (strong, nonatomic) IBOutlet UIView *separatorView;
@property (weak, nonatomic) IBOutlet UIView *userDetailContainerView;
@property (weak, nonatomic) IBOutlet UIView *seperatorView2;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailIDLabel;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (weak, nonatomic) IBOutlet UILabel *charCountLabel;

@end

@implementation KCContactUsViewController

#pragma mark - Life Cycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Get instances
    _userProfile            = [KCUserProfile sharedInstance];
    _contactUsWebManager    = [KCContactUsWebManager new];
    
    [self customizeUI];
    
    // Input accessory view to close the keyboard
    [self setInputAccesoryView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Set text on buttons and lables
    [self setText];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Text Field Delegate

- (void)textViewDidChange:(UITextView *)textView {
    if(textView.text.length > 0) {
        self.placeholderLabel.hidden = YES;
        self.charCountLabel.hidden   = NO;
    }
    else {
        self.placeholderLabel.hidden = NO;
        self.charCountLabel.hidden   = YES;
    }
    // Set char count
    self.charCountLabel.text = [NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:textView.text.length]];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return YES;
}

#pragma mark - Button Actions

- (IBAction)backButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sendButtonTapped:(id)sender {
    [self.messageTextView resignFirstResponder];
    // Validate message for 100 chars
    NSString *message = self.messageTextView.text;
    if(message.length >= 100) {
        // Submit a query
        [self submitQuery];
    }
    else {
        // Show alert for minimum chars required
        [KCUIAlert showInformationAlertWithHeader:AppLabel.informationTitle message:AppLabel.minumumCharsRequiredForQuery withButtonTapHandler:^{
            
        }];
    }
}

- (void)keyboardDownButtonTapped:(id)sender {
    // Close Keyboard
    [self.messageTextView resignFirstResponder];
}

#pragma mark - Instance Methods

- (void) customizeUI {
    // Set font color and layouts
    self.view.backgroundColor               = [UIColor whiteColor];
   
    // Add border to user detail view
    CALayer *layer      = [[CALayer alloc] init];
    layer.frame         = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 1);
    layer.borderColor   = [UIColor separatorLineColor].CGColor;
    layer.borderWidth   = 1.0f;
    [self.userDetailContainerView.layer addSublayer:layer];
    
    self.separatorView.backgroundColor  = [UIColor separatorLineColor];
    self.seperatorView2.backgroundColor = [UIColor separatorLineColor];
    
    // Set fonts
    self.titleLabel.font            = [UIFont setRobotoFontRegularStyleWithSize:17];
    self.placeholderLabel.font      = [UIFont setRobotoFontRegularStyleWithSize:14];
    self.sendButton.titleLabel.font = [UIFont setRobotoFontRegularStyleWithSize:15];
    self.usernameLabel.font         = [UIFont setRobotoFontRegularStyleWithSize:15];
    self.emailIDLabel.font          = [UIFont setRobotoFontRegularStyleWithSize:15];
}

- (void)setText {
    // Set text on buttons and labels
    self.usernameLabel.text     =  _userProfile.username;
    self.emailIDLabel.text      = _userProfile.emailID;
    self.titleLabel.text        = AppLabel.lblContactUs;
    self.placeholderLabel.text  = AppLabel.lblHowCanWeHelp;
    [self.sendButton setTitle:AppLabel.btnSend forState:UIControlStateNormal];
}

- (void)setInputAccesoryView {
    // Instantiate input view and input accessory view for date of birth text field
    UIButton      *downButton  = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)-60, 0, 40, 40)];
    [downButton setImage:[UIImage imageNamed:@"keyboard_close_icon.png"] forState:UIControlStateNormal];
    UIBarButtonItem *barButtonLeft    = [[UIBarButtonItem alloc] initWithCustomView:downButton];
    _inputViewToolBar       = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 40)];
    [_inputViewToolBar setItems:@[barButtonLeft]];
    [downButton addTarget:self action:@selector(keyboardDownButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    self.messageTextView.inputAccessoryView = _inputViewToolBar;
}

#pragma mark - Server End Code

- (void)submitQuery {
    // Submit user query on server
    if(isNetworkReachable) {
        NSDictionary *parametes = @{kUserID:_userProfile.userID, kEmailID:_userProfile.emailID, kName:_userProfile.username, kAcessToken:_userProfile.accessToken, kLanguageID:_userProfile.languageID, kQueryDescription:self.messageTextView.text};
        __weak KCContactUsViewController *weakSelf = self;
        [KCProgressIndicator showProgressIndicatortWithText:AppLabel.activitySubmittingQuery];
        [_contactUsWebManager submitQueryWithParameter:parametes withCompletionHandler:^(NSDictionary *responseDictionary) {
            // Request completed
            [KCProgressIndicator hideActivityIndicator];
            [KCUIAlert showInformationAlertWithHeader:AppLabel.informationTitle message:AppLabel.querySubmittedSuccessfully withButtonTapHandler:^{
                // Back to Setting ViewController
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
        } andFailure:^(NSString *title, NSString *message) {
            // Request failed
            [KCProgressIndicator hideActivityIndicator];
            [KCUIAlert showInformationAlertWithHeader:title message:message withButtonTapHandler:^{
                
            }];
        }];
    }
    else {
        // Show alert for no internet connection
        [KCUIAlert showInformationAlertWithHeader:AppLabel.errorTitle message:AppLabel.internetNotAvailable withButtonTapHandler:^{
            
        }];
    }
}

@end
