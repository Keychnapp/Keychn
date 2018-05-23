//
//  KCMasterchefViewController.m
//  Keychn
//
//  Created by Rohit Kumar on 20/05/2018.
//  Copyright © 2018 Keychn Experience. All rights reserved.
//

#import "KCMasterchefViewController.h"
#import "RecordedMasterclassTableViewCell.h"
#import "KCUserScheduleWebManager.h"
#import "MasterclassVideo.h"
#import <MXParallaxHeader/MXScrollView.h>
#import "MasterchefNameTableViewCell.h"

#define kBaseHeight  245
#define kBaseWidth   375


@interface KCMasterchefViewController () <UITableViewDataSource, UITableViewDelegate> {
    CGFloat _cellHeight;
    IOSDevices _currentDevice;
    KCUserProfile            *_userProfile;
    KCUserScheduleWebManager *_userScheduleWebManager;
    UIRefreshControl        *_refreshControl;
    NSInteger               _currentPage;
}

@property (weak, nonatomic) IBOutlet UITableView *masterclassVaultTableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *masterchefNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *aboutMasterchefLabel;
@property (weak, nonatomic) IBOutlet UIImageView *masterchefImageView;

@property (strong, nonatomic) NSMutableArray *masterclasses;

@end

@implementation KCMasterchefViewController

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
//    [self.masterclassVaultTableView setRefreshControl:_refreshControl];
    _refreshControl.tintColor = [UIColor appBackgroundColor];
    
    [self setMasterclassProfile];
    
    self.masterclassVaultTableView.parallaxHeader.view          = self.headerView;
    self.masterclassVaultTableView.parallaxHeader.height        = CGRectGetHeight(self.headerView.frame) + 40;
    self.masterclassVaultTableView.parallaxHeader.mode          = MXParallaxHeaderModeTop;
    self.masterclassVaultTableView.parallaxHeader.minimumHeight = 0;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Fetch Masterclass videos
    [self requestMasterClass];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Utility

- (void)endRefreshing {
    [_refreshControl endRefreshing];
    [self.activityIndicator stopAnimating];
}

- (void)setMasterclassProfile {
    // Set Masterclass profile
    self.masterchefNameLabel.text  = self.selectedMasterclass.chefName;
    self.aboutMasterchefLabel.text = self.selectedMasterclass.aboutChef;
    [self.masterchefImageView setImageWithURL:[NSURL URLWithString:self.selectedMasterclass.chefImageURL] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
}

#pragma mark - Button Action

- (void)refreshControlValueChanged:(UIRefreshControl *)sender {
    [self requestMasterClass];
}

- (IBAction)backButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
}

#pragma mark - TableView Datasource and Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.masterclasses.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row == 0) {
        // For first cell which shows the name of the chef
        MasterchefNameTableViewCell *masterclassNameTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"MasterchefNameTableViewCell" forIndexPath:indexPath];
        masterclassNameTableViewCell.chefNameLabel.text = [self.selectedMasterclass.chefName stringByAppendingString:@"'s Masterclasses"];
        return masterclassNameTableViewCell;
    }
    
    RecordedMasterclassTableViewCell *masterclassTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"RecordedMasterclassTableViewCell" forIndexPath:indexPath];
    masterclassTableViewCell.masterchefButton.tag = indexPath.row;
    if (self.masterclasses.count > indexPath.row-1) {
        MasterclassVideo *masterclass = [self.masterclasses objectAtIndex:indexPath.row-1];
        masterclassTableViewCell.masterclassTitleLabel.text = masterclass.videoName;
        [masterclassTableViewCell.masterchefImageView setImageWithURL:[NSURL URLWithString:masterclass.chefImageURL] placeholderImage:[UIImage imageNamed:@"masterclass_leaf"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [masterclassTableViewCell.masterclassImageView setImageWithURL:[NSURL URLWithString:masterclass.placeholderImageURL] placeholderImage:nil usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    return masterclassTableViewCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0) {
        return 50.0f;
    }
    return _cellHeight;
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
    __weak KCMasterchefViewController *weakSelf = self;
    NSDictionary *params = @{kUserID:_userProfile.userID, kAcessToken:_userProfile.accessToken, kPageIndex: @(_currentPage), kMasterchefId: self.selectedMasterclass.chefId};
    [_userScheduleWebManager getMasterChefVideosWithParameter:params withCompletionHandler:^(NSDictionary *responseDictionary) {
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
