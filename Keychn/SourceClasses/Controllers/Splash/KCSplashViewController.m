//
//  KCSplashViewController.m
//  Keychn
//
//  Created by Rohit Kumar on 03/12/15.
//  Copyright © 2015 Rohit Kumar. All rights reserved.
//

#import "KCSplashViewController.h"
#import "KCUserProfileDBManager.h"

@interface KCSplashViewController ()

@end

@implementation KCSplashViewController

#pragma mark - Life Cycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (void)pushNextViewController {
    //push next view controller based on the condition
    KCUserProfileDBManager *userProfileDBManager = [KCUserProfileDBManager new];
    [userProfileDBManager getLoggedInUserProfile];
    KCUserProfile *userProfile = [KCUserProfile sharedInstance];
    
    NSString *storyboardID = nil;
    if([NSString validateString:userProfile.userID]) {
        storyboardID = kHomeViewController;
    }
    else {
        storyboardID = signUpViewController;
    }
    UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:storyboardID];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
