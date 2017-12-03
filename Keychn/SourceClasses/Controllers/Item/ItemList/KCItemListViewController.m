//
//  KCItemListViewController.m
//  Keychn
//
//  Created by Keychn Experience SL on 19/01/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import "KCItemListViewController.h"
#import "KCMenu.h"
#import "UIImageView+AFNetworking.h"
#import "KCMenuWebManager.h"
#import "KCItem.h"
#import "UICollectionViewLeftAlignedLayout.h"
#import "KCItemDetailsViewController.h"
#import "KCRecipeListCollectionViewCell.h"
#import "KCSearchResult.h"

@interface KCItemListViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITextFieldDelegate> {
    KCMenuWebManager *_menuWebManager;
    KCUserProfile       *_userProfile;
    NSNumber            *_pageIndex;
    NSNumber            *_totalPages;
    IOSDevices          _deviceType;
    NSInteger           _tableRowCount;
    NSMutableArray      *_sectionHeaderArray;
    BOOL                _requestInProgress;
    NSMutableArray      *_courseItemArray;
    NSInteger           _inset;
    UIRefreshControl    *_refreshControl;
    NSString            *_searchKeyword;
    KCSearchResult      *_searchResult;
}

@property (weak, nonatomic) IBOutlet UICollectionView *itemCollectionView;
@property (weak, nonatomic) IBOutlet UIView *lineSeparatorView;
@property (strong, nonatomic) NSMutableArray *allItemsArray;
@property (strong, nonatomic) NSMutableArray *dataSourceArray;
@property (weak, nonatomic) IBOutlet UILabel *freeRecipeLabel;
@property (weak, nonatomic) IBOutlet UIView *searchContainerView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@end

@implementation KCItemListViewController

#pragma mark - Life Cycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _deviceType = [KCUtility getiOSDeviceType];
    
    [self customizeUI];
    
    //get user Profile
    _userProfile = [KCUserProfile sharedInstance];
    
    _pageIndex          = @0;
    _totalPages         = @1;
    self.allItemsArray       = [[NSMutableArray alloc] init];
    _sectionHeaderArray      = [[NSMutableArray alloc] init];
    _courseItemArray         = [[NSMutableArray alloc] init];

    //Get items list from server
    _requestInProgress = NO;
    [self fetchItemsListShouldShowIndicator:true];
    
    
    UICollectionViewLeftAlignedLayout *collectionViewLayout = [UICollectionViewLeftAlignedLayout new];
    [self.itemCollectionView setCollectionViewLayout:collectionViewLayout];
    self.itemCollectionView.alwaysBounceVertical = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - New Collection View Datasource and Delegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    // Returns the size of the item on CollectionView
    return CGSizeMake(144, 187);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return _inset;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return _inset;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    // Returns the number of items required in the CollectionView
    return [self.dataSourceArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    KCRecipeListCollectionViewCell *recipeItemCollectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifierForRecipeItem forIndexPath:indexPath];
    
    // Configure cell
    if([self.dataSourceArray count] > indexPath.item) {
        KCItem *item = [self.dataSourceArray objectAtIndex:indexPath.row];
        recipeItemCollectionViewCell.itemTitleLabel.text = item.title;
        recipeItemCollectionViewCell.itemImageView.layer.cornerRadius  = 8.0f;
        recipeItemCollectionViewCell.itemImageView.layer.masksToBounds = YES;
        [recipeItemCollectionViewCell.itemImageView setImageWithURL:[NSURL URLWithString:item.imageURL] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    return recipeItemCollectionViewCell;
}

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    //Pagination for Items, when user scrolls to the bottom row,new rows will be added if available
    CGPoint offset = aScrollView.contentOffset;
    CGRect bounds = aScrollView.bounds;
    CGSize size = aScrollView.contentSize;
    UIEdgeInsets inset = aScrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    
    if(y > h-10 && (_searchKeyword == nil || _searchKeyword.length == 0)) {
        [self fetchItemsListShouldShowIndicator:false];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //Get item details for selected Item
    if([self.dataSourceArray count] > indexPath.row) {
        KCItemDetailsViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:itemDetailsViewController];
        KCItem *item  = [self.dataSourceArray objectAtIndex:indexPath.row];
        viewController.selectedItem = item;
        Mixpanel *mixpanel = [Mixpanel sharedInstance];
        [mixpanel track:@"recipe_list"
             properties:@{@"recipe_id":item.itemIdentifier}];

        [self.navigationController pushViewController:viewController animated:YES];
    }
}

#pragma mark - TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self searchItems];
    return true;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if(self.dataSourceArray.count > 0) {
        self.dataSourceArray = nil;
        [self.itemCollectionView reloadData];
    }
    return true;
}

#pragma mark- Button Actions

- (IBAction)backButtonTapped:(id)sender {
    [KCProgressIndicator hideActivityIndicator];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)searchButtonTapped:(id)sender {
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    if(self.searchContainerView.hidden) {
        // Animate SearchView to open
        [mixpanel track:@"recipe_list_search_icon"
             properties:@{@"":@""}];
        self.searchContainerView.hidden = NO;
        CATransition* transition = [CATransition animation];
        transition.duration = 0.6;
        transition.type = kCATransitionMoveIn;
        transition.subtype = kCATransitionFromRight;
        [transition setTimingFunction: [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [self.searchContainerView.layer addAnimation:transition forKey:kCATransition];
    }
}

- (IBAction)doneButtonTapped:(id)sender {
    [self.searchTextField resignFirstResponder];
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
    
    // Display all item source
    self.dataSourceArray = self.allItemsArray;
    [self.itemCollectionView reloadData];
    _searchKeyword = nil;
    self.searchTextField.text = nil;
}


#pragma mark - Instance Methods

- (void)addNewItemsWithResponse:(NSArray*)newItemListArray {
    if(_refreshControl.isRefreshing) {
        // Item list refreshed
        [_refreshControl endRefreshing];
        self.allItemsArray = [newItemListArray mutableCopy];
        self.dataSourceArray = self.allItemsArray;
        [self.itemCollectionView reloadData];
    }
    else {
        // Add new items to the list
        if(self.allItemsArray.count > 0) {
            NSInteger oldItemsCount = [self.dataSourceArray count];
            [self.allItemsArray addObjectsFromArray:newItemListArray];
            NSInteger newItemsCount = [newItemListArray count];
            NSMutableArray  *indexArray = [[NSMutableArray alloc] init];
            for (NSInteger i=oldItemsCount; i < oldItemsCount+newItemsCount; i++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
                [indexArray addObject:indexPath];
            }
            self.dataSourceArray = self.allItemsArray;
            [self.itemCollectionView insertItemsAtIndexPaths:indexArray];
        }
        else {
            self.allItemsArray = [newItemListArray mutableCopy];
            self.dataSourceArray = self.allItemsArray;
            [self.itemCollectionView reloadData];
        }
    }
}

- (void) customizeUI {
    // Add a refresh control
    _refreshControl           = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self action:@selector(refreshControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.itemCollectionView setRefreshControl:_refreshControl];
    _refreshControl.tintColor = [UIColor appBackgroundColor];
    
    // Layout adjustment
    self.automaticallyAdjustsScrollViewInsets      = NO;
    if(_deviceType == iPad) {
        _inset   = 31;
    }
    else {
        NSInteger viewWidth  = CGRectGetWidth(self.view.frame);
        NSInteger itemWidth  = 144;
        NSInteger itemFill   = viewWidth/itemWidth;
        NSInteger blankSpace = viewWidth - (itemFill * itemWidth);
        _inset               = blankSpace/3;
        self.itemCollectionView.contentInset = UIEdgeInsetsMake(0, _inset, 0, _inset);
        CGRect frame = _refreshControl.subviews.firstObject.frame;
        frame.origin.x      = frame.origin.x - _inset/2;
        _refreshControl.subviews.firstObject.frame = frame;
    }
}


- (void)refreshControlValueChanged:(UIRefreshControl *)sender {
    if(_searchKeyword == nil || _searchKeyword.length == 0) {
        // List recipes refresh
        _pageIndex = @0;
        [self fetchItemsListShouldShowIndicator:false];
    }
    else {
        // Search items refresh
        [self searchItems];
    }
}

- (void)scrollToTop {
    if(self.dataSourceArray.count > 0) {
        [self.itemCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:true];
    }
}

- (void)searchItems {
    // Search Items
    [self.searchTextField resignFirstResponder];
    _searchKeyword = [self.searchTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if(_searchKeyword.length > 0) {
        Mixpanel *mixpanel  = [Mixpanel sharedInstance];
        [mixpanel track:@"Recipe search"
             properties:@{ @"Keyword":_searchKeyword}];
        [self searchItemsWithText:_searchKeyword];
    }
}

#pragma mark - Request Completion

- (void)searchDidCompleteWithResponse:(NSDictionary*)response {
    // Called when use search completed
    _searchResult           = [[KCSearchResult alloc] initWithResponse:response];
    [_refreshControl endRefreshing];
    self.dataSourceArray    = _searchResult.itemsByRecipeArray;
    [self.dataSourceArray addObjectsFromArray:_searchResult.itemsByIngredientArray];
    [self.itemCollectionView reloadData];
}

#pragma mark - Server End Code

- (void)fetchItemsListShouldShowIndicator:(BOOL)shoulShow {
    //Get items list from server
    static BOOL isAlertOpen;
    if(!_menuWebManager) {
        _menuWebManager = [KCMenuWebManager new];
    }
    //if all pages are fetched then stop the request
    __weak KCItemListViewController *weakSelf = self;
    if([_totalPages integerValue] > [_pageIndex integerValue] && !_requestInProgress) {
        if (shoulShow) {
              [KCProgressIndicator showNonBlockingIndicator];
        }
        _requestInProgress = YES;
        NSDictionary *params = @{kUserID: _userProfile.userID, kAcessToken:_userProfile.accessToken, kLanguageID:_userProfile.languageID, kPageIndex:_pageIndex};
        
        // Network request for item list
        [_menuWebManager getMenuItemsListWithParameters:params withCompletionHandler:^(NSArray *itemsListArray, NSNumber *totalPages, NSNumber *pageIndex, NSString *menuImageURL, NSArray *courseList) {
            // Add new items to item list
            [weakSelf addNewItemsWithResponse:itemsListArray];
            _pageIndex  = pageIndex;
            _totalPages = totalPages;
            _requestInProgress = NO;
            [KCProgressIndicator hideActivityIndicator];
        } andFailure:^(NSString *title, NSString *message) {
            [_refreshControl endRefreshing];
            _requestInProgress = NO;
            if(isNetworkReachable) {
                [weakSelf fetchItemsListShouldShowIndicator:true];
            }
            else {
                [KCProgressIndicator hideActivityIndicator];
                if(!isAlertOpen && [_pageIndex integerValue] == 0) {
                    isAlertOpen = YES;
                    [KCUIAlert showAlertWithButtonTitle:NSLocalizedString(@"retry", nil) alertHeader:NSLocalizedString(@"networkError", nil) message:NSLocalizedString(@"tryReconnecting", nil) withButtonTapHandler:^(BOOL positiveButton){
                        isAlertOpen = NO;
                        if(positiveButton) {
                            [weakSelf fetchItemsListShouldShowIndicator:true];
                        }
                    }];
                }
            }
            
        }];
    }
    else {
        [_refreshControl endRefreshing];
    }
}

- (void)searchItemsWithText:(NSString*)text {
    if(isNetworkReachable) {
        Mixpanel *mixpanel = [Mixpanel sharedInstance];
        [mixpanel track:@"Recipe search"
             properties:@{ @"Keyword":text}];
        NSDictionary *params = @{kUserID:_userProfile.userID, kLanguageID:_userProfile.languageID, kAcessToken:_userProfile.accessToken, kSearchString:text};
        [KCProgressIndicator showNonBlockingIndicator];
        __weak id wealSelf = self;
        [_menuWebManager searchItemsWithParameters:params withCompletionHandler:^(NSDictionary *responseDictionary) {
            // User search completed with success
            [KCProgressIndicator hideActivityIndicator];
            [wealSelf searchDidCompleteWithResponse:responseDictionary];
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
