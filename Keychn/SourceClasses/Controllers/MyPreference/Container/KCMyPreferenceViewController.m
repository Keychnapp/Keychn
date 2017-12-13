//
//  KCMyPreferenceViewController.m
//  Keychn
//
//  Created by Keychn Experience SL on 11/03/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import "KCMyPreferenceViewController.h"
#import "UICollectionViewLeftAlignedLayout.h"
#import "KCItemCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "KCUserProfilePhotoViewController.h"
#import "KCMyPreferecnceWebManager.h"
#import "KCMyPreference.h"
#import "KCItem.h"
#import "KCItemDetailsViewController.h"
#import "KeychnStore.h"
#import "KCRecipeListCollectionViewCell.h"
#import "IAPSubscription.h"
#import "KCSubscription.h"


@interface KCMyPreferenceViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout> {
    KCUserProfile             *_userProfile;
    KCMyPreferecnceWebManager *_myPreferenceWebManager;
    KCMyPreference            *_myPreference;
    NSInteger                 _currentPageIndex;
    NSInteger                 _activityIndicatorCount;
    NSInteger                 _totalPages;
    BOOL                      _requestInProgress;
    NSMutableArray            *_recentRecipesArray;
    BOOL                      _canPerformAction;
    KeychnStore              *_keychnStore;
    IOSDevices               _deviceType;
    NSInteger               _inset;
    KCSubscription          *_subscriptionAlertView;
}


@property (weak, nonatomic) IBOutlet UICollectionView *itemCollectionView;
@property (weak, nonatomic) IBOutlet UIImageView *bannerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewAspectRatioConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewiPadAspectRatioConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewiPadHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *imageContainerView;
@property (weak, nonatomic) IBOutlet UIView *noFavoriteRecipeView;
@property (weak, nonatomic) IBOutlet UIView *freeTrialView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *freeTrialViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *freeTrialViewiPadHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *yourFavoriteRecipeLabel;
@property (weak, nonatomic) IBOutlet UIButton *subscribeButton;
@property (weak, nonatomic) IBOutlet UILabel *getTrialLabel;
@property (weak, nonatomic) IBOutlet UILabel *cancelAnyTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *goToRecipTabLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLocationLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewTopSpaceLowPriorityConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewTopSpaceHighPriorityConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *favoriteRecipeTopSpaceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *noFavoriteRecipeTopSpaceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *itemCollectionViewTopSpaceConstraint;


@end

@implementation KCMyPreferenceViewController

#pragma mark - Life Cycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Get Instances
    _userProfile            = [KCUserProfile sharedInstance];
    _myPreferenceWebManager = [KCMyPreferecnceWebManager new];
    _currentPageIndex       = 0;
    _totalPages             = 1;
    _inset                  = 31;
    _activityIndicatorCount = 0;
    _requestInProgress      = NO;
    _canPerformAction       = YES;
    _deviceType             = [KCUtility getiOSDeviceType];
    
    // Customize UI for font,color and layout
    [self customizeUI];
    
    // Fetch latest cooked recipes from server
    [self fetchLatestCookedRecipe];
    
    UICollectionViewLeftAlignedLayout *collectionViewLayout = [UICollectionViewLeftAlignedLayout new];
    [self.itemCollectionView setCollectionViewLayout:collectionViewLayout];
    
    [self setText];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Valdiate User Subscription
    [self validateUserSubscription];
    
    // Set image if it is selected curretnly
    if(_userProfile.selectedImage) {
        self.userProfileImageView.image = _userProfile.selectedImage;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // Hide activity indicator before leaving the screen.
    [KCProgressIndicator hideActivityIndicator];
}

#pragma mark - Collection View Datasource and Delegate

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
    return [_recentRecipesArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    KCRecipeListCollectionViewCell *recipeItemCollectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifierForRecipeItem forIndexPath:indexPath];
    
    // Configure cell
    if([_recentRecipesArray count] > indexPath.item) {
        KCItem *item = [_recentRecipesArray objectAtIndex:indexPath.row];
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
    
    CGFloat yVelocity = [aScrollView.panGestureRecognizer velocityInView:aScrollView].y;
    if (yVelocity < 0) {
        // Scrolling Up
        if(_deviceType == iPad) {
            self.containerViewiPadAspectRatioConstraint.priority = 800;
            self.containerViewiPadHeightConstraint.priority      = 900;
        }
        else {
            self.containerViewAspectRatioConstraint.priority = 800;
            self.containerViewHeightConstraint.priority      = 900;
        }
        
        [UIView animateWithDuration:0.5 animations:^{
            [self.view layoutIfNeeded];
        }];
    } else if (yVelocity > 0) {
        // Scrolling Down
        if (offset.y <= 0) {
            // Reached at the top of the
            if(_deviceType == iPad) {
                self.containerViewiPadAspectRatioConstraint.priority = 900;
                self.containerViewiPadHeightConstraint.priority      = 800;
            }
            else {
                self.containerViewAspectRatioConstraint.priority = 900;
                self.containerViewHeightConstraint.priority      = 800;
            }
            [UIView animateWithDuration:0.5 animations:^{
                [self.view layoutIfNeeded];
            }];
        }
    }
    
   if(y > h-10) {
        // Update to next page for the latest recipe
        [self fetchLatestCookedRecipe];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //Get item details for selected Item
    if([_recentRecipesArray count] > indexPath.section) {
       KCItem *item = [_recentRecipesArray objectAtIndex:indexPath.row];
        [self pushItemDetailsScreenWithItemName:item.title andItemID:item.itemIdentifier];
    }
}


#pragma mark - Button Actions

- (IBAction)editButtonTapped:(id)sender {
    // Go to image upload ViewControlelr
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"profile_edit"
         properties:@{@"":@""}];

    KCUserProfilePhotoViewController *imageUpdateViewController = [self.storyboard instantiateViewControllerWithIdentifier:setProfilePhotoViewController];
    imageUpdateViewController.isEditingImage = YES;
    [self.navigationController pushViewController:imageUpdateViewController animated:YES];
}

- (IBAction)settingsButtonTapped:(id)sender {
    // Go to Setting Screen
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"profile_settings"
         properties:@{@"":@""}];

    UIViewController *userSettingsViewController = [self.storyboard instantiateViewControllerWithIdentifier:settingViewController];
    [self.navigationController pushViewController:userSettingsViewController animated:YES];
}


- (IBAction)purchaseSubscriptionButtonTapped:(id)sender {
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"profile_subscribe_button"
         properties:@{@"":@""}];

    _subscriptionAlertView = [[KCSubscription alloc] initWithFrame:self.view.frame];
    [_subscriptionAlertView showInView:self.view withCompletionHandler:^(BOOL postiveButton) {
        
    }];
}

- (IBAction)openRecipeButtonTapped:(UIButton *)sender {
    
}


#pragma mark - Gesture Recoginizer

- (void)dishofTheWeekTapped:(UIGestureRecognizer*)tapGesture {
    if(!self.isDisplayingFriendPreference && [_myPreference.dishofTheWeekItemID integerValue] > 0) {
        // If dish of the week fetched, then show the details with the item id
        [self pushItemDetailsScreenWithItemName:_myPreference.dishofTheWeekItemName andItemID:_myPreference.dishofTheWeekItemID];
    }
}


#pragma mark - Instance Methods

- (void)validateUserSubscription {
    IAPSubscription *iapSubscription = [IAPSubscription subscriptionForUser:_userProfile.userID];
    if(_deviceType == iPad) {
        self.freeTrialViewiPadHeightConstraint.constant = iapSubscription ? 0 :111;
    }
    else {
        self.freeTrialViewHeightConstraint.constant = iapSubscription ? 0 :111;
    }
}

- (void)customizeUI {
    // Customize UI for font, text color, background color
    
    // Layout adjustment
    self.automaticallyAdjustsScrollViewInsets      = NO;
    if(_deviceType != iPad) {
        NSInteger viewWidth  = CGRectGetWidth(self.view.frame);
        NSInteger itemWidth  = 144;
        NSInteger itemFill   = viewWidth/itemWidth;
        NSInteger blankSpace = viewWidth - (itemFill * itemWidth);
        _inset               = blankSpace/3;
        self.itemCollectionView.contentInset = UIEdgeInsetsMake(0, _inset, 0, _inset);
    }
    self.itemCollectionView.alwaysBounceVertical = YES;
    
    // Set images
    NSString *coverImageURL = AppPlaceholder.user;
    if ([_userProfile.userType isEqualToString:kMasterChef]) {
        coverImageURL = AppPlaceholder.masterchef;
    }
    [self.bannerImageView setImageWithURL:[NSURL URLWithString:coverImageURL] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.userProfileImageView setImageWithURL:[NSURL URLWithString:_userProfile.imageURL] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.userProfileImageView.layer.cornerRadius  = 60;
    self.userProfileImageView.layer.masksToBounds = YES;
    self.imageContainerView.clipsToBounds         = YES;
    
    if(_deviceType == iPhone5) {
        self.imageViewTopSpaceLowPriorityConstraint.priority    = 800;
        self.noFavoriteRecipeTopSpaceConstraint.priority        = 900;
        self.favoriteRecipeTopSpaceConstraint.priority          = 900;
        self.itemCollectionViewTopSpaceConstraint.priority      = 900;
    }
}

- (void)pushItemDetailsScreenWithItemName:(NSString*)name andItemID:(NSNumber*)itemID {
    // Go to Item Details screen with item name and identifier
    KCItemDetailsViewController *itemDetailViewController  = [self.storyboard instantiateViewControllerWithIdentifier:itemDetailsViewController];
    KCItem *dishofTheWeekItem             = [KCItem new];
    dishofTheWeekItem.itemIdentifier      = itemID;
    dishofTheWeekItem.title               = name;
    itemDetailViewController.selectedItem = dishofTheWeekItem;
    [self.navigationController pushViewController:itemDetailViewController animated:YES];
}


- (void)didFetchCookedRecipesWithResponse:(NSArray*)itemListResponse {
    // Fetched recently cooked recipes from server
    NSInteger oldItemCount = [_recentRecipesArray count];
   if([itemListResponse isKindOfClass:[NSArray class]] && [itemListResponse count] > 0) {
        // Prepare models for items
        @autoreleasepool {
            NSMutableArray *indexPathArrays = [[NSMutableArray alloc] init];
            if(!_recentRecipesArray) {
               _recentRecipesArray = [[NSMutableArray alloc] init];
            }
            for (NSDictionary *recentRecipeDictionary in itemListResponse) {
                KCItem *item =[KCItem new];
                [item getModelFromDictionary:recentRecipeDictionary];
                [_recentRecipesArray addObject:item];
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:oldItemCount inSection:0];
                [indexPathArrays addObject:indexPath];
                oldItemCount++;
            }
            
            // Insert new items to the table
            [self.itemCollectionView insertItemsAtIndexPaths:indexPathArrays];
        }
    }
    // Toogle no recipes cooked view
    BOOL shouldShowRecipeList        = [_recentRecipesArray count] > 0;
    self.itemCollectionView.hidden   = !shouldShowRecipeList;
    self.noFavoriteRecipeView.hidden = shouldShowRecipeList;
}

- (void)setItemDataOnCollectionViewCell:(KCRecipeListCollectionViewCell*)itemCell withIndexPath:(NSIndexPath*)indexPath {
    //Set Collection View Item Data
    if([_recentRecipesArray count] > indexPath.row) {
        KCItem *item = [_recentRecipesArray objectAtIndex:indexPath.row];
        itemCell.itemTitleLabel.text = [item.title uppercaseString];
        [itemCell.itemImageView setImageWithURL:[NSURL URLWithString:item.imageURL] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
}

- (void)setText {
    // Set text on buttons and labels
    self.usernameLabel.text       = _userProfile.username;
    if([NSString validateString:_userProfile.location]) {
        self.userLocationLabel.text   = _userProfile.location;
        self.userLocationLabel.hidden = NO;
    }
    else {
        self.userLocationLabel.hidden = YES;
    }
    
    self.subscribeButton.layer.cornerRadius = 5.0f;
    self.subscribeButton.layer.masksToBounds = YES;
    
    // Set attributed text
    NSMutableAttributedString *your = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"your", nil) attributes:@{NSFontAttributeName: [UIFont setRobotoFontRegularStyleWithSize:15] , NSForegroundColorAttributeName: [UIColor blackColor]}];
    NSAttributedString *favorite = [[NSAttributedString alloc] initWithString:[@" " stringByAppendingString:NSLocalizedString(@"favorite", nil)]  attributes:@{NSFontAttributeName: [UIFont setRobotoFontRegularStyleWithSize:15], NSForegroundColorAttributeName: [UIColor appBackgroundColor]}];
    NSAttributedString *recipes = [[NSAttributedString alloc] initWithString:[@" " stringByAppendingString:NSLocalizedString(@"recipes", nil)]  attributes:@{NSFontAttributeName: [UIFont setRobotoFontRegularStyleWithSize:15], NSForegroundColorAttributeName: [UIColor blackColor]}];
    [your appendAttributedString:favorite];
    [your appendAttributedString:recipes];
    self.yourFavoriteRecipeLabel.attributedText = your;
}

#pragma mark - Server End

- (void)fetchLatestCookedRecipe {
    // Fetch lates cooked recipes from server that user has completed
    if(isNetworkReachable && !_requestInProgress) {
        _requestInProgress = YES;
        
        // Only fetch more items if there are more pages to load
        if(_totalPages > _currentPageIndex) {
            [KCProgressIndicator showNonBlockingIndicator];
            NSDictionary *params = nil;
            if(self.isDisplayingFriendPreference) {
                params = @{kUserID:_userProfile.userID, kAcessToken:_userProfile.accessToken, kLanguageID:_userProfile.languageID, kPageIndex:[NSNumber numberWithInteger:_currentPageIndex], kFriendID:self.friendID};
            }
            else {
                params = @{kUserID:_userProfile.userID, kAcessToken:_userProfile.accessToken, kLanguageID:_userProfile.languageID, kPageIndex:[NSNumber numberWithInteger:_currentPageIndex]};
            }
            
            __weak id weakSelf   = self;
            [_myPreferenceWebManager getRecentRecipeListWithParameters:params withCompletionHandler:^(NSArray *itemsArray, NSNumber *totalPages, NSNumber *pageIndex) {
                _currentPageIndex = [pageIndex integerValue];
                _totalPages       = [totalPages integerValue];
                [weakSelf didFetchCookedRecipesWithResponse:itemsArray];
                [KCProgressIndicator hideActivityIndicator];
                _requestInProgress = NO;
            } andFailure:^(NSString *title, NSString *message) {
                [KCProgressIndicator hideActivityIndicator];
                _requestInProgress = NO;
            }];
        }
    }
}

@end

