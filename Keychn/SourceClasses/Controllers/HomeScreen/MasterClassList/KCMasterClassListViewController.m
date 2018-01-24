//
//  KCMasterClassListViewController.m
//  Keychn
//
//  Created by Rohit on 23/08/17.
//  Copyright © 2017 Keychn Experience. All rights reserved.
//

#import "KCMasterClassListViewController.h"
#import "KCMasterClassListTableViewCell.h"
#import "KCUserScheduleWebManager.h"
#import "KCUserScheduleDBManager.h"
#import "KCGroupSession.h"
#import "KCMasterClassViewController.h"
#import "KCGroupSessionWebManager.h"
#import "IAPSubscription.h"
#import "KCSubscription.h"
#import "KCMySchedule.h"
#import "KCGroupSessionHostEndViewController.h"
#import "KCGroupSessionGuestEndViewController.h"
#import "EventStore.h"

@interface KCMasterClassListViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate> {
    NSInteger _cellHeight;
    NSInteger _fontSize;
    IOSDevices _currentDevice;
    KCUserScheduleWebManager *_userScheduleWebManager;
    KCUserProfile            *_userProfile;
    NSString                 *_searchKeyword;
    KCGroupSessionWebManager    *_groupSessionManager;
    IAPSubscription         *_iapSubscription;
    KCSubscription          *_subscriptionAlertView;
    KCUserScheduleDBManager *_userScheduleDBManager;
    KCMySchedule            *_masterClassToJoin;
    UIRefreshControl        *_refreshControl;
}
@property (weak, nonatomic) IBOutlet UITableView *masterclassListTableView;
@property (weak, nonatomic) IBOutlet UILabel *learnWithChefLabel;
@property (weak, nonatomic) IBOutlet UILabel *liveMasterclassLabel;
@property (weak, nonatomic) IBOutlet UIView *redRoundView;
@property (weak, nonatomic) IBOutlet UIView *searchContainerView;
@property (weak, nonatomic) IBOutlet UITextField *searchMasterclassTextField;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

#pragma mark - Datasource Array
@property (strong, nonatomic) NSMutableArray<KCGroupSession*> *allmasterclassListArray;
@property (strong, nonatomic) NSMutableArray<KCGroupSession*> *searchResultArray;
@property (strong, nonatomic) NSMutableArray<KCGroupSession*> *datasourceArray;

#define kBaseHeight  294
#define kBaseWidth   375


@end

@implementation KCMasterClassListViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.redRoundView.layer.cornerRadius = self.redRoundView.bounds.size.width/2;
    self.redRoundView.layer.masksToBounds = YES;
    
    // Get Instances
    _userProfile            = [KCUserProfile sharedInstance];
    _userScheduleWebManager = [KCUserScheduleWebManager new];
    _groupSessionManager    = [KCGroupSessionWebManager new];
    _userScheduleDBManager  = [KCUserScheduleDBManager new];
    _refreshControl         = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self action:@selector(refreshControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.masterclassListTableView setRefreshControl:_refreshControl];
    _refreshControl.tintColor = [UIColor appBackgroundColor];
    
    _currentDevice               = [KCUtility getiOSDeviceType];
    if(_currentDevice == iPad) {
        _cellHeight = 450;
    }
    else if (_currentDevice == iPhoneX) {
        _cellHeight = 310;
    }
    else {
        NSInteger apsectRatio        = kBaseWidth/kBaseHeight;
        float widthDifference        = CGRectGetWidth(self.view.frame) - kBaseWidth;
        float aspectRatioDifference  = widthDifference/apsectRatio;
        _cellHeight                  = kBaseHeight + aspectRatioDifference;
    }
    _fontSize                        = [self fontSizeForMasterChefName];
    
    // Request for iCalendar permission
    EventStore *store = [EventStore new];
    [store askPermissionForEvent];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Fetch Masteclass
    [self requestMasterClass];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.searchContainerView.hidden = YES;
    [self.searchMasterclassTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Datasource and Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.datasourceArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KCMasterClassListTableViewCell *masterClassTableCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierForMasterClassList forIndexPath:indexPath];
    // Configure Masterclass Cell
    masterClassTableCell.masterchefFirstNameLabel.font = [UIFont setRobotoFontBoldStyleWithSize:_fontSize];
     masterClassTableCell.masterchefLastNameLabel.font = [UIFont setRobotoFontBoldStyleWithSize:_fontSize];
    masterClassTableCell.contentView.backgroundColor   = [UIColor clearColor];
    masterClassTableCell.backgroundColor               = [UIColor clearColor];
    masterClassTableCell.masterclassDetailButton.tag   = indexPath.row;
    masterClassTableCell.attendButton.tag              = indexPath.row;
    // Configure cell for Masterclass
    if([self.datasourceArray count] > indexPath.row) {
        KCGroupSession *masterClass = [self.datasourceArray objectAtIndex:indexPath.row];
        masterClassTableCell.masterchefLastNameLabel.text  = [[KCUtility getLastNameFromFullName:masterClass.chefName] uppercaseString];
        masterClassTableCell.masterchefFirstNameLabel.text = [KCUtility getFirstNameFromFullName:[masterClass.chefName uppercaseString]];
        NSTimeInterval timeInterval = [NSDate getSecondsFromDate:masterClass.scheduleDate] + [NSDate getGMTOffSet];
        NSString  *monthName        = [NSDate getMonthFromTimeInterval:timeInterval];
        NSInteger date              = [NSDate getDateFromTimeInterval:timeInterval];
        NSString  *hour             = [NSDate getHourAndMinuteFromTimeInterval:timeInterval];
        if(masterClass.isFree) {
            masterClassTableCell.freeClassLabel.hidden = false;
            masterClassTableCell.freeClassLabel.labelText = [NSLocalizedString(@"free", nil) uppercaseString];
            masterClassTableCell.freeClassLabel.labelFont = [UIFont setRobotoFontBoldStyleWithSize:14];
        }
        else {
            masterClassTableCell.freeClassLabel.hidden = true;
        }
        if(masterClass.isBooked) {
            // Active Masterclass (User can join this Masterclass immediately)
            if(masterClass.sessionID.integerValue == _masterClassToJoin.scheduleID.integerValue) {
                masterClassTableCell.attendButton.enabled  = YES;
                masterClassTableCell.attendButton.selected = YES;
                [masterClassTableCell.attendButton setTitle:[NSLocalizedString(@"startCooking", nil) uppercaseString] forState:UIControlStateSelected];
            }
            else {
                // Scheduled and Subscribed Masterclass. Will be activated when the prior to 2 minutes of scheduled date and time
                masterClassTableCell.attendButton.enabled  = NO;
                masterClassTableCell.attendButton.selected = NO;
                
                [masterClassTableCell.attendButton setTitle:[NSLocalizedString(@"attending", nil) uppercaseString] forState:UIControlStateNormal];
            }
            [masterClassTableCell.attendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [masterClassTableCell.attendButton setBackgroundColor:[UIColor appGreenColor]];
            masterClassTableCell.attendCheckmarkImageView.hidden = NO;
        }
        else {
            // Un-subscribed Masterclass (Let user request to join)
            masterClassTableCell.attendButton.enabled = YES;
            [masterClassTableCell.attendButton setTitle:[NSLocalizedString(@"attend", nil) uppercaseString] forState:UIControlStateNormal];
            [masterClassTableCell.attendButton setBackgroundColor:[UIColor appBackgroundColor]];
            [masterClassTableCell.attendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            masterClassTableCell.attendCheckmarkImageView.hidden = YES;
            masterClassTableCell.attendButton.selected = NO;
        }
    
        masterClassTableCell.dateLabel.text = [NSString stringWithFormat:@"%@ %@%@",[monthName uppercaseString], [NSNumber numberWithInteger:date],[KCUtility getValueSuffix:date]];
        masterClassTableCell.timeLabel.text = hour;
        
        // Set image url on Chef Image View
        masterClassTableCell.masterchefImageView.image = nil;
        [masterClassTableCell.masterchefImageView setImageWithURL:[NSURL URLWithString:masterClass.masterChefImageURL] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        masterClassTableCell.masterchefImageView.contentMode = UIViewContentModeScaleAspectFill;
        masterClassTableCell.masterchefImageView.clipsToBounds = YES;
    }
    
    return masterClassTableCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Go to Masterclass Detail screen
    [self openMasterclassDetaileWithIndex:indexPath.row];
}

#pragma mark - Text Field Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    // Search Masterclass
    [self searchMasterclass];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if(self.datasourceArray.count > 0) {
        self.datasourceArray = nil;
        [self.masterclassListTableView reloadData];
    }
    return YES;
}

#pragma mark - Button Action

- (IBAction)searchButtonTapped:(id)sender {
    // Open Search Masterclass
    if(self.searchContainerView.hidden) {
        // Animate SearchView to open
        Mixpanel *mixpanel = [Mixpanel sharedInstance];
        [mixpanel track:@"masterclass_list_search_icon"
             properties:@{@"":@""}];
        
        self.searchContainerView.hidden = NO;
        CATransition* transition = [CATransition animation];
        transition.duration = 0.6;
        transition.type = kCATransitionMoveIn;
        transition.subtype = kCATransitionFromRight;
        [transition setTimingFunction: [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [self.searchContainerView.layer addAnimation:transition forKey:kCATransition];
    }
    else {
        // Search Masterclass
        [self searchMasterclass];
    }
}

- (IBAction)masterclassDetailButtonTapped:(UIButton *)sender {
    // Go to Masterclass Detail screen
    [self openMasterclassDetaileWithIndex:sender.tag];
}

- (IBAction)attendButtonTapped:(UIButton *)sender {
    // Purchase Masterclass request
    if(sender.isSelected) {
        // Let the user join Masterclass
        [self startGroupSession];
    }
    else {
        KCGroupSession *groupSession = [self.datasourceArray objectAtIndex:sender.tag];
        _iapSubscription        = [IAPSubscription subscriptionForUser:_userProfile.userID];
        
        if(!(groupSession.isFree || _iapSubscription)) {
            // The masterclass has paid subscription and user hasn't purhchased one
            _subscriptionAlertView = [[KCSubscription alloc] initWithFrame:self.view.frame];
            [_subscriptionAlertView showInView:self.tabBarController.navigationController.view withCompletionHandler:^(BOOL postiveButton) {
                
            }];
            Mixpanel *mixpanel = [Mixpanel sharedInstance];
            [mixpanel track:@"user_subscription_open_view"
                 properties:@{@"": @""}];
        }
        else {
            // Book a Masterclass (Either this Masterclass is free or user has purchased this subscription)
            [self requestAttendMasterclassWithIndex:sender.tag];
        }
    }
}

- (IBAction)doneButtonTapped:(id)sender {
    [self.searchMasterclassTextField resignFirstResponder];
    CATransition* transition = [CATransition animation];
    transition.duration = 0.6;
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromLeft;
    [transition setTimingFunction: [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [self.searchContainerView.layer addAnimation:transition forKey:kCATransition];
    [UIView animateWithDuration:0.6 animations:^{
        self.searchContainerView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        self.searchContainerView.alpha = 1.0f;
        self.searchContainerView.hidden = YES;
    }];
    
    self.datasourceArray = self.allmasterclassListArray;
    [self.masterclassListTableView reloadData];
    _searchKeyword = nil;
    self.searchMasterclassTextField.text = nil;
}

#pragma mark - Utility 

- (void)startGroupSession {
    // Start Group Session 1:N
    if(_masterClassToJoin.isHosting) {
        KCGroupSessionHostEndViewController *gsHostEndViewController = [self.storyboard instantiateViewControllerWithIdentifier:hostEndSessionViewController];
        gsHostEndViewController.conferenceID   = _masterClassToJoin.conferenceID;
        gsHostEndViewController.groupSessionID = _masterClassToJoin.scheduleID;
        [self.navigationController pushViewController:gsHostEndViewController animated:YES];
    }
    else {
        KCGroupSessionGuestEndViewController *gsGuestEndViewController = [self.storyboard instantiateViewControllerWithIdentifier:guestEndSessionViewController];
        gsGuestEndViewController.conferenceID    = _masterClassToJoin.conferenceID;
        gsGuestEndViewController.hostName        = _masterClassToJoin.secondUsername;
        gsGuestEndViewController.sessionID       = _masterClassToJoin.scheduleID;
        gsGuestEndViewController.chefUserID      = _masterClassToJoin.secondUserID;
        UserRole role                            = _masterClassToJoin.isListner ? Listner : Speaker;
        gsGuestEndViewController.role            = role;
        [self.navigationController pushViewController:gsGuestEndViewController animated:YES];
    }
}

- (NSInteger)fontSizeForMasterChefName {
    NSInteger fontSize = 55;
    switch (_currentDevice) {
        case iPad:
            fontSize = 80;
            break;
        case iPhoneX:
            fontSize = 70;
            break;
        case iPhone6Plus:
            fontSize = 75;
            break;
        case iPhone6:
            fontSize = 70;
            break;
        case iPhone5:
            fontSize = 36;
            break;
        case iPhone4:
            fontSize = 19;
            break;
        default:
            break;
    }
    return fontSize;
}

- (void)openMasterclassDetaileWithIndex:(NSInteger)index {
    // Open Masterclass Detail page
    KCGroupSession *masterClass = [self.datasourceArray objectAtIndex:index];
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"masterclass_list_photo"
         properties:@{@"masterclass_id":masterClass.sessionID, @"chef_name":masterClass.chefName}];
    
    KCMasterClassViewController *masterClassController = [self.storyboard instantiateViewControllerWithIdentifier:masterClassViewController];
    masterClassController.masterClassID     = masterClass.sessionID;
    masterClassController.hasPurhcased      = masterClass.isBooked;
    masterClassController.groupSession      = masterClass;
    [self.navigationController pushViewController:masterClassController animated:YES];
}


- (void)refreshControlValueChanged:(UIRefreshControl *)sender {
    [self requestMasterClass];
}

- (void)scrollListToTop {
    // When home button is tapped and Home screen is showing
    if (self.datasourceArray.count > 0) {
        [self.masterclassListTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

- (void)searchMasterclass {
    [_searchMasterclassTextField resignFirstResponder];
    _searchKeyword = [self.searchMasterclassTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if(_searchKeyword.length > 0) {
        Mixpanel *mixpanel = [Mixpanel sharedInstance];
        [mixpanel track:@"masterclass_list_search_submit"
             properties:@{@"search_value":_searchKeyword}];
        [self requestMasterClass];
    }
}

#pragma mark - Timer Check

- (void)getUserSchedule {
    // Get User schedule and trigger for any current schedule
    NSTimeInterval firstSchedule = [_userScheduleDBManager getNextInteractionSchedule];
    if(firstSchedule > 0) {
        // Find the difference from current time
        NSTimeInterval currentTimeInterval = [[NSDate date] timeIntervalSince1970];
        NSTimeInterval difference          =  firstSchedule - currentTimeInterval;
        [NSThread cancelPreviousPerformRequestsWithTarget:self];
        if(difference > kBufferTimeForCallStart) {
            difference -= kBufferTimeForCallStart;
           [self performSelector:@selector(refreshUserSchedule) withObject:nil afterDelay:difference];
        }
        else {
            [self refreshUserSchedule];
        }
    }
}

- (void)refreshUserSchedule {
    // Refresh table view
    if([self.masterclassListTableView numberOfRowsInSection:0] > 0) {
        [self.masterclassListTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    _masterClassToJoin = [_userScheduleDBManager getNextInteraction];
    [self.masterclassListTableView reloadData];
}

#pragma mark - Request Completion

- (void)masterclassFetchedWithResponse:(NSDictionary *)response {
    // Masterclass fetched, reload table
    NSArray *resultArray = [response objectForKey:kResult];
    [_refreshControl endRefreshing];
    if([resultArray isKindOfClass:[NSArray class]] && [resultArray count] > 0) {
        NSMutableArray *masterclassResults = [[NSMutableArray alloc] init];
        @autoreleasepool {
            for (NSDictionary *masterclassDictionary in resultArray) {
                KCGroupSession *masterclassSession = [[KCGroupSession alloc] initWithResponse:masterclassDictionary];
                [masterclassResults addObject:masterclassSession];
            }
        }
        
        self.datasourceArray = masterclassResults;
        
        if(_searchKeyword.length == 0) {
            self.allmasterclassListArray = self.datasourceArray;
        }
        
        // Get Next Interaction and refresh tableview 2 minutes prior to the scheduled date and time
        [self getUserSchedule];
    }
    else {
        self.datasourceArray = nil;
    }
    
    // Refresh Table View
    [self.masterclassListTableView reloadData];
}

- (void)didPurchaseMasterClassWithIndex:(NSInteger)index {
    // Called when MasterClass purchased successfully
    if([self.datasourceArray count] > index) {
        KCGroupSession *groupSession = [self.datasourceArray objectAtIndex:index];
        groupSession.isBooked        = YES;
        if(self.datasourceArray != self.allmasterclassListArray) {
            NSPredicate *predicate       = [NSPredicate predicateWithFormat:@"SELF.sessionID.integerValue == %d", groupSession.sessionID.integerValue];
            KCGroupSession *groupSessionInAllArray = [[self.allmasterclassListArray filteredArrayUsingPredicate:predicate] firstObject];
            groupSessionInAllArray.isBooked        = YES;
        }
    }
    [self.masterclassListTableView reloadRowsAtIndexPaths:self.masterclassListTableView.indexPathsForVisibleRows withRowAnimation:UITableViewRowAnimationAutomatic];
    
    // Refresh user schedule silently
    NSDictionary *params = @{kUserID:_userProfile.userID, kAcessToken:_userProfile.accessToken, kCurrentDate:[NSDate getCurrentDateInUTC]};
    [_userScheduleWebManager refreshUseScheduleWithParameters:params];
}

- (void)endRefreshing {
    [_refreshControl endRefreshing];
}

#pragma mark - Web Request

- (void)requestMasterClass {
    // Server request to fetch MasterClass
    // If Masterclass is alredy being fetched then don't intiate a request.
    static BOOL isProcessing = NO;
    if (isProcessing) {
        return;
    }
    isProcessing = YES;
    if (self.datasourceArray.count == 0) {
        [KCProgressIndicator showNonBlockingIndicator];
    }
    __weak id weakSelf = self;
    NSMutableDictionary *params = [@{kUserID:_userProfile.userID, kAcessToken:_userProfile.accessToken, kCurrentDateAndTime:[NSDate getCurrentDateInUTCWithFormat:kMasterclassDateFormat]} mutableCopy];
    if(_searchKeyword.length > 0) {
        [params setObject:_searchKeyword forKey:kSearchKeyword];
    }
    [_userScheduleWebManager getMasterClassWithParameter:params withCompletionHandler:^(NSDictionary *responseDictionary) {
        // Request completed with response
        isProcessing = NO;
        [KCProgressIndicator hideActivityIndicator];
        [weakSelf masterclassFetchedWithResponse:responseDictionary];
    } andFailure:^(NSString *title, NSString *message) {
        // Request failed, present retry options
        [weakSelf endRefreshing];
        isProcessing = NO;
        if(isNetworkReachable) {
            [weakSelf requestMasterClass];
        }
        else {
            [KCProgressIndicator hideActivityIndicator];
            [KCUIAlert showAlertWithButtonTitle:NSLocalizedString(@"retry", nil) alertHeader:NSLocalizedString(@"networkError", nil) message:NSLocalizedString(@"tryReconnecting", nil) withButtonTapHandler:^(BOOL positiveButton) {
                if(positiveButton) {
                    // Retry if user says
                    [weakSelf requestMasterClass];
                }
            }];
        }
        
    }];
}

- (void)requestAttendMasterclassWithIndex:(NSInteger)index {
    // Request to attend a Masterclass
    if(isNetworkReachable) {
        __block NSInteger requestedMasterclassIndex = index;
        KCGroupSession *groupSession = [self.datasourceArray objectAtIndex:index];
        Mixpanel *mixpanel = [Mixpanel sharedInstance];
        [mixpanel track:@"masterclass_list_attend_button"
             properties:@{@"masterclass_id":groupSession.sessionID, @"chef_name":groupSession.chefName}];
        [KCProgressIndicator showProgressIndicatortWithText:NSLocalizedString(@"bookASlot", nil)];
        NSDictionary *params = @{kUserID:_userProfile.userID, kAcessToken:_userProfile.accessToken, kMasterClassID:groupSession.sessionID, kIsFree: [NSNumber numberWithBool:groupSession.isFree]};
        __weak KCMasterClassListViewController *weakSelf = self;
        [_groupSessionManager buyMasterClassSpotWithParameter:params withCompletionHandler:^(NSString *title, NSString *message) {
            // Request completed with success
            [KCProgressIndicator hideActivityIndicator];
            [KCUIAlert showInformationAlertWithHeader:NSLocalizedString(@"congrats", nil) message:NSLocalizedString(@"beReadyForMasterclass", nil) withButtonTapHandler:^{
                
            }];
            
            // Masterclass slot requested
            [weakSelf didPurchaseMasterClassWithIndex:requestedMasterclassIndex];
            
        } andFailure:^(NSString *title, NSString *message) {
            // Request failed with error
            [KCProgressIndicator hideActivityIndicator];
            [KCUIAlert showInformationAlertWithHeader:title message:message withButtonTapHandler:^{
                
            }];
            
        }];
        
    }
    else {
        [KCUIAlert showInformationAlertWithHeader:NSLocalizedString(@"networkError", nil) message:NSLocalizedString(@"tryReconnecting", nil) withButtonTapHandler:^{
            
        }];
    }
}

@end
