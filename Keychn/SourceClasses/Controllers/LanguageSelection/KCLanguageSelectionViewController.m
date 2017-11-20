//
//  KCLanguageSelectionViewController.m
//  Keychn
//
//  Created by Keychn Experience SL on 30/12/15.
//  Copyright © 2015 Keychn Experience SL. All rights reserved.
//

#import "KCLanguageSelectionViewController.h"
#import "KCLanguageOptionView.h"
#import "KCAppLanguageWebManager.h"
#import "KCSupportedLanguage.h"
#import "UIImageView+AFNetworking.h"
#import "KCBottomBar.h"

#define DEFAULT_LANGUAGE_NAME @"English"

@interface KCLanguageSelectionViewController () {
    NSInteger               _selectedAppLanguageIndex;
    KCAppLanguageWebManager *_appLanguageWebManger;
    KCSupportedLanguage     *_supportedLanguage;
    KCUserProfile           *_userProfile;
    KCAppLabel              *_appLabel;
    NSInteger               _flagContainerViewWidth;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewWidthConstraint;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (nonatomic,strong) NSMutableArray *appLanguageViewsArray;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cotainerViewWidthConstraint2;
@property (weak, nonatomic) IBOutlet UIView *containerView2;
@property (weak, nonatomic) IBOutlet UILabel *headerlabel;
@property (weak, nonatomic) IBOutlet UILabel *appLanguageLabel;
@property (weak, nonatomic) IBOutlet UILabel *speakingLanguageLabel;
@property (weak, nonatomic) IBOutlet UILabel *multipleSelectInfoLabel;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollView2BottomConstraint;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView2;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (nonatomic,strong) NSMutableArray *speakingLanguageViewsArray;
@property (nonatomic,strong) NSMutableArray  *selectedSpeakingLanguageOptionsArray;
@property (nonatomic,strong) NSNumber        *selectedAppLanguage;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewTopSpaceConstraint;
@property (weak, nonatomic) IBOutlet UIView *lineSeparatorView;

@end

@implementation KCLanguageSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.containerView.backgroundColor  = [UIColor clearColor];
    self.containerView2.backgroundColor = [UIColor clearColor];
    self.backButton.hidden              = self.shouldHideBackButton;
    
    IOSDevices deviceType = [KCUtility getiOSDeviceType];
    
    if(deviceType == iPad) {
        _flagContainerViewWidth = 270;
    }
    else if(deviceType == iPhone4 || deviceType == iPhone5){
        _flagContainerViewWidth = 100;
    }
    else {
         _flagContainerViewWidth = 120;
    }
    
    //get instances
    _userProfile = [KCUserProfile sharedInstance];
    _appLabel    = [KCAppLabel sharedInstance];
    
    //set app language flag on scroll view, only one selection is allowed
    [self addAppLanguageOptions];
    
    //set user speaking language, multiple selection allowed
    [self addSpeakingLanguageOptions];
    
    //customize app UI, ie: set text,color and fonts
    [self customizeUI];
    
    //adjust UI for iPhone 4
    if([KCUtility getiOSDeviceType] == iPhone4 || iPhone5) {
        [self adjustUI];
    }
    
    //get supported languge from server
    [self fetchSupportedLanguageFromServer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Set text on views
    [self setText];
}


#pragma mark - Add SubViews

- (void) addAppLanguageOptions {
    //add app language options (National flag images to be added)
    self.appLanguageViewsArray = [[NSMutableArray alloc] init];
    NSInteger languageCounter = [_supportedLanguage.allSupportedLanguageArray count];
    for (int i=0; i<languageCounter; i++) {
        //Custome view for the flag and tick box
        KCLanguageOptionView *languageOptionView = [[KCLanguageOptionView alloc] initWithFrame:CGRectMake(i*_flagContainerViewWidth, 0, _flagContainerViewWidth, 40)];
        languageOptionView.languageSelectionImageView.tag = i;
        KCSupportedLanguage *appLanguage = [_supportedLanguage.allSupportedLanguageArray objectAtIndex:i];
        [languageOptionView.languageSelectionImageView setImageWithURL:[NSURL URLWithString:appLanguage.flagURL]];
        
        //Set preferred Language
        if([NSString validateString:_userProfile.languageID]) {
            // If user has seleced any language
            if([appLanguage.languageID integerValue] == [_userProfile.languageID integerValue]) {
                _selectedAppLanguageIndex = i;
                languageOptionView.langugeSelectedBoxImageView.hidden = NO;
                self.selectedAppLanguage = appLanguage.languageID;
            }
            else {
                languageOptionView.langugeSelectedBoxImageView.hidden = YES;
            }
        }
        else {
            // If user has no preferred language then the English will be the default language
            if([appLanguage.languageName caseInsensitiveCompare:DEFAULT_LANGUAGE_NAME] == NSOrderedSame) {
                _selectedAppLanguageIndex = i;
                languageOptionView.langugeSelectedBoxImageView.hidden = NO;
                self.selectedAppLanguage = appLanguage.languageID;
            }
            else {
                languageOptionView.langugeSelectedBoxImageView.hidden = YES;
            }
        }
        
        //add the views in the array to use it later
        [self.appLanguageViewsArray addObject:languageOptionView];
        [self.containerView addSubview:languageOptionView];
        
        //add tap gesture on Language Image View
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(languageAppGestureRecogized:)];
        [languageOptionView.languageSelectionImageView addGestureRecognizer:tapGesture];
    }
    //update scrolllView's container view constraint
    self.containerViewWidthConstraint.constant = languageCounter*_flagContainerViewWidth;
    [self.containerView updateConstraints];
}

- (void) addSpeakingLanguageOptions {
    //add user speaking language (National flag images to be added)
    self.speakingLanguageViewsArray           = [[NSMutableArray alloc] init];
    self.selectedSpeakingLanguageOptionsArray = [[NSMutableArray alloc] initWithArray:_supportedLanguage.userSpeakingLangugeArray];
    NSInteger languageCounter = [_supportedLanguage.allSupportedLanguageArray count];
    for (int i=0; i<languageCounter; i++) {
        //Custome view for the flag and tick box
        KCLanguageOptionView *languageOptionView = [[KCLanguageOptionView alloc] initWithFrame:CGRectMake(i*_flagContainerViewWidth, 0, _flagContainerViewWidth, 40)];
        languageOptionView.languageSelectionImageView.tag = i;
        KCSupportedLanguage *appLanguage = [_supportedLanguage.allSupportedLanguageArray objectAtIndex:i];
        [languageOptionView.languageSelectionImageView setImageWithURL:[NSURL URLWithString:appLanguage.flagURL]];
        if([self.selectedSpeakingLanguageOptionsArray containsObject:appLanguage.languageID]) {
          languageOptionView.langugeSelectedBoxImageView.hidden = NO;
        }
        else {
            languageOptionView.langugeSelectedBoxImageView.hidden = YES;
        }
        
        //add the views in the array to use it later
        [self.speakingLanguageViewsArray addObject:languageOptionView];
        [self.containerView2 addSubview:languageOptionView];
        
        //add tap gesture on Language Image View
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(speakingLanguageGestureRecogized:)];        
        [languageOptionView.languageSelectionImageView addGestureRecognizer:tapGesture];
    }
    //update scrolllView's container view constraint
    self.cotainerViewWidthConstraint2.constant = languageCounter*_flagContainerViewWidth;
    [self.containerView2 updateConstraints];
}

#pragma mark - Customize UI

- (void) adjustUI {
    //adjust UI for iPhone 4 & iPhone 5
    
    NSInteger scrollView1AdjustmentFactor = 0;
    NSInteger scrollView2AdjustmentFactor = 0;
    
    IOSDevices deviceType = [KCUtility getiOSDeviceType];
    switch (deviceType) {
        case iPhone4:
            scrollView1AdjustmentFactor = 60;
            scrollView2AdjustmentFactor = 90;
            break;
        case iPhone5:
            scrollView1AdjustmentFactor = 30;
            scrollView2AdjustmentFactor = 60;
            break;
        default:
            break;
    }
    
    self.scrollView2BottomConstraint.constant -= scrollView2AdjustmentFactor;
    [self.scrollView2 updateConstraints];
    
    self.scrollViewTopSpaceConstraint.constant -= scrollView1AdjustmentFactor;
    [self.scrollView1 updateConstraints];
}

- (void) customizeUI {
    //set fonts
    self.headerlabel.font               = [UIFont setRobotoFontRegularStyleWithSize:17];
    self.doneButton.titleLabel.font     = [UIFont setRobotoFontBoldStyleWithSize:14];
    
    //set text colors
    self.appLanguageLabel.textColor         = [UIColor blackColorwithLightOpacity];
    self.speakingLanguageLabel.textColor    = [UIColor blackColorwithLightOpacity];
    self.multipleSelectInfoLabel.textColor  = [UIColor blackColorwithLightOpacity];
    self.lineSeparatorView.backgroundColor  = [UIColor separatorLineColor];
}

- (void) setText {
    //set text to label and buttons
    self.headerlabel.text               = _appLabel.lblSelectALanguage;
    [self.doneButton setTitle:_appLabel.btnDone forState:UIControlStateNormal];
    
    //set attributed texts
    self.appLanguageLabel.attributedText        = [self getFormattedText:_appLabel.lblLanguageOfTheApp];
    self.speakingLanguageLabel.attributedText   = [self getFormattedText:_appLabel.lblLanguageYouSpeak];
    self.multipleSelectInfoLabel.attributedText = [self getFormattedText:_appLabel.lblSelectMoreThanOne];
}

#pragma mark - Button Actions

- (IBAction)backButtonTapped:(id)sender {
    if(!self.backButton.hidden) {
      [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)doneButtonTapped:(id)sender {
    [self updateUserLanguage];
}

- (void)languageAppGestureRecogized:(UITapGestureRecognizer*)sender {
    //app language selection changed
    KCLanguageOptionView *selectedlanguageOptionView = [self.appLanguageViewsArray objectAtIndex:_selectedAppLanguageIndex];
    [self setView:selectedlanguageOptionView.langugeSelectedBoxImageView hidden:YES];
    _selectedAppLanguageIndex = sender.view.tag;
    selectedlanguageOptionView = [self.appLanguageViewsArray objectAtIndex:_selectedAppLanguageIndex];
    [self setView:selectedlanguageOptionView.langugeSelectedBoxImageView hidden:NO];
    KCSupportedLanguage *appLanguage = [_supportedLanguage.allSupportedLanguageArray objectAtIndex:_selectedAppLanguageIndex];
    self.selectedAppLanguage = appLanguage.languageID;
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"language_app"
         properties:@{@"preferred_language":appLanguage.languageName}];
    [self.scrollView1 scrollRectToVisible:CGRectMake(_flagContainerViewWidth*sender.view.tag, 0, _flagContainerViewWidth, 20) animated:YES];
}

- (void) speakingLanguageGestureRecogized:(UITapGestureRecognizer*)sender {
    //user speaking language selection changed
    KCLanguageOptionView *selectedlanguageOptionView = [self.speakingLanguageViewsArray objectAtIndex:sender.view.tag];
    KCSupportedLanguage *appLanguage = [_supportedLanguage.allSupportedLanguageArray objectAtIndex:sender.view.tag];
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"language_speak"
         properties:@{@"preferred_language":appLanguage.languageName}];
    if(selectedlanguageOptionView.langugeSelectedBoxImageView.isHidden) {
        //select a language
        [self.selectedSpeakingLanguageOptionsArray addObject:appLanguage.languageID];
        [self setView:selectedlanguageOptionView.langugeSelectedBoxImageView hidden:NO];
    }
    else {
        //deselect a language
        [self.selectedSpeakingLanguageOptionsArray  removeObject:appLanguage.languageID];
        [self setView:selectedlanguageOptionView.langugeSelectedBoxImageView hidden:YES];
    }
    
    [self.scrollView2 scrollRectToVisible:CGRectMake(_flagContainerViewWidth*sender.view.tag, 0, _flagContainerViewWidth, 20) animated:YES];
}

#pragma mark - Animate View

- (void)setView:(UIView*)view hidden:(BOOL)hidden {
    [UIView transitionWithView:view duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^(void){
        [view setHidden:hidden];
    } completion:nil];
}

#pragma mark - Instance Methods

- (void) pushNextViewController {
    if(self.shouldNavigateBack) {
        // Go to Setting ViewController
        [self.navigationController popViewControllerAnimated:YES];
        
        // Chnage default language
        KCBottomBar *bottomBar = [KCBottomBar bottomBar];
        // Update text after language change
        [bottomBar setText];
    }
    else {
        // Push the main menu view controller
        UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:kHomeViewController];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (NSAttributedString*)getFormattedText:(NSString*)text {
    if(text) {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
        NSDictionary *boldStyle = @{NSFontAttributeName:[UIFont setRobotoFontBoldStyleWithSize:15]};
        NSDictionary *italicsStyle = @{NSFontAttributeName:[UIFont setRobotoFontItalicStyleWithSize:15]};
        NSRange range = NSMakeRange(0, attributedString.length);
        [attributedString setAttributes:boldStyle range:range];
        [attributedString setAttributes:italicsStyle range:range];
        return attributedString;
    }
    return nil;
}

#pragma mark - Server End Code

- (void) fetchSupportedLanguageFromServer {
    //get supported language from server
    if(isNetworkReachable) {
        if(!_appLanguageWebManger) {
            _appLanguageWebManger = [KCAppLanguageWebManager new];
        }
        NSDictionary *params = @{kUserID:_userProfile.userID};
        [_appLanguageWebManger getSupportedLanguagesWithParameters:params andCompletionHandler:^(KCSupportedLanguage *supportedLanguage) {
            // Request finished with success
            _supportedLanguage = supportedLanguage;
            if(_supportedLanguage.allSupportedLanguageArray && [_supportedLanguage.allSupportedLanguageArray count] > 0) {
                [self addSpeakingLanguageOptions];
                [self addAppLanguageOptions];
            }
        } andFailure:^(NSString *title, NSString *message) {
            // Request failed
            [KCUIAlert showAlertWithButtonTitle:AppLabel.btnRetry alertHeader:title message:message withButtonTapHandler:^(BOOL positiveButton){
                if(positiveButton) {
                    [self fetchSupportedLanguageFromServer];
                }
            }];
        }];
    }
    else {
        //show alert for no internet connection
        [KCUIAlert showAlertWithButtonTitle:AppLabel.btnRetry alertHeader:AppLabel.errorTitle message:AppLabel.internetNotAvailable withButtonTapHandler:^(BOOL positiveButton){
            if(positiveButton) {
               [self fetchSupportedLanguageFromServer];
            }
        }];
    }
}

- (void) fetchAppLabels {
    //fetch app label from server and save to local database
    __weak id weakSelf = self;
    KCAppLanguageWebManager *appLanguageWebManager = [[KCAppLanguageWebManager alloc] init];
    [appLanguageWebManager getAppLabelsForLanguage:_userProfile.languageID withCompletionHandler:^(KCSupportedLanguage *supportedLanguage) {
        //languge preference saved, go to next view controller
        [weakSelf pushNextViewController];
    } andFailureBlock:^(NSString *title, NSString *message) {
       [KCUIAlert showInformationAlertWithHeader:title message:message withButtonTapHandler:^{
           
       }];
    }];
}

- (void) updateUserLanguage {
    if([self.selectedSpeakingLanguageOptionsArray count] == 0) {
        [KCUIAlert showInformationAlertWithHeader:AppLabel.errorTitle message:AppLabel.speakingLanguageNotSelected withButtonTapHandler:^{
            
        }];
    }
    else if(!isNetworkReachable) {
        [KCUIAlert showInformationAlertWithHeader:AppLabel.errorTitle message:AppLabel.internetNotAvailable withButtonTapHandler:^{
            
        }];
    }
    else {
        KCAppLanguageWebManager *appLanguageWebManager = [[KCAppLanguageWebManager alloc] init];
        NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                                _userProfile.userID      , kUserID,
                                self.selectedAppLanguage , kAppLanguage,
                                self.selectedSpeakingLanguageOptionsArray, kSpeakingLanguage
                                , nil];
        [appLanguageWebManager updateAppLanguagePreference:params WithCompletionHandler:^(NSDictionary *response) {
            _userProfile.languageID = self.selectedAppLanguage;
            defaultLanguage         = self.selectedAppLanguage;
            [self fetchAppLabels];
        } andFailure:^(NSString *title, NSString *message) {
            [KCUIAlert showInformationAlertWithHeader:title message:message withButtonTapHandler:^{
                
            }];
        }];
    }
}

@end
