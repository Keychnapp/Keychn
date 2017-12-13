//
//  KCMyScheduleViewController.m
//  Keychn
//
//  Created by Keychn Experience SL on 04/01/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import "KCMyScheduleViewController.h"
#import "KCCalendarView.h"
#import "KCMyScheduleTableViewCell.h"
#import "KCUserScheduleDBManager.h"
#import "KCMySchedule.h"
#import "KCPlaceholderImage.h"
#import "UIImageView+AFNetworking.h"
#import "KCUserScheduleWebManager.h"
#import "KCItemDetailsViewController.h"
#import "KCItem.h"
#import "KCGroupSessionGuestEndViewController.h"
#import "KCGroupSessionHostEndViewController.h"
#import "EventStore.h"

@interface KCMyScheduleViewController () <UITableViewDataSource, UITableViewDelegate> {
    
    NSMutableArray *_calendarViewArray;
    KCUserScheduleDBManager  *_userScheduleDBManager;
    KCUserProfile            *_userProfile;
    KCPlaceholderImage       *_placeholderImage;
    KCUserScheduleWebManager *_userScheduleWebManager;
    NSInteger                _startDate;
    NSTimer                  *_scheduleUpdateTimer;
    NSArray                  *_weekDates;
    NSInteger                _cellIndexToBeDeleted;
    BOOL                     _shouldReloadData;
    KCMySchedule             *_masterClassToJoin;
    EventStore               *_eventStore;
}

typedef NS_ENUM(NSUInteger, CellUtilityButtonIndex) {
    rescheduleButton,
    cancelButton,
    
};

@property (weak, nonatomic) IBOutlet UIView *calendarView;
@property (strong, nonatomic) IBOutlet UILabel *currentMonthLabel;
@property (strong, nonatomic) IBOutlet UITableView *myScheduleTableView;
@property (strong, nonatomic) IBOutlet UIView *seperatorView;
@property (strong, nonatomic) IBOutlet UIView *seperatoViewTop;
@property (strong,nonatomic) NSMutableArray   *myScheduleArray;
@property (weak, nonatomic) IBOutlet UIView *noScheduleView;
@property (weak, nonatomic) IBOutlet UIView *bottomSeparatorView;
@property (weak, nonatomic) IBOutlet UILabel *addMasterclassLabel;
@property (weak, nonatomic) IBOutlet UILabel *noInteractionLabel;

@end

@implementation KCMyScheduleViewController

#pragma mark - Life Cycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Get Intances
    _userProfile                = [KCUserProfile sharedInstance];
    _placeholderImage           = [KCPlaceholderImage sharedInstance];
    _userScheduleWebManager     = [KCUserScheduleWebManager new];
    _userScheduleDBManager      = [KCUserScheduleDBManager new];
    _shouldReloadData           = YES;
    _eventStore                 = [EventStore new];
    
    // Customize UI according to the app theme
    [self customizeUI];
    
    // Request for iCalendar permission
    [_eventStore askPermissionForEvent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Add a calendar view
    [self addCalendar];
    
    // Fetch Myschedules from server
    [self fetchMySchedule];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [KCProgressIndicator hideActivityIndicator];
}

#pragma mark - Add Calendar

- (void)addCalendar {
    // A calendar will be added to show the current week's date and to show the scheduled events
    if(!_calendarViewArray) {
        _calendarViewArray = [[NSMutableArray alloc] init];
        NSInteger viewWidth = 0;
        if([KCUtility getiOSDeviceType] == iPad) {
            viewWidth = 350;
        }
        else {
            viewWidth = CGRectGetWidth(self.view.frame);
        }
        
        NSInteger widthFactor  = viewWidth/7;
        NSArray *weekDays      = [NSDate getShortWeekDayNamesByCurrentDate];
        _weekDates             = [NSDate getWeekDates];
        _startDate             = [[_weekDates firstObject] integerValue];
        for(int i=0; i<7;i++) {
            KCCalendarView *calendarCellView = [[KCCalendarView alloc] initWithFrame:CGRectMake(i*widthFactor, 0, widthFactor, 65)];
            [_calendarViewArray addObject:calendarCellView];
            [self.calendarView addSubview:calendarCellView];
            calendarCellView.roundView.layer.cornerRadius = 3;
            if(i== 0) {
                calendarCellView.dateButton.layer.cornerRadius = CGRectGetWidth(calendarCellView.dateButton.frame)/2;
                calendarCellView.dateButton.layer.masksToBounds = YES;
                calendarCellView.dateButton.backgroundColor = [UIColor appBackgroundColor];
            }
            
            calendarCellView.roundView.hidden           = YES;
            calendarCellView.dateButton.tag             = i;
            
            // Set texts
            [calendarCellView.dateButton setTitle: [NSString stringWithFormat:@"%@", [_weekDates objectAtIndex:i]] forState:UIControlStateNormal];
            calendarCellView.dayLabel.text  = [weekDays objectAtIndex:i];
            
            // Set text fonts
            calendarCellView.dateButton.titleLabel.font  = [UIFont setRobotoFontRegularStyleWithSize:16];
            [calendarCellView.dateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            calendarCellView.dayLabel.font   = [UIFont setRobotoFontRegularStyleWithSize:14];
        }
    }
}

#pragma mark - Table View Datasource and Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.myScheduleArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 81;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KCMyScheduleTableViewCell *myscheduleTableCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierForMySchedule forIndexPath:indexPath];
    
    if([self.myScheduleArray count] > indexPath.row) {
        KCMySchedule *mySchedule = [self.myScheduleArray objectAtIndex:indexPath.row];
        [myscheduleTableCell.itemTitleButton setTitle:[NSLocalizedString(@"masterclass", nil) uppercaseString] forState:UIControlStateNormal];
            [myscheduleTableCell.itemPictureImageView setImageWithURL:[NSURL URLWithString:mySchedule.itemImageURL] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
       
        // Set "Start Cooking" header X min prior to schedule
        if(mySchedule.scheduleID.integerValue == _masterClassToJoin.scheduleID.integerValue) {
            myscheduleTableCell.containerView.hidden = NO;
            myscheduleTableCell.containerView.backgroundColor = [UIColor appGreenColor];
            [myscheduleTableCell.startCookingButton setTitle:[NSLocalizedString(@"startCooking", nil) uppercaseString] forState:UIControlStateNormal];
        }
        else {
            myscheduleTableCell.containerView.hidden = YES;
        }

        
        // Set color code for schedule date
        NSInteger scheduleDate       = [NSDate getDateFromTimeInterval:mySchedule.scheduleDate];
        NSString  *dateString        = nil;
        if(scheduleDate <= 9) {
            dateString        = [NSString stringWithFormat:@"0%@",[NSNumber numberWithInteger:scheduleDate]];
        }
        else {
             dateString = [NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:scheduleDate]];
        }
        NSInteger effectivePosition            = [_weekDates indexOfObject:dateString];
        if([_calendarViewArray count] > effectivePosition) {
            KCCalendarView *calendarView = [_calendarViewArray objectAtIndex:effectivePosition];
            if(calendarView.roundView.hidden) {
                // Unhide and set color
                if(mySchedule.isOpen) {
                    calendarView.roundView.backgroundColor = [UIColor redColor];
                }
                else {
                    calendarView.roundView.backgroundColor = [UIColor greenColor];
                }
                calendarView.roundView.hidden = NO;
            }
            else if(!mySchedule.isOpen){
                 calendarView.roundView.backgroundColor = [UIColor greenColor];
            }
        }
        
        
        //Set date and time for the Schedule
        NSString *dayName        = [NSDate getDateAndMonthFromTimeInterval:mySchedule.scheduleDate];
        dayName                  = [dayName uppercaseString];
        NSString *timeInHours    = [NSDate getTimeFromTimeInterval:mySchedule.scheduleDate];
        timeInHours              = [timeInHours stringByAppendingString:@" H"];
        
        NSString *itemSchedule  = [NSString stringWithFormat:@"%@          %@",dayName, timeInHours];
        NSRange range1          = [itemSchedule rangeOfString:dayName];
        NSRange range2          = [itemSchedule rangeOfString:timeInHours];
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:itemSchedule];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont setHeleveticaBoldObliueFontWithSize:14] range:range1];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont setRobotoFontBoldStyleWithSize:14] range:range2];
        myscheduleTableCell.dayTimeLabel.attributedText = attributedString;
        myscheduleTableCell.dayTimeLabel.backgroundColor = [UIColor appBackgroundColor];
    }
    
    
    //Customize cell
    myscheduleTableCell.itemTitleButton.titleLabel.font = [UIFont setRobotoFontRegularStyleWithSize:15];
    myscheduleTableCell.itemTitleButton.titleLabel.numberOfLines = 2;
    myscheduleTableCell.itemTitleButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    myscheduleTableCell.selectionStyle = UITableViewCellSelectionStyleNone;
    myscheduleTableCell.tag      = indexPath.row;
    myscheduleTableCell.startCookingButton.tag = indexPath.row;
    
    return myscheduleTableCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Show item details for ths selected item
    if([self.myScheduleArray count] > indexPath.row) {
        KCMySchedule *mySchedule = [self.myScheduleArray objectAtIndex:indexPath.row];
        [self startGroupSessionForType:mySchedule.isHosting withConferenceID:mySchedule.conferenceID participantName:mySchedule.secondUsername particpantUserID:mySchedule.secondUserID andScheduleID:mySchedule.scheduleID timeinterval:mySchedule.scheduleDate];
    }
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete a scheduled Masterclass
        if(self.myScheduleArray.count > indexPath.row) {
            __block NSInteger cellTag = indexPath.row;
            // Cofirm user schedule cancellation
            __block KCMySchedule *mySchedule = [self.myScheduleArray objectAtIndex:cellTag];
            Mixpanel *mixpanel = [Mixpanel sharedInstance];
            [mixpanel track:@"calendar_delete_masterclass"
                 properties:@{ @"masterclass_id":mySchedule.scheduleID}];
            [KCUIAlert showAlertWithButtonTitle:NSLocalizedString(@"confirm", nil) alertHeader:NSLocalizedString(@"cancelMasterclass", nil) message:NSLocalizedString(@"confirmCancellation", nil) withButtonTapHandler:^(BOOL positiveButton) {
                // Confirmed by user, delete the schedule now
                if(positiveButton) {
                    [self cancelInteractionWithSessionID:mySchedule.scheduleID andType:mySchedule.recipeType withScheduleTime:mySchedule.scheduleDate andScheduleOpenStatus:mySchedule.isOpen];
                }
            }];
        }
    }
}


#pragma mark - Customize UI

- (void)customizeUI {
    //Customize font and color
    self.calendarView.backgroundColor        = [UIColor clearColor];
    self.currentMonthLabel.font              = [UIFont setRobotoFontRegularStyleWithSize:15];
    self.seperatorView.backgroundColor       = [UIColor separatorLineColor];
    self.seperatoViewTop.backgroundColor     = [UIColor separatorLineColor];
    self.bottomSeparatorView.backgroundColor = [UIColor separatorLineColor];
    self.myScheduleTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    // Adjust font for width and line indent
    self.noInteractionLabel.adjustsFontSizeToFitWidth                = YES;
    
    //Set text on button and labels
    self.currentMonthLabel.text        = [NSDate getCurrentMonthAndYear];
}

#pragma mark - Button Action 

- (IBAction)startCookingButtonTapped:(UIButton *)sender {
    // Allow user to join the conference 2 min before or after scheduled date time
    NSTimeInterval currentTimeInterval = [[NSDate date] timeIntervalSince1970];
    if([self.myScheduleArray count] > sender.tag) {
        KCMySchedule *mySchedule = [self.myScheduleArray objectAtIndex:sender.tag];
        Mixpanel *mixpanel = [Mixpanel sharedInstance];
        [mixpanel track:@"calendar_start_masterclass"
             properties:@{ @"masterclass_id":mySchedule.scheduleID }];
        if(mySchedule.scheduleDate - currentTimeInterval <= kBufferTimeForCallStart) {
            // Masterclass
            [self startGroupSessionForType:mySchedule.isHosting withConferenceID:mySchedule.conferenceID participantName:mySchedule.secondUsername particpantUserID:mySchedule.secondUserID andScheduleID:mySchedule.scheduleID timeinterval:mySchedule.scheduleDate];
        }
        else {
            // Show user to wait for the time
            [KCUIAlert showInformationAlertWithHeader:NSLocalizedString(@"earlyJoinMasterclass", nil) message:NSLocalizedString(@"waitForMasterclass", nil) withButtonTapHandler:^{
                
            }];
        }
    }
}


#pragma mark - Instance Methods

- (void)startGroupSessionForType:(BOOL)isHosting withConferenceID:(NSString *)conferenceID participantName:(NSString *)participantName particpantUserID:(NSNumber *)userID andScheduleID:(NSNumber *)scheduleID timeinterval:(NSTimeInterval )timeinterval {
    // Start Group Session 1:N
    if(isHosting) {
        KCGroupSessionHostEndViewController *gsHostEndViewController = [self.storyboard instantiateViewControllerWithIdentifier:hostEndSessionViewController];
        gsHostEndViewController.conferenceID        = conferenceID;
        gsHostEndViewController.groupSessionID      = scheduleID;
        gsHostEndViewController.startTimeInterval   = timeinterval;
        [self.navigationController pushViewController:gsHostEndViewController animated:YES];
    }
    else {
        KCGroupSessionGuestEndViewController *gsGuestEndViewController = [self.storyboard instantiateViewControllerWithIdentifier:guestEndSessionViewController];
        gsGuestEndViewController.conferenceID       = conferenceID;
        gsGuestEndViewController.hostName           = participantName;
        gsGuestEndViewController.sessionID          = scheduleID;
        gsGuestEndViewController.chefUserID         = userID;
        gsGuestEndViewController.startTimeInterval  = timeinterval;
        if(DEBUGGING) NSLog(@"startGroupSessionForType --> Chef ID %@",userID);
        [self.navigationController pushViewController:gsGuestEndViewController animated:YES];
    }
}


- (void)loadMySchedules {
    // Get all schedules from local database
    if(DEBUGGING) NSLog(@"loadMySchedules --> Load User schedule from local database");
    if(_shouldReloadData) {
        _shouldReloadData = NO;
        NSArray *allSchedules     =   [_userScheduleDBManager getUserSchedules];
        if([allSchedules count] > 0) {
            KCMySchedule *mySchedule = [KCMySchedule new];
            self.myScheduleArray     = [[NSMutableArray alloc] initWithArray:[mySchedule getModelsFromArray:allSchedules]];
            [self.myScheduleTableView reloadData];
            self.noScheduleView.hidden = YES;
        }
        else {
            self.noScheduleView.hidden = NO;
        }
        _shouldReloadData = YES;
        
        // Check for any Masterclass scheduled to update the UI 2 minutes prior to the schedule
        [self getUserSchedule];
    }
}


- (void)pushItemDetailsScreenWithItemName:(NSString*)name andItemID:(NSNumber*)itemID isRescheduling:(BOOL)flag scheduleID:(NSNumber*)scheduleID scheduleDate:(NSTimeInterval)scheduleDate {
    // Go to Item Details screen with item name and identifier
    KCItemDetailsViewController *itemDetailViewController  = [self.storyboard instantiateViewControllerWithIdentifier:itemDetailsViewController];
    KCItem *item             = [KCItem new];
    item.itemIdentifier      = itemID;
    item.title               = name;
    itemDetailViewController.selectedItem = item;
    itemDetailViewController.isRescedulingItem = flag;
    if(flag) {
       itemDetailViewController.scheduleID     = scheduleID;
    }
    itemDetailViewController.scheduleDate      = scheduleDate;
    [self.navigationController pushViewController:itemDetailViewController animated:YES];
}

- (void)deleteTableCellWithRowIndex:(NSInteger)index {
    // Delete the selected cell after cancelling interaction
    if([self.myScheduleArray count] > index) {
        KCMySchedule *selectedSchedule = [self.myScheduleArray objectAtIndex:index];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        
        // Delete iCalendar events too
        [_eventStore removeEventWithIdentifier:selectedSchedule.eventId];
       
        //Delete table cell
        [self.myScheduleArray removeObjectAtIndex:index];
        [self.myScheduleTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        NSArray *visibleCellIndexPaths = [self.myScheduleTableView indexPathsForVisibleRows];
        if([visibleCellIndexPaths count] > 0) {
            [self.myScheduleTableView reloadRowsAtIndexPaths:visibleCellIndexPaths withRowAnimation:UITableViewRowAnimationNone];
        }
        // Delete the interaction from local database
        [_userScheduleDBManager deleteUserSchedule:selectedSchedule];
    }
    // Hide/Show No Ineteraction View
    self.noScheduleView.hidden = [_myScheduleArray count] > 0;
    
    // Refresh user schedule silently
    NSDictionary *params = @{kUserID:_userProfile.userID, kAcessToken:_userProfile.accessToken, kLanguageID:_userProfile.languageID, kCurrentDate:[NSDate getCurrentDateInUTC]};
    [_userScheduleWebManager refreshUseScheduleWithParameters:params];
}

- (void)reloadRowsWithIndexPath:(NSIndexPath*)indexPath {
    [self.myScheduleTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
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
    if([self.myScheduleTableView numberOfRowsInSection:0] > 0) {
        [self.myScheduleTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    _masterClassToJoin = [_userScheduleDBManager getNextInteraction];
    [self.myScheduleTableView reloadData];
}


#pragma mark - Server End Code

- (void)fetchMySchedule {
    //Fetch my schedule from server
    if(isNetworkReachable) {
        __weak id weakSelf = self;
        [KCProgressIndicator showNonBlockingIndicator];
        self.noScheduleView.hidden = YES;
        NSDictionary *params = @{kUserID:_userProfile.userID, kAcessToken:_userProfile.accessToken, kLanguageID:_userProfile.languageID, kCurrentDate:[NSDate getCurrentDateInUTC]};
        [_userScheduleWebManager getMySchedulesWithParameter:params withCompletionHandler:^(NSDictionary *responseDictionary) {
            // My schedule fetched
            [KCProgressIndicator hideActivityIndicator];
            [weakSelf loadMySchedules];
        } andFailure:^(NSString *title, NSString *message) {
            if(isNetworkReachable) {
                [weakSelf fetchMySchedule];
            }
            else {
                [KCProgressIndicator hideActivityIndicator];
                [weakSelf fetchMySchedule];
            }
        }];
    }
    else {
        //Get user schedules from local database
        [self loadMySchedules];
    }
}

- (void)cancelInteractionWithSessionID:(NSNumber*)sessionID andType:(RecipeType)recipeType withScheduleTime:(NSTimeInterval)timeInterval andScheduleOpenStatus:(BOOL)status{
    // Cancels an interaction
    if(isNetworkReachable) {
        // Event tracking
        Mixpanel *mixpanel = [Mixpanel sharedInstance];
        [mixpanel track:@"calendar_delete_masterclass_confirm"
             properties:@{ @"masterclass_id":sessionID}];
        
        NSString *scheduleType = kCancelTypeUserSchedule;
        if(recipeType == chewItSession || recipeType == masterClass) {
            scheduleType = kCancelTypeGroupSession;
            timeInterval -= [NSDate getGMTOffSet];
        }
        [KCProgressIndicator showProgressIndicatortWithText:NSLocalizedString(@"cancelAMasterclass", nil)];
        NSDictionary *params = @{kUserID:_userProfile.userID, kAcessToken:_userProfile.accessToken, kLanguageID:_userProfile.languageID, kScheduleID:sessionID, kScheduleType:scheduleType, kIsScheduleOpen:[NSNumber numberWithBool:status], kScheduleTime:[NSNumber numberWithDouble:timeInterval]};
        __weak id weakSelf = self;
        [_userScheduleWebManager cancelUserSchduleWithParametes:params withCompletionHandler:^(NSDictionary *response) {
            // Scheduled cancelled successfully, update table view
            [KCProgressIndicator hideActivityIndicator];
            [weakSelf deleteTableCellWithRowIndex:_cellIndexToBeDeleted];
        } andFailure:^(NSString *title, NSString *message) {
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
