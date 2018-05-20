//
//  MenuTabBarController.m
//  Keychn
//
//  Created by Rohit Kumar on 20/11/2017.
//  Copyright © 2017 Keychn Experience. All rights reserved.
//

#import "MenuTabBarController.h"
#import "TabSwitchAnimationController.h"
#import "UIView+YGPulseView.h"

@interface MenuTabBarController () <UITabBarControllerDelegate>

@end

@implementation MenuTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // Add pulse animation to UITabBar first item
    [self addPulseAnimation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // Change orientation to Portrait
    [[UIDevice currentDevice] setValue:@(UIInterfaceOrientationPortrait) forKey:@"orientation"];
}

- (id <UIViewControllerAnimatedTransitioning>)tabBarController:(UITabBarController *)tabBarController
            animationControllerForTransitionFromViewController:(UIViewController *)fromVC
                                              toViewController:(UIViewController *)toVC {
    return [[TabSwitchAnimationController alloc] init];
}

#pragma mark - Animation Work

- (void)addPulseAnimation {
    UIView *itemView = self.tabBar.subviews.firstObject;
    [itemView startPulseWithColor:[UIColor redColor] scaleFrom:0.5 to:3 frequency:10 opacity:0.5f animation:YGPulseViewAnimationTypeRadarPulsing];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end


