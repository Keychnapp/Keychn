//
//  RecordedMasterclassViewController.m
//  Keychn
//
//  Created by Rohit Kumar on 12/05/2018.
//  Copyright © 2018 Keychn Experience. All rights reserved.
//

#import "RecordedMasterclassViewController.h"
#import "RecordedMasterclassTableViewCell.h"
#import "KCUserScheduleWebManager.h"
#import "MasterclassVideo.h"
#import "KCMasterchefViewController.h"
#import "MasterclassDetailViewController.h"


#define kBaseHeight  230
#define kBaseWidth   375

@interface RecordedMasterclassViewController () <UITableViewDataSource, UITableViewDelegate> {
    CGFloat _cellHeight;
    IOSDevices _currentDevice;
    KCUserProfile            *_userProfile;
    KCUserScheduleWebManager *_userScheduleWebManager;
    UIRefreshControl        *_refreshControl;
    NSInteger               _currentPage;
}

@property (weak, nonatomic) IBOutlet UITableView *masterclassVaultTableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) NSMutableArray *masterclasses;

@end

@implementation RecordedMasterclassViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _currentDevice   = [KCUtility getiOSDeviceType];
    if(_currentDevice == iPad) {
        _cellHeight = 390;
    }
    else if (_currentDevice == iPhoneX) {
        _cellHeight = kBaseHeight;
    }
    else {
        NSInteger apsectRatio        = kBaseWidth/kBaseHeight;
        float widthDifference        = CGRectGetWidth(self.view.frame) - kBaseWidth;
        float aspectRatioDifference  = widthDifference/apsectRatio;
        _cellHeight                  = kBaseHeight + aspectRatioDifference;
    }
    
    // Get Instances
    _userProfile            = [KCUserProfile sharedInstance];
    _userScheduleWebManager = [KCUserScheduleWebManager new];
    _currentPage            = 0;
    
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self action:@selector(refreshControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.masterclassVaultTableView setRefreshControl:_refreshControl];
    _refreshControl.tintColor = [UIColor appBackgroundColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Fetch Masterclass videos
    [self requestMasterClass];
}

#pragma mark - IB Action

- (IBAction)openMasterclassProfileButtonTapped:(UIButton *)sender {
    if (self.masterclasses.count > sender.tag) {
        MasterclassVideo *masterclass = [self.masterclasses objectAtIndex:sender.tag];
        KCMasterchefViewController *masterchefViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"KCMasterchefViewController"];
        masterchefViewController.selectedMasterclass = masterclass;
        [self.navigationController pushViewController:masterchefViewController animated:true];
    }
}

- (void)refreshControlValueChanged:(UIRefreshControl *)sender {
    [self requestMasterClass];
}

#pragma mark - Utility

- (void)endRefreshing {
    [_refreshControl endRefreshing];
    [self.activityIndicator stopAnimating];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    return NO;
}


#pragma mark - TableView Datasource and Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.masterclasses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RecordedMasterclassTableViewCell *masterclassTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"RecordedMasterclassTableViewCell" forIndexPath:indexPath];
    masterclassTableViewCell.masterchefButton.tag = indexPath.row;
    if (self.masterclasses.count > indexPath.row) {
        MasterclassVideo *masterclass = [self.masterclasses objectAtIndex:indexPath.row];
        masterclassTableViewCell.masterclassTitleLabel.text = masterclass.videoName;
        [masterclassTableViewCell.masterchefImageView setImageWithURL:[NSURL URLWithString:masterclass.chefImageURL] placeholderImage:[UIImage imageNamed:@"masterclass_leaf"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [masterclassTableViewCell.masterclassImageView setImageWithURL:[NSURL URLWithString:masterclass.placeholderImageURL] placeholderImage:nil usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    return masterclassTableViewCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.masterclasses.count > indexPath.row) {
        // Go to Masterclass Details screen
        MasterclassVideo *masterclass = [self.masterclasses objectAtIndex:indexPath.row];
        MasterclassDetailViewController *masterclassVideoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MasterclassDetailViewController"];
        masterclassVideoViewController.selectedVideo = masterclass;
        [self.navigationController pushViewController:masterclassVideoViewController animated:YES];
    }
}

#pragma mark - Web Request

- (void)requestMasterClass {
    // Server request to fetch MasterClass Videos
    // If Masterclass is alredy being fetched then don't intiate a request.
    static BOOL isProcessing = NO;
    if (isProcessing) {
        return;
    }
    isProcessing = YES;
    [self.activityIndicator startAnimating];
    __weak RecordedMasterclassViewController *weakSelf = self;
    NSDictionary *params = @{kUserID:_userProfile.userID, kAcessToken:_userProfile.accessToken, kPageIndex: @(_currentPage)};
    [_userScheduleWebManager getMasterClassVideoWithParameter:params withCompletionHandler:^(NSDictionary *responseDictionary) {
        // Request completed with response
        isProcessing = NO;
        [weakSelf masterclassFetchedWithResponse:responseDictionary];
    } andFailure:^(NSString *title, NSString *message) {
        // Request failed, present retry options
        [weakSelf endRefreshing];
        isProcessing = NO;
        if(isNetworkReachable) {
            [weakSelf requestMasterClass];
        }
        else {
            [KCUIAlert showAlertWithButtonTitle:NSLocalizedString(@"retry", nil) alertHeader:NSLocalizedString(@"networkError", nil) message:NSLocalizedString(@"tryReconnecting", nil) withButtonTapHandler:^(BOOL positiveButton) {
                if(positiveButton) {
                    // Retry if user says
                    [weakSelf requestMasterClass];
                }
            }];
        }
        
    }];
}

#pragma mark - Request Completion

- (void)masterclassFetchedWithResponse:(NSDictionary *)response {
    // Masterclass fetched, reload table
    NSArray *resultArray = [response objectForKey:kItemDetails];
    [_refreshControl endRefreshing];
    [self.activityIndicator stopAnimating];
    if([resultArray isKindOfClass:[NSArray class]] && [resultArray count] > 0) {
        NSMutableArray *masterclassResults = [[NSMutableArray alloc] init];
        @autoreleasepool {
            for (NSDictionary *masterclassDictionary in resultArray) {
                MasterclassVideo *masterclassVideo = [[MasterclassVideo alloc] initWithResponse:masterclassDictionary];
                [masterclassResults addObject:masterclassVideo];
            }
        }
        
        self.masterclasses = masterclassResults;
        
    }
    else {
        self.masterclasses = nil;
    }
    
    // Refresh Table View
    [self.masterclassVaultTableView reloadData];
}

@end
