//
//  KCNavigationController.m
//  Keychn
//
//  Created by Rohit Kumar on 18/11/2017.
//  Copyright © 2017 Keychn Experience. All rights reserved.
//

#import "KCNavigationController.h"
#import "KCGroupSessionGuestEndViewController.h"
#import "KCGroupSessionHostEndViewController.h"


@interface KCNavigationController ()

@end

@implementation KCNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Auto rotation

- (BOOL)shouldAutorotate {
    return  true;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    id lastObject = self.viewControllers.lastObject;
    if([lastObject isKindOfClass:[KCGroupSessionGuestEndViewController class]] || [lastObject isKindOfClass:[KCGroupSessionHostEndViewController class]]) {
        // For video calling options only
        return  UIInterfaceOrientationMaskLandscape;
    }
    return  UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    id lastObject = self.viewControllers.lastObject;
    if([lastObject isKindOfClass:[KCGroupSessionGuestEndViewController class]] || [lastObject isKindOfClass:[KCGroupSessionHostEndViewController class]]) {
        // For video calling options only
        return  UIInterfaceOrientationLandscapeLeft;
    }
    return  UIInterfaceOrientationPortrait;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
