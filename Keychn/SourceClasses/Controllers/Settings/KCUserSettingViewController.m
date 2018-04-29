//
//  KCUserSettingViewController.m
//  Keychn
//
//  Created by Keychn Experience SL on 04/01/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import "KCUserSettingViewController.h"
#import "KCSettingsSocialAccountTableCell.h"
#import "KCSettingWebLinksTableCell.h"
#import "KCUserProfileDBManager.h"
#import "AppDelegate.h"
#import "KCFacebookManager.h"
#import "KCSignUpWebManager.h"
#import "IAPSubscription.h"
#import "KeychnStore.h"


#define NUMBER_OF_ROWS_IN_SECTION @[@3, @2, @1]
#define NUMBER_OF_SECTIONS          3

@interface KCUserSettingViewController () <UITableViewDataSource, UITableViewDelegate> {
    KCUserProfile               *_userProfile;
    KCFacebookManager           *_facebookManager;
    KCSignUpWebManager          *_signUpWebMangager;
    KCUserProfileDBManager      *_userProfileDBManager;
}

@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UITableView *settingsTableView;
@property (weak, nonatomic) IBOutlet UIButton *logOutButton;
@property (strong,nonatomic) UISwitch         *facebookSwitch;

@end

@implementation KCUserSettingViewController

#pragma mark - Life Cycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Get instances
    _userProfile            = [KCUserProfile sharedInstance];
    _facebookManager        = [[KCFacebookManager alloc] init];
    _signUpWebMangager      = [[KCSignUpWebManager alloc] init];
    _userProfileDBManager   = [[KCUserProfileDBManager alloc] init];
    
    // Customize UI for font and color
    [self customizeUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Reload table to update text when view reapperas
    [self.settingsTableView reloadData];
}

#pragma mark - Table View Datasource and Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[NUMBER_OF_ROWS_IN_SECTION objectAtIndex:section] integerValue];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return NUMBER_OF_SECTIONS;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 68;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *tableCell = nil;
    
    if(indexPath.section == 0) {
        KCSettingWebLinksTableCell *webLinkTableCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierForSettingWebLinks forIndexPath:indexPath];
        tableCell = webLinkTableCell;
        switch (indexPath.row) {
            case restoreInAppPurchase:
                webLinkTableCell.settingsURLLabel.text = [NSLocalizedString(@"restorePurchase", nil) uppercaseString];
                break;
            case changePassword:
                webLinkTableCell.settingsURLLabel.text = [NSLocalizedString(@"changePassword", nil) uppercaseString];
                break;
            case aboutUs:
                webLinkTableCell.settingsURLLabel.text = [NSLocalizedString(@"aboutUs", nil) uppercaseString];
                break;
        }
        webLinkTableCell.settingsURLLabel.font         = [UIFont setRobotoFontBoldStyleWithSize:15];
    }
    else if(indexPath.section == 1) {
        KCSettingWebLinksTableCell *webLinkTableCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierForSettingWebLinks forIndexPath:indexPath];
        tableCell = webLinkTableCell;
        switch (indexPath.row) {
            case contactUs:
                webLinkTableCell.settingsURLLabel.text = [NSLocalizedString(@"contactUs", nil) uppercaseString];
                break;
            case privacy:
                webLinkTableCell.settingsURLLabel.text = [NSLocalizedString(@"privacy", nil) uppercaseString];
                break;
        }
        webLinkTableCell.settingsURLLabel.font         = [UIFont setRobotoFontBoldStyleWithSize:15];
    }
    else {
        KCSettingsSocialAccountTableCell *socialAccountTableCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierForSettingSocialAccount forIndexPath:indexPath];
        socialAccountTableCell.socialAccountTitleLabel.text  = [NSLocalizedString(@"facebook", nil) uppercaseString];
        socialAccountTableCell.socialAccountTitleLabel.font  = [UIFont setRobotoFontBoldStyleWithSize:15];
        socialAccountTableCell.socialAccountConnectSwitch.on = _userProfile.facebookProfile.isActive;
        self.facebookSwitch     = socialAccountTableCell.socialAccountConnectSwitch;
        tableCell = socialAccountTableCell;
    }
    tableCell.selectionStyle    = UITableViewCellSelectionStyleNone;
    return tableCell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *eventName = nil;
    if(indexPath.section == 0) {
        switch (indexPath.row) {
            case restoreInAppPurchase:
                eventName = @"settings_restore";
                [self restoreInAppPurchase];
                break;
            case changePassword:
                eventName = @"settings_password";
                [self pushChangePasswordViewController];
                break;
            case aboutUs:
                eventName = @"settings_about";
                [self openWebViewWithURL:aboutUsURL];
                break;
             default:
                break;
        }
    }
    else if(indexPath.section == 1) {
        switch (indexPath.row) {
            case contactUs:
                eventName = @"settings_contact";
                [self pushContactUsViewController];
                break;
            case privacy:
                eventName = @"settings_privacy";
                [self openWebViewWithURL:privacyPolicyURL];
                break;
        }
    }
}

#pragma mark - Button Actions

- (IBAction)socialSwitchAppValueChanged:(UISwitch*)sender {
    if(sender.isOn) {
        // Fist check facebook account is connected or not
        if([NSString validateString:_userProfile.facebookProfile.facebookID]) {
            // Facebook account is already connected then change status to active
            [self changeFacebookStatus:YES];
        }
        else {
            // Merge facebook account with Keychn account
            [self mergeFacebookProfile];
        }
    }
    else {
        // Facebook account already exists, chagne status to inactive
        [self changeFacebookStatus:NO];
    }
}

- (IBAction)backButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)logoutButtonTapped:(id)sender {
    // Log out user
    [[NSNotificationCenter defaultCenter] postNotificationName:kMasterclassPreviewDismissNotification object:nil];
    [self logOutUser];
}

#pragma mark - Instance Methods

- (void)customizeUI {
    // Customize font and color
    self.headerLabel.font                 = [UIFont setRobotoFontRegularStyleWithSize:17];
    self.logoutButton.titleLabel.font     = [UIFont setRobotoFontBoldStyleWithSize:15];
    self.logoutButton.backgroundColor     = [UIColor appBackgroundColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.settingsTableView.contentInset       = UIEdgeInsetsMake(-5, 0, 0, 0);
}

- (void)openWebViewWithURL:(NSString*)url {
    // Open a URL on app web view
    KCAppWebViewViewController *appWebView = [self.storyboard instantiateViewControllerWithIdentifier:appWebViewController];
    appWebView.urlToOpen                   = url;
    [self.navigationController pushViewController:appWebView animated:YES];
}

- (void)pushChangePasswordViewController {
    // Go to change password viewController
    UIViewController *changePasswordController = [self.storyboard instantiateViewControllerWithIdentifier:changePasswordViewController];
    [self.navigationController pushViewController:changePasswordController animated:YES];
}

- (void)restoreInAppPurchase {
    // Check if user has purchased any item then restore or let the user know that there is no purhchase
    IAPSubscription *subscription = [IAPSubscription subscriptionForUser:_userProfile.userID];
    if(subscription) {
        KeychnStore *store = [KeychnStore getSharedInstance];
        [store restoreAppReceiptsForProductId:subscription.productId];
    }
}

- (void)pushContactUsViewController {
    // Go to Contact Us ViewController
    UIViewController *contactUsController = [self.storyboard instantiateViewControllerWithIdentifier:contacUsViewController];
    [self.navigationController pushViewController:contactUsController animated:YES];
}

- (void)toggleFaceookSwitchWithFlag:(BOOL)flag {
    // Set facebook swithc to ON/OFF
    self.facebookSwitch.on = flag;
}

- (void)removeUserSessions {
    // Delete user profile
    [_userProfileDBManager deleteUserProfile];
    
    //remove all view controllers and set a new stack
    UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:signUpViewController];
    NSArray *viewControllersStack   = @[viewController];
    //get root view controller
    AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    UINavigationController *rootViewController =  (UINavigationController*)appDelegate.window.rootViewController;
    [rootViewController setViewControllers:viewControllersStack animated:YES];
}

#pragma mark - Server End Code

- (void)mergeFacebookProfile {
    if(isNetworkReachable) {
        __weak id weakSelf = self;
        [_facebookManager connectToFacebookWithViewController:self completionHandler:^(BOOL flag) {
            //Facebook data fetched, login with facebook
            if(flag) {
                NSMutableDictionary *facebookParams = [[NSMutableDictionary alloc] initWithDictionary:[_userProfile.facebookProfile getSocialUserProfileDictionary]];
                [facebookParams setObject:_userProfile.userID forKey:kUserID];
                [_signUpWebMangager linkFacebookAccount:facebookParams withCompletionHandler:^(NSDictionary *response) {
                    [weakSelf toggleFaceookSwitchWithFlag:YES];
                    
                    // Save data to local database
                    [_userProfileDBManager saveFacebookProfileWithUserID:_userProfile.userID];
                    
                } failure:^(NSString *title, NSString *message) {
                    [weakSelf toggleFaceookSwitchWithFlag:NO];
                    _userProfile.facebookProfile.facebookID = nil;
                    [KCUIAlert showInformationAlertWithHeader:title message:message withButtonTapHandler:^{
                        
                    }];
                }];
            }
            else {
                [weakSelf toggleFaceookSwitchWithFlag:NO];
                _userProfile.facebookProfile.facebookID = nil;
            }
        }];
    }
    else {
        //Show alert for no internet connection
        [KCUIAlert showInformationAlertWithHeader:NSLocalizedString(@"networkError", nil) message:NSLocalizedString(@"tryReconnecting", nil) withButtonTapHandler:^{
            
        }];
        [self toggleFaceookSwitchWithFlag:NO];
        _userProfile.facebookProfile.facebookID = nil;
    }
}

- (void)changeFacebookStatus:(BOOL)isActive {
    // Change facebook status to active/inactive
    if(isNetworkReachable) {
        __block BOOL facebookFlag = isActive;
        Mixpanel *mixpanel = [Mixpanel sharedInstance];
        [mixpanel track:@"settings_facebook"
             properties:@{@"status":isActive?@"YES":@"NO"}];

        [KCProgressIndicator showNonBlockingIndicator];
        NSDictionary *params = @{kUserID:_userProfile.userID, kAcessToken:_userProfile.accessToken, kSocialID:_userProfile.facebookProfile.facebookID, kIsActive:[NSNumber numberWithBool:isActive]};
        [_signUpWebMangager changeStatusForFacebookAccountWithParameters:params withCompletionHandler:^(NSDictionary *response) {
            _userProfile.facebookProfile.isActive = facebookFlag;
            // Save data to local database
            [_userProfileDBManager saveFacebookProfileWithUserID:_userProfile.userID];
            [KCProgressIndicator hideActivityIndicator];
        } failure:^(NSString *title, NSString *message) {
            [KCProgressIndicator hideActivityIndicator];
            //Show alert for no internet connection
            [self toggleFaceookSwitchWithFlag:!facebookFlag];
            [KCUIAlert showInformationAlertWithHeader:NSLocalizedString(@"networkError", nil) message:NSLocalizedString(@"tryReconnecting", nil) withButtonTapHandler:^{
                
            }];
        }];
    }
    else {
        [self toggleFaceookSwitchWithFlag:!isActive];
    }
}

- (void) logOutUser {
    if(isNetworkReachable) {
        // Log out user
        Mixpanel *mixpanel = [Mixpanel sharedInstance];
        [mixpanel track:@"settings_logout"
             properties:@{@"":@""}];

        NSDictionary *parameters = @{kUserID:_userProfile.userID};
        [KCProgressIndicator showProgressIndicatortWithText:NSLocalizedString(@"loggingOut", nil)];
        __weak id weakSelf = self;
        [_signUpWebMangager logOutUserWithParameters:parameters CompletinHandler:^(BOOL status) {
            [KCProgressIndicator hideActivityIndicator];
            if(status) {
                // Log out user and delete all sessions
                [weakSelf removeUserSessions];
            }
        }];
    }
    else {
        [KCUIAlert showInformationAlertWithHeader:NSLocalizedString(@"networkError", nil) message:NSLocalizedString(@"tryReconnecting", nil) withButtonTapHandler:^{
            
        }];
    }
}

@end
