//
//  KCBottomBar.m
//  Keychn
//
//  Created by Keychn on 01/09/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import "KCBottomBar.h"
#import "AppDelegate.h"
#import "KCMyScheduleViewController.h"
#import "KCMyPreferenceViewController.h"
#import "KCMasterClassListViewController.h"
#import "KCItemListViewController.h"

#define kViewControllersArray @[@"KCMasterClassListViewController", @"KCItemListViewController", @"KCMyScheduleViewController", @"KCMyPreferenceViewController", @"KCCookViewController"]

#define kSelectedImageArray    @[@"select_home_icon.png", @"select_recipes_icon.png", @"select_cook_icon.png", @"select_schedule_icon.png", @"select_user_icon"]
#define kUnselectedImageArray  @[@"unselect_home_icon.png", @"unselect_recipes_icon.png", @"unselect_cook_icon.png", @"unselect_schedule_icon.png", @"unselect_user_icon"]


@interface KCBottomBar () <UINavigationControllerDelegate> {
    NSInteger _prevSelectedIndex;
}

@property (nonatomic, assign) UINavigationController *navigationController;
@property (weak, nonatomic) IBOutlet UIButton *homeButton;
@property (weak, nonatomic) IBOutlet UIButton *recipesButton;
@property (weak, nonatomic) IBOutlet UIButton *mysScheduleButton;
@property (weak, nonatomic) IBOutlet UIButton *profileButton;


@property (weak, nonatomic) IBOutlet UIButton *recipesTitleButton;
@property (weak, nonatomic) IBOutlet UIButton *homeTitleButton;
@property (weak, nonatomic) IBOutlet UIButton *myScheduleTitleButton;
@property (weak, nonatomic) IBOutlet UIButton *profileTitleButton;

@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation KCBottomBar

#pragma mark- Customize UI 

+(instancetype)bottomBar {
    static KCBottomBar *bottomBar = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bottomBar = [[[NSBundle mainBundle] loadNibNamed:@"BottomBar" owner:self options:nil] lastObject];
    });
    return bottomBar;
}

- (void)customizeUIWithFrame:(CGRect)frame {
    self.frame = frame;
    //Set app delegate for Push Pop notification
    AppDelegate *appDelegate  = (AppDelegate *) [UIApplication sharedApplication].delegate;
    self.navigationController = (UINavigationController *)appDelegate.window.rootViewController;
    self.navigationController.delegate = self;

    
    // Add a layer for separator
    CALayer *topLayer                  =  [[CALayer alloc] init];
    topLayer.frame  = CGRectMake(0, 0, CGRectGetWidth(frame), 1);
    topLayer.backgroundColor           = [UIColor navSeparatorLineColor].CGColor;
    [self.layer addSublayer:topLayer];
    self.clipsToBounds = YES;
    
    // Set text
    [self setText];
}

-(void)setText {
    // Set texts
    [self.homeTitleButton setTitle:AppLabel.lblMasterClass forState:UIControlStateNormal];
    self.homeTitleButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.homeTitleButton.titleLabel.minimumScaleFactor        = 0.5f;
    [self.recipesTitleButton setTitle:AppLabel.btnRecipesTab forState:UIControlStateNormal];
    [self.myScheduleTitleButton setTitle:AppLabel.lblCalendar forState:UIControlStateNormal];
    [self.profileTitleButton setTitle:AppLabel.btnProfileTab forState:UIControlStateNormal];
    self.myScheduleTitleButton.titleLabel.adjustsFontSizeToFitWidth = YES;
}

#pragma mark - Navigation Controlle Delegate 

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    START_METHOD
    [self showHideBottomBar];
}

#pragma mark - Set Home Scree

- (void)selectScreenWithIndex:(TabIndex)index {
   // Change image of tab items
    [self unSelectButtonWithIndex:_prevSelectedIndex];
    switch (index) {
        case Home:
            if(!self.homeButton.isSelected) {
                self.homeButton.selected = YES;
            }
            break;
        case Recipes:
            if(!self.recipesButton.isSelected) {
                self.recipesButton.selected = YES;
            }
            break;
        default:
            break;
    }
    _prevSelectedIndex = index;
}

#pragma mark - Button Actions

- (IBAction)homeButtonTapped:(UIButton *)sender {
    if(!self.homeButton.isSelected) {
        // Change image of tab items
        [self naviagteScreenWithIndex:sender.tag];
        
        // Change image of tab items
        self.homeButton.selected = YES;
        self.homeTitleButton.selected = YES;
        [self unSelectButtonWithIndex:_prevSelectedIndex];
        _prevSelectedIndex = sender.tag;
    }
    else {
        // Scroll list to top
        KCMasterClassListViewController *masterclassListViewController = [self.navigationController.viewControllers lastObject];
        [masterclassListViewController scrollListToTop];
    }
}

- (IBAction)recipesButtonTapped:(UIButton *)sender {
    if(!self.recipesButton.isSelected) {
        [self naviagteScreenWithIndex:sender.tag];
        
        // Change image of tab items
        self.recipesButton.selected = YES;
        self.recipesTitleButton.selected = YES;
        [self unSelectButtonWithIndex:_prevSelectedIndex];
        _prevSelectedIndex = sender.tag;
    }
    else {
        // Get the controller and scroll item list to top
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if([controller isKindOfClass:[KCItemListViewController class]]) {
                KCItemListViewController *itemListController = (KCItemListViewController *)controller;
                [itemListController scrollToTop];
                break;
            }
        }
    }
}


- (IBAction)myScheduleButtonTapped:(UIButton *)sender {
    if(!self.mysScheduleButton.isSelected) {
        [self naviagteScreenWithIndex:sender.tag];
        
        // Change image of tab items
        self.mysScheduleButton.selected = YES;
        self.myScheduleTitleButton.selected = YES;
        [self unSelectButtonWithIndex:_prevSelectedIndex];
        _prevSelectedIndex = sender.tag;
    }
}

- (IBAction)profileButtonTapped:(UIButton *)sender {
    if(!self.profileButton.isSelected) {
        [self naviagteScreenWithIndex:sender.tag];
        
        // Change image of tab items
        self.profileButton.selected = YES;
        self.profileTitleButton.selected = YES;
        [self unSelectButtonWithIndex:_prevSelectedIndex];
        _prevSelectedIndex = sender.tag;
    }
}

#pragma mark - Screen Navigation

- (void)naviagteScreenWithIndex:(TabIndex)index {
    NSString *storyboardID;
    Class    className    ;
    NSString *eventName = nil;
    switch (index) {
        case Home:
            eventName       = @"nav_masterclass";
            storyboardID    = kHomeViewController;
            className       = [KCMasterClassListViewController class];
            break;
        case Recipes:
            eventName       = @"nav_recipes";
            storyboardID    = itemListViewController;
            className       = [KCItemListViewController class];
            break;
        case MySchedule:
            eventName       = @"nav_calendar";
            storyboardID    = myScheduleViewController;
            className       = [KCMyScheduleViewController class];
            break;
        case Profile:
            eventName       = @"nav_profile";
            storyboardID    = myPreferenceViewController;
            className       = [KCMyPreferenceViewController class];
            break;
    }
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:eventName
         properties:@{@"":@""}];
    
    
    // Check if the view controller is already in the navigatation stack
    AppDelegate *appDelegate                     = (AppDelegate *) [UIApplication sharedApplication].delegate;
    UINavigationController *navigationController = (UINavigationController *)appDelegate.window.rootViewController;
    NSArray *viewControllerArray                 = navigationController.viewControllers;
    
    // Iterate through
    if([[viewControllerArray lastObject] class] != className ) {
        UIViewController *requiredViewController    = nil;
        @autoreleasepool {
            for (UIViewController *viewController in viewControllerArray) {
                if ([viewController class] == className) {
                    requiredViewController = viewController;
                    break;
                }
            }
        }
        
        //If found then pop view controller
        if(requiredViewController) {
            [navigationController popToViewController:requiredViewController animated:YES];
        }
        else {
            requiredViewController = [MAIN_STORYBOARD instantiateViewControllerWithIdentifier:storyboardID];
            [navigationController pushViewController:requiredViewController animated:YES];
        }
    }
}

- (void)showHideBottomBar {
    // Show hide bottom bar according to the eligble view controllers to show the bottom bar
    UIViewController *topViewController = [self.navigationController.viewControllers lastObject];
    NSString *className                 = NSStringFromClass([topViewController class]);
    
    // Visible if the top object is in the array else hidden
    self.hidden                         = ![kViewControllersArray containsObject:className];
}

- (void)unSelectButtonWithIndex:(NSInteger )index {
    // Set unselected image
    switch (index) {
        case Home:
            self.homeButton.selected = NO;
            self.homeTitleButton.selected = NO;
            break;
        case Recipes:
            self.recipesButton.selected = NO;
            self.recipesTitleButton.selected = NO;
            break;
        case MySchedule:
            self.mysScheduleButton.selected = NO;
            self.myScheduleTitleButton.selected = NO;
            break;
        case Profile:
            self.profileButton.selected = NO;
            self.profileTitleButton.selected = NO;
            break;
    }
}

@end
