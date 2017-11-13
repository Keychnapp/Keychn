//
//  KCSplashViewController.m
//  Keychn
//
//  Created by Rohit Kumar on 03/12/15.
//  Copyright © 2015 Rohit Kumar. All rights reserved.
//

#import "KCSplashViewController.h"
#import "KCUserProfileDBManager.h"
#import "KCLanguageSelectionViewController.h"
#import "KCAppLabelDBManager.h"
#import "KCAppLanguageWebManager.h"


@interface KCSplashViewController () {
    KCAppLanguageWebManager *_appLabelWebManger;
    KCAppLabelDBManager     *_appLabelDBManager;
}

@end

@implementation KCSplashViewController

#pragma mark - Life Cycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    //get app language
    [self getAppLanguage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor appBackgroundColor];
}

#pragma mark - App Navigation

- (void) pushNextViewController {
    //push next view controller based on the condition
    KCUserProfileDBManager *userProfileDBManager = [KCUserProfileDBManager new];
    [userProfileDBManager getLoggedInUserProfile];
    KCUserProfile *userProfile = [KCUserProfile sharedInstance];
    
    NSString *storyboardID = nil;
    if([NSString validateString:userProfile.userID]) {
        if([NSString validateString:userProfile.facebookProfile.facebookID]) {
            if([NSString validateString:userProfile.languageID]) {
                storyboardID = menuSegmentsViewController;
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
        else {
            storyboardID = menuSegmentsViewController;
        }
    }
    else {
        storyboardID = signUpViewController;
    }
    UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:storyboardID];
    if([viewController isKindOfClass:[KCLanguageSelectionViewController class]]) {
        KCLanguageSelectionViewController *languageSelectionViewController = (KCLanguageSelectionViewController*)viewController;
        languageSelectionViewController.shouldHideBackButton = YES;
    }
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - App Language Methods

- (void) getAppLanguage {
    //get default app language
    _appLabelDBManager = [KCAppLabelDBManager new];
    defaultLanguage    = [_appLabelDBManager getDefaultLanguage];
    
    //get all app lables from local database
    [self initializeAppLabel];
}

- (void) initializeAppLabel {
    //intialize all app labels from local database
    [_appLabelDBManager getAppLabelWithLanguaeID:defaultLanguage];
    if(![NSString validateString:AppLabel.lblSignUpText]) {
        //get default lanuage labels from server
        [self getAppLanguageWithLanguageID:defaultLanguage];
    }
    else {
        [self performSelector:@selector(pushNextViewController) withObject:nil afterDelay:splashDelayInSeconds];
    }
}

- (void) getAppLanguageWithLanguageID:(NSNumber*)languageID {
    _appLabelWebManger = [KCAppLanguageWebManager new];
    [_appLabelWebManger getAppLabelsForLanguage:languageID withCompletionHandler:^(KCSupportedLanguage *supportedLanguage) {
        [self initializeAppLabel];
        
    } andFailureBlock:^(NSString *title, NSString *message) {
       [KCUIAlert showInformationAlertWithHeader:title message:message withButtonTapHandler:^{
           
       }];
    }];
}

@end
