//
//  KCUIAlert.m
//  Keychn
//
//  Created by Keychn Experience SL on 31/12/15.
//  Copyright © 2015 Keychn Experience SL. All rights reserved.
//

#import "KCUIAlert.h"
#import "AppDelegate.h"

@interface KCUIAlert () <UITextFieldDelegate> {
    NSInteger _currentRating;
    NSString  *_itemTitle;
    NSInteger _keyboardAdjustmentFactor;
}

@property (nonatomic, copy) void (^alertViewDismissed)(void);
@property (nonatomic, copy) void (^itemRatingAlerViewDismissed)(NSInteger rating);
@property (nonatomic, copy) void (^freeRideItemRatingAlerViewDismissed)(NSInteger rating, NSString *title);
@property (nonatomic,strong) UIView *scheduleSuccessView;
@property (nonatomic,strong) UIView *keychnInteractionThanksView;
@property (nonatomic,strong) NSMutableArray *starRatingButtonsArray;
@property (nonatomic,strong) UITextField *itemTitleTextField;

@end


@implementation KCUIAlert

+ (void)showAlertWithButtonTitle:(NSString *)title alertHeader:(NSString *)header message:(NSString *)message withButtonTapHandler:(void (^)(BOOL positiveButton))buttonTapped {
    //show an alert with postive button title and cancel using the block
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:header message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
         buttonTapped(NO);
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
         buttonTapped(YES);
        [alertController dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    [appDelegate.window.rootViewController presentViewController:alertController animated:YES completion:^{
        
    }];
    
}

+ (void)showAlertWithButtonTitle:(NSString *)title alertHeader:(NSString *)header message:(NSString *)message onViewController:(UIViewController *)viewController withButtonTapHandler:(void (^)(BOOL positiveButton))buttonTapped {
    //show an alert with postive button title and cancel using the block
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:header message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        buttonTapped(NO);
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        buttonTapped(YES);
        [alertController dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [viewController presentViewController:alertController animated:YES completion:^{
        
    }];
    
}

+ (void)showInformationAlertWithHeader:(NSString *)header message:(NSString *)message withButtonTapHandler:(void (^)(void))buttonTapped {
    //show an alert with OK Button using the block
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:header message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"ok", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        buttonTapped();
        [alertController dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
    [alertController addAction:okAction];
    AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    [appDelegate.window.rootViewController presentViewController:alertController animated:YES completion:^{
        
    }];
}


+ (void)showInformationAlertWithHeader:(NSString *)header message:(NSString *)message onViewController:(UIViewController *)viewController withButtonTapHandler:(void (^)(void))buttonTapped {
    //show an alert with OK Button using the block
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:header message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"ok", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        buttonTapped();
        [alertController dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
    [alertController addAction:okAction];
    [viewController presentViewController:alertController animated:YES completion:^{
        
    }];
}

- (void)showScheduleSuccessAlertOnView:(UIView*)view withButtonTapHandler:(void(^)(void))alertDismissed {
    //Show alert when User call is successfully scheduled
    NSInteger viewWidth  = CGRectGetWidth(view.frame);
    NSInteger viewHeight = CGRectGetHeight(view.frame);
    self.scheduleSuccessView = [[UIView alloc] initWithFrame:CGRectMake((viewWidth-320)/2, (viewHeight-150)/2, 320, 150)];
    self.scheduleSuccessView.backgroundColor = [UIColor lightGrayBackgroundColor];
    
    UILabel *headerLabel  = [[UILabel alloc] initWithFrame:CGRectMake(25, 19, 295, 21)];
//    headerLabel.text      = AppLabel.lblKeyInteractionScheduled;
    headerLabel.font      = [UIFont setRobotoFontBoldStyleWithSize:18];
    headerLabel.textColor = [UIColor whiteColor];
    
    UILabel *subtitleLabel    = [[UILabel alloc] initWithFrame:CGRectMake(25, 42, 295, 21)];
//    subtitleLabel.text        = AppLabel.lblWeWillNotifyForMatch;
    subtitleLabel.font        = [UIFont setRobotoFontBoldStyleWithSize:14];
    subtitleLabel.adjustsFontSizeToFitWidth = YES;
    subtitleLabel.textColor   = [UIColor whiteColor];
    
    UIButton *knifeUpButton   = [UIButton buttonWithType:UIButtonTypeSystem];
    knifeUpButton.frame       = CGRectMake(0, 91, 320, 58);
//    [knifeUpButton setTitle:AppLabel.btnKnifesUp forState:UIControlStateNormal];
    [knifeUpButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    knifeUpButton.titleLabel.font = [UIFont setRobotoFontBoldStyleWithSize:14];
    [knifeUpButton setBackgroundColor:[UIColor  appBackgroundColor]];
    [knifeUpButton addTarget:self action:@selector(dismissScheduleAlertViewButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    //Add subviews
    [self.scheduleSuccessView addSubview:headerLabel];
    [self.scheduleSuccessView addSubview:subtitleLabel];
    [self.scheduleSuccessView addSubview:knifeUpButton];
    [view addSubview:self.scheduleSuccessView];
    
    //Retain block
    self.alertViewDismissed = alertDismissed;
    
    //Present alert view with animation
    self.scheduleSuccessView.transform = CGAffineTransformMakeScale(0.001, 0.001);
    __weak KCUIAlert *weakSelf = self;
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        weakSelf.scheduleSuccessView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished){
        // do something once the animation finishes, put it here
    }];
}


- (void) dismissScheduleAlertViewButtonTapped:(UIButton*)sender {
    //Dismiss alert view with animation and call the dismiss handler
    self.scheduleSuccessView.transform = CGAffineTransformIdentity;
    __weak KCUIAlert *weakSelf = self;
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        weakSelf.scheduleSuccessView.transform = CGAffineTransformMakeScale(0.001, 0.001);
    } completion:^(BOOL finished){
        // do something once the animation finishes, put it here
        weakSelf.alertViewDismissed();
    }];
}

- (void)showThanksAlertOnView:(UIView*)view withButtonTapHandler:(void(^)(NSInteger itemRating))alertDismissed {
    //Show alert when User call is successfully scheduled
    NSInteger viewWidth  = CGRectGetWidth(view.frame);
    NSInteger viewHeight = CGRectGetHeight(view.frame);
    self.keychnInteractionThanksView = [[UIView alloc] initWithFrame:CGRectMake((viewWidth-300)/2, (viewHeight-176)/2, 300, 176)];
    self.keychnInteractionThanksView.backgroundColor = [UIColor lightGrayBackgroundColor];
    
    UILabel *headerLabel  = [[UILabel alloc] initWithFrame:CGRectMake(25, 19, 295, 21)];
//    headerLabel.text      = AppLabel.lblYouAreAStar;
    headerLabel.font      = [UIFont setRobotoFontBoldStyleWithSize:18];
    headerLabel.textColor = [UIColor whiteColor];
    
    UILabel *subtitleLabel    = [[UILabel alloc] initWithFrame:CGRectMake(25, 42, 295, 21)];
//    subtitleLabel.text        = AppLabel.lblPleaseRateTheRecipe;
    subtitleLabel.font        = [UIFont setRobotoFontBoldStyleWithSize:14];
    subtitleLabel.textColor   = [UIColor whiteColor];
    
    //Add stars buttons to the alert view
    NSInteger xPosition = 52;
    NSInteger padding   = 26;
    NSInteger buttonSize = 17;
    self.starRatingButtonsArray = [[NSMutableArray alloc] init];
    for (NSInteger i=0; i<5; i++) {
        UIButton *starButton = [UIButton buttonWithType:UIButtonTypeCustom];
        starButton.frame     = CGRectMake(xPosition, 72, buttonSize, buttonSize);
        xPosition            = xPosition + padding + buttonSize;
        starButton.tag       = i;
        [starButton setImage:[UIImage imageNamed:@"white_rating_star.png"] forState:UIControlStateNormal];
        [starButton setImage:[UIImage imageNamed:@"select_rating_icon.png"] forState:UIControlStateSelected];
        [self.keychnInteractionThanksView addSubview:starButton];
        [starButton addTarget:self action:@selector(ratingButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.starRatingButtonsArray addObject:starButton];
    }
    
    _currentRating = 0;
    
    UIButton *thankYouButton  = [UIButton buttonWithType:UIButtonTypeSystem];
    thankYouButton.frame       = CGRectMake(0, 118, 300, 58);
//    [thankYouButton setTitle:AppLabel.btnThankYou forState:UIControlStateNormal];
    [thankYouButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    thankYouButton.titleLabel.font = [UIFont setRobotoFontBoldStyleWithSize:14];
    [thankYouButton setBackgroundColor:[UIColor  appBackgroundColor]];
    [thankYouButton addTarget:self action:@selector(dismissThanksAlertViewButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    //Add subviews
    [self.keychnInteractionThanksView addSubview:headerLabel];
    [self.keychnInteractionThanksView addSubview:subtitleLabel];
    [self.keychnInteractionThanksView addSubview:thankYouButton];
    [view addSubview:self.keychnInteractionThanksView];
    
    //Retain block
    self.itemRatingAlerViewDismissed = alertDismissed;
    
    //Present alert view with animation
    self.keychnInteractionThanksView.transform = CGAffineTransformMakeScale(0.001, 0.001);
    __weak KCUIAlert *weakSelf = self;
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        weakSelf.keychnInteractionThanksView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished){
        // do something once the animation finishes, put it here
    }];
}

- (void) showFreeRideThanksAlertOnView:(UIView*)view withCurrentRating:(NSInteger)currentRating withButtonTapHandler:(void(^)(NSInteger itemRating, NSString *itemTitle))alertDismissed {
    //Show free ride thanks alert for rating and item title
    NSInteger viewWidth  = CGRectGetWidth(view.frame);
    NSInteger viewHeight = CGRectGetHeight(view.frame);
    
    self.keychnInteractionThanksView = [[UIView alloc] initWithFrame:CGRectMake((viewWidth-300)/2, (viewHeight-265)/2, 300, 265)];
    self.keychnInteractionThanksView.backgroundColor = [UIColor lightGrayBackgroundColor];
    
    UILabel *headerLabel  = [[UILabel alloc] initWithFrame:CGRectMake(25, 19, 295, 21)];
//    headerLabel.text      = AppLabel.lblYouAreAStar;
    headerLabel.font      = [UIFont setRobotoFontBoldStyleWithSize:18];
    headerLabel.textColor = [UIColor whiteColor];
    
    UILabel *subtitleLabel    = [[UILabel alloc] initWithFrame:CGRectMake(25, 42, 295, 21)];
//    subtitleLabel.text        = AppLabel.lblPleaseRateTheRecipe;
    subtitleLabel.font        = [UIFont setRobotoFontBoldStyleWithSize:14];
    subtitleLabel.textColor   = [UIColor whiteColor];
    
    //Add stars buttons to the alert view
    NSInteger xPosition = 52;
    NSInteger padding   = 26;
    NSInteger buttonSize = 17;
    self.starRatingButtonsArray = [[NSMutableArray alloc] init];
    for (NSInteger i=0; i<5; i++) {
        UIButton *starButton = [UIButton buttonWithType:UIButtonTypeCustom];
        starButton.frame     = CGRectMake(xPosition, 82, buttonSize, buttonSize);
        xPosition            = xPosition + padding + buttonSize;
        starButton.tag       = i;
        [starButton setImage:[UIImage imageNamed:@"white_rating_star.png"] forState:UIControlStateNormal];
        [starButton setImage:[UIImage imageNamed:@"select_rating_icon.png"] forState:UIControlStateSelected];
        [self.keychnInteractionThanksView addSubview:starButton];
        [starButton addTarget:self action:@selector(ratingButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.starRatingButtonsArray addObject:starButton];
        
        if(currentRating > 0 && i <= currentRating-1) {
            starButton.selected = YES;
        }
    }
    
    _currentRating = currentRating;
    
    //Please tell us label
    UILabel *pleaseTellUsLabel  = [[UILabel alloc] initWithFrame:CGRectMake(0, 121, 300, 21)];
    pleaseTellUsLabel.font      = [UIFont setRobotoFontBoldStyleWithSize:17];
    pleaseTellUsLabel.textColor = [UIColor whiteColor];
//    pleaseTellUsLabel.text      = AppLabel.lblPleaseTellUsWhatDidYouCook;
    pleaseTellUsLabel.textAlignment = NSTextAlignmentCenter;
    
    // Item title textfield
    UIView *textFieldContainerView = [[UIView alloc] initWithFrame:CGRectMake(30, 160, 240, 30)];
    textFieldContainerView.backgroundColor = [UIColor popUpTextFieldColor];
    self.itemTitleTextField = [[UITextField alloc] initWithFrame:CGRectMake(4, 0, 238, 30)];
    [self.itemTitleTextField setBorderStyle:UITextBorderStyleNone];
    self.itemTitleTextField.delegate         = self;
    self.itemTitleTextField.returnKeyType    = UIReturnKeyDone;
    [self.itemTitleTextField addTarget:self action:@selector(didChangeItemTitle:) forControlEvents:UIControlEventEditingChanged];
    self.itemTitleTextField.font = [UIFont setRobotoMediumFontWithSize:16];
    self.itemTitleTextField.textColor = [UIColor darkGrayColor];
    [textFieldContainerView addSubview:self.itemTitleTextField];
    
    UIButton *thankYouButton  = [UIButton buttonWithType:UIButtonTypeSystem];
    thankYouButton.frame       = CGRectMake(0, CGRectGetHeight(self.keychnInteractionThanksView.frame)-58, 300, 58);
//    [thankYouButton setTitle:AppLabel.btnThankYou forState:UIControlStateNormal];
    [thankYouButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    thankYouButton.titleLabel.font = [UIFont setRobotoFontBoldStyleWithSize:14];
    [thankYouButton setBackgroundColor:[UIColor  appBackgroundColor]];
    [thankYouButton addTarget:self action:@selector(dismissFreeRideThanksAlertViewButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    //Add subviews
    [self.keychnInteractionThanksView addSubview:headerLabel];
    [self.keychnInteractionThanksView addSubview:subtitleLabel];
    [self.keychnInteractionThanksView addSubview:pleaseTellUsLabel];
    [self.keychnInteractionThanksView addSubview:textFieldContainerView];
    [self.keychnInteractionThanksView addSubview:thankYouButton];
    [view addSubview:self.keychnInteractionThanksView];
    
    //Register for Keyboard notification
    [self registerForKeyboardNotifications];
    
    //Retain block
    self.freeRideItemRatingAlerViewDismissed = alertDismissed;
    
    //Present alert view with animation
    self.keychnInteractionThanksView.transform = CGAffineTransformMakeScale(0.001, 0.001);
    __weak KCUIAlert *weakSelf = self;
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        weakSelf.keychnInteractionThanksView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished){
        // do something once the animation finishes, put it here
    }];
}

- (void)showChewItThanksAlertOnView:(UIView*)view withCurrentRating:(NSInteger)currentRating withButtonTapHandler:(void(^)(NSInteger itemRating, NSString *itemTitle))alertDismissed {
    //Show free ride thanks alert for rating and item title
    NSInteger viewWidth  = CGRectGetWidth(view.frame);
    NSInteger viewHeight = CGRectGetHeight(view.frame);
    
    self.keychnInteractionThanksView = [[UIView alloc] initWithFrame:CGRectMake((viewWidth-300)/2, (viewHeight-265)/2, 300, 265)];
    self.keychnInteractionThanksView.backgroundColor = [UIColor lightGrayBackgroundColor];
    
    UILabel *headerLabel  = [[UILabel alloc] initWithFrame:CGRectMake(25, 19, 295, 21)];
//    headerLabel.text      = AppLabel.lblYouAreAStar;
    headerLabel.font      = [UIFont setRobotoFontBoldStyleWithSize:18];
    headerLabel.textColor = [UIColor whiteColor];
    
    UILabel *subtitleLabel    = [[UILabel alloc] initWithFrame:CGRectMake(25, 42, 295, 21)];
//    subtitleLabel.text        = AppLabel.lblPleaseRateTheInteraction;
    subtitleLabel.font        = [UIFont setRobotoFontBoldStyleWithSize:14];
    subtitleLabel.textColor   = [UIColor whiteColor];
    
    //Add stars buttons to the alert view
    NSInteger xPosition = 52;
    NSInteger padding   = 26;
    NSInteger buttonSize = 17;
    self.starRatingButtonsArray = [[NSMutableArray alloc] init];
    for (NSInteger i=0; i<5; i++) {
        UIButton *starButton = [UIButton buttonWithType:UIButtonTypeCustom];
        starButton.frame     = CGRectMake(xPosition, 82, buttonSize, buttonSize);
        xPosition            = xPosition + padding + buttonSize;
        starButton.tag       = i;
        [starButton setImage:[UIImage imageNamed:@"white_rating_star.png"] forState:UIControlStateNormal];
        [starButton setImage:[UIImage imageNamed:@"select_rating_icon.png"] forState:UIControlStateSelected];
        [self.keychnInteractionThanksView addSubview:starButton];
        [starButton addTarget:self action:@selector(ratingButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.starRatingButtonsArray addObject:starButton];
        
        if(currentRating > 0 && i <= currentRating-1) {
            starButton.selected = YES;
        }
    }
    
    _currentRating = currentRating;
    
    //Please tell us label
    UILabel *pleaseTellUsLabel  = [[UILabel alloc] initWithFrame:CGRectMake(0, 121, 300, 21)];
    pleaseTellUsLabel.font      = [UIFont setRobotoFontBoldStyleWithSize:17];
    pleaseTellUsLabel.textColor = [UIColor whiteColor];
//    pleaseTellUsLabel.text      = AppLabel.lblPleaseTellUsWhatDidYouEat;
    pleaseTellUsLabel.textAlignment = NSTextAlignmentCenter;
    
    // Item title textfield
    UIView *textFieldContainerView         = [[UIView alloc] initWithFrame:CGRectMake(30, 160, 240, 30)];
    textFieldContainerView.backgroundColor = [UIColor popUpTextFieldColor];
    self.itemTitleTextField    = [[UITextField alloc] initWithFrame:CGRectMake(4, 0, 238, 30)];
    [self.itemTitleTextField setBorderStyle:UITextBorderStyleNone];
    self.itemTitleTextField.font = [UIFont setRobotoMediumFontWithSize:16];
    self.itemTitleTextField.textColor = [UIColor darkGrayColor];
    self.itemTitleTextField.delegate         = self;
    self.itemTitleTextField.returnKeyType    = UIReturnKeyDone;
    [self.itemTitleTextField addTarget:self action:@selector(didChangeItemTitle:) forControlEvents:UIControlEventEditingChanged];
    [textFieldContainerView addSubview:self.itemTitleTextField];
    
    UIButton *thankYouButton  = [UIButton buttonWithType:UIButtonTypeSystem];
    thankYouButton.frame       = CGRectMake(0, CGRectGetHeight(self.keychnInteractionThanksView.frame)-58, 300, 58);
//    [thankYouButton setTitle:AppLabel.btnThankYou forState:UIControlStateNormal];
    [thankYouButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    thankYouButton.titleLabel.font = [UIFont setRobotoFontBoldStyleWithSize:14];
    [thankYouButton setBackgroundColor:[UIColor  appBackgroundColor]];
    [thankYouButton addTarget:self action:@selector(dismissFreeRideThanksAlertViewButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    //Add subviews
    [self.keychnInteractionThanksView addSubview:headerLabel];
    [self.keychnInteractionThanksView addSubview:subtitleLabel];
    [self.keychnInteractionThanksView addSubview:pleaseTellUsLabel];
    [self.keychnInteractionThanksView addSubview:textFieldContainerView];
    [self.keychnInteractionThanksView addSubview:thankYouButton];
    [view addSubview:self.keychnInteractionThanksView];
    
    //Register for Keyboard notification
    [self registerForKeyboardNotifications];
    
    //Retain block
    self.freeRideItemRatingAlerViewDismissed = alertDismissed;
    
    //Present alert view with animation
    self.keychnInteractionThanksView.transform = CGAffineTransformMakeScale(0.001, 0.001);
    __weak KCUIAlert *weakSelf = self;
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        weakSelf.keychnInteractionThanksView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished){
        // do something once the animation finishes, put it here
    }];
}

- (void) dismissThanksAlertViewButtonTapped:(UIButton*)sender {
    //Dismiss alert view with animation and call the dismiss handler
    self.keychnInteractionThanksView.transform = CGAffineTransformIdentity;
    __weak KCUIAlert *weakSelf = self;
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        weakSelf.keychnInteractionThanksView.transform = CGAffineTransformMakeScale(0.001, 0.001);
    } completion:^(BOOL finished){
        // do something once the animation finishes, put it here
        weakSelf.itemRatingAlerViewDismissed(_currentRating);
    }];
}

- (void) dismissFreeRideThanksAlertViewButtonTapped:(UIButton*)sender {
    //Dismiss alert view with animation and call the dismiss handler for Free Ride alert
    
    if(_itemTitle.length == 0 || _currentRating == 0) {
        [KCUIAlert showInformationAlertWithHeader:@"" message:@"" withButtonTapHandler:^{
            
        }];
    }
    else {
        //Remove Keyboard observers
        [self deregisterForKeyboardNotifications];
        [self.itemTitleTextField resignFirstResponder];
        //Close Pop Up view with animation
        self.keychnInteractionThanksView.transform = CGAffineTransformIdentity;
        __weak KCUIAlert *weakSelf = self;
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            weakSelf.keychnInteractionThanksView.transform = CGAffineTransformMakeScale(0.001, 0.001);
        } completion:^(BOOL finished){
            // do something once the animation finishes, put it here
            weakSelf.freeRideItemRatingAlerViewDismissed(_currentRating, _itemTitle);
        }];
    }
    
}

- (void) ratingButtonTapped:(UIButton*)sender {
    //Rating button tapped
    @autoreleasepool {
        for (UIButton *starButton in self.starRatingButtonsArray) {
           __block BOOL status = NO;
            _currentRating = sender.tag+1;
            if(starButton.tag <= sender.tag) {
                status = YES;
            }
            [UIView transitionWithView:starButton duration:0.3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                starButton.selected = status;
            } completion:^(BOOL finished) {
                
            }];
            
        }
    }
}

#pragma mark - Text Field Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    _itemTitle = textField.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return  YES;
}

- (void) didChangeItemTitle:(UITextField*)sender {
    _itemTitle = sender.text;
    if(DEBUGGING) NSLog(@"Item title %@",_itemTitle);
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


- (void)deregisterForKeyboardNotifications {
    //Remove keyboard observers
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

- (void) didKeyboardAppear:(NSNotification*)notification {
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    NSInteger contentPosition = CGRectGetHeight(self.keychnInteractionThanksView.frame) + CGRectGetMinY(self.keychnInteractionThanksView.frame);
    NSInteger screenHeight    = [UIScreen mainScreen].bounds.size.height;
    
    NSInteger shiftFactor     = screenHeight - kbSize.height;
    
    if(contentPosition>shiftFactor) {
        NSInteger upFactor = contentPosition - shiftFactor;
        CGRect viewFrame = self.keychnInteractionThanksView.frame;
        _keyboardAdjustmentFactor = upFactor + 5;
        viewFrame.origin.y -= _keyboardAdjustmentFactor;
        [UIView transitionWithView:self.keychnInteractionThanksView duration:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.keychnInteractionThanksView.frame = viewFrame;
        } completion:^(BOOL finished) {
            
        }];
    }
    else {
        _keyboardAdjustmentFactor = 0;
    }
    
}

- (void)didKeyboardDisappear:(NSNotification*)notification {
    if(_keyboardAdjustmentFactor > 0) {
        CGRect viewFrame = self.keychnInteractionThanksView.frame;
        viewFrame.origin.y += _keyboardAdjustmentFactor;
        [UIView transitionWithView:self.keychnInteractionThanksView duration:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.keychnInteractionThanksView.frame = viewFrame;
        } completion:^(BOOL finished) {
            
        }];
    }
}

@end
