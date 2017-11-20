//
//  MenuTabBarController.m
//  Keychn
//
//  Created by Rohit Kumar on 20/11/2017.
//  Copyright © 2017 Keychn Experience. All rights reserved.
//

#import "MenuTabBarController.h"
#import "TabSwitchAnimationController.h"

@interface MenuTabBarController () <UITabBarControllerDelegate>

@end

@implementation MenuTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id <UIViewControllerAnimatedTransitioning>)tabBarController:(UITabBarController *)tabBarController
            animationControllerForTransitionFromViewController:(UIViewController *)fromVC
                                              toViewController:(UIViewController *)toVC {
    return [[TabSwitchAnimationController alloc] init];
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


