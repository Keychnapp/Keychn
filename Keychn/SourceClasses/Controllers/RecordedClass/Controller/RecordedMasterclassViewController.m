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


#define kBaseHeight  245
#define kBaseWidth   375

@interface RecordedMasterclassViewController () <UITableViewDataSource, UITableViewDelegate> {
    CGFloat _cellHeight;
    IOSDevices _currentDevice;
    KCUserProfile            *_userProfile;
    KCUserScheduleWebManager *_userScheduleWebManager;
    UIRefreshControl        *_refreshControl;
    NSNumber                *_pageIndex;
    NSNumber                *_totalPages;
    BOOL                    _isProcessing;
}

@property (weak, nonatomic) IBOutlet UITableView *masterclassVaultTableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) NSMutableArray *masterclasses;
@property (weak, nonatomic) IBOutlet UILabel *masterclassVaultLabel;

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
    
    // Set text
    self.masterclassVaultLabel.text = NSLocalizedString(@"masterclassVault", nil);
    
    // Get Instances
    _userProfile            = [KCUserProfile sharedInstance];
    _userScheduleWebManager = [KCUserScheduleWebManager new];
    _pageIndex              = @0;
    _totalPages             = @1;
    self.masterclasses      = [[NSMutableArray alloc] init];
    
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self action:@selector(refreshControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.masterclassVaultTableView setRefreshControl:_refreshControl];
    _refreshControl.tintColor = [UIColor appBackgroundColor];
    
    // Fetch Masterclass videos
    [self requestMasterClass];
    
    // Track user behavior
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"masterclass_vault_list"
         properties:@{@"": @""}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_refreshControl endRefreshing];
    [self.activityIndicator stopAnimating];
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
    _pageIndex  = @0;
    _totalPages = @1;
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

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    //Pagination for Items, when user scrolls to the bottom row,new rows will be added if available
    CGPoint offset = aScrollView.contentOffset;
    CGRect bounds = aScrollView.bounds;
    CGSize size = aScrollView.contentSize;
    UIEdgeInsets inset = aScrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    
    if(y > h-10 && !_isProcessing) {
        [self requestMasterClass];
    }
}

#pragma mark - Web Request

- (void)requestMasterClass {
    // Server request to fetch MasterClass Videos
    // If Masterclass is alredy being fetched then don't intiate a request.
    if (self.activityIndicator.isAnimating) {
        return;
    }
    if([_totalPages integerValue] < [_pageIndex integerValue] ) {
        return;
    }
    if(self.masterclasses.count == 0) {
        [self.activityIndicator startAnimating];
    }
    __weak RecordedMasterclassViewController *weakSelf = self;
    _isProcessing = YES;
    NSDictionary *params = @{kUserID:_userProfile.userID, kAcessToken:_userProfile.accessToken, kPageIndex: _pageIndex};
    [_userScheduleWebManager getMasterClassVideoWithParameter:params withCompletionHandler:^(NSDictionary *responseDictionary) {
        // Request completed with response
        [weakSelf masterclassFetchedWithResponse:responseDictionary];
        _isProcessing = NO;
    } andFailure:^(NSString *title, NSString *message) {
        // Request failed, present retry options
        _isProcessing = NO;
        [weakSelf endRefreshing];
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
    if(_refreshControl.isRefreshing) {
        self.masterclasses = [[NSMutableArray alloc] init];
        [self.masterclassVaultTableView reloadData];
        [_refreshControl endRefreshing];
    }
    
    [self.activityIndicator stopAnimating];
    if([resultArray isKindOfClass:[NSArray class]] && [resultArray count] > 0) {
        _pageIndex  = [response objectForKey:kPageIndex];
        _totalPages = [response objectForKey:kTotalPages];
        NSMutableArray *masterclassResults = [[NSMutableArray alloc] init];
        @autoreleasepool {
            for (NSDictionary *masterclassDictionary in resultArray) {
                MasterclassVideo *masterclassVideo = [[MasterclassVideo alloc] initWithResponse:masterclassDictionary];
                [masterclassResults addObject:masterclassVideo];
            }
        }
        
        NSInteger oldItemCount = [self.masterclasses count];
        NSInteger newItemCount = [masterclassResults count];
        [self.masterclasses addObjectsFromArray:masterclassResults];
        
        // Add objects from array
        NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
        for (NSInteger i=oldItemCount; i < oldItemCount+newItemCount; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [indexPaths addObject:indexPath];
        }
        [self.masterclassVaultTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.masterclassVaultTableView scrollToRowAtIndexPath:indexPaths.firstObject atScrollPosition:UITableViewScrollPositionBottom animated:true];
    }
    
}

@end
