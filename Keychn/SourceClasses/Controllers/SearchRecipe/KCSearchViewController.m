//
//  KCSearchViewController.m
//  Keychn
//
//  Created by Keychn Experience SL on 04/01/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import "KCSearchViewController.h"
#import "KCItemSectionHeaderCollectionViewCell.h"
#import "KCItemDetailsViewController.h"
#import "KCSearchResult.h"
#import "KCMenuWebManager.h"
#import "KCItemDetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "UICollectionViewLeftAlignedLayout.h"
#import "KCRecipeListCollectionViewCell.h"

typedef NS_ENUM(NSUInteger, SEARCH_RESULT_SECTION) {
    byRecipe,
    byIngredients,
    byCategories
};

@interface KCSearchViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate> {
    
    NSArray             *_sectionHeaderArray;
    KCSearchResult      *_searchResult;
    KCMenuWebManager    *_menuWebManager;
    KCUserProfile       *_userProfile;
}

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIView *separatorView;
@property (weak, nonatomic) IBOutlet UICollectionView *searchResultCollectoinView;
@property (weak, nonatomic) IBOutlet UILabel *searchResultLabel;
@property (strong,nonatomic) NSDictionary    *itemsListDictionary;

@end

@implementation KCSearchViewController

#pragma mark - Life Cycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _sectionHeaderArray = [[NSArray alloc] initWithObjects:AppLabel.lblSearchByRecipe, AppLabel.lblSearchByIngredients, AppLabel.lblSearchByCategory, nil];
    
    // Get instances
    _userProfile        = [KCUserProfile sharedInstance];
    _menuWebManager     = [KCMenuWebManager new];
    
    // Customize app UI
    [self customizeUI];
    
    // Add right swipe gesture to navigate back
    [self addLeftSwipeGesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Set text on labels and buttons
    [self setText];
}

#pragma Text Field Delegates

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    // User search begin
    [textField resignFirstResponder];
    [self searchRecipes];
    return YES;
}

#pragma mark - Collection View Datasource and Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [_sectionHeaderArray count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    // Returns item counts in a section based on the search result
    NSInteger itemCount = 2; // Fist row of each section is used as Section Header
    // if there is no search result then the no search result cell will be displayed
    switch (section) {
        case byRecipe:
            if([_searchResult.itemsByRecipeArray count] > 0) {
                itemCount += ([_searchResult.itemsByRecipeArray count] - 1); // If there is search result for any section then subtract the No Search Result cell count
            }
            break;
        case byIngredients:
            if([_searchResult.itemsByIngredientArray count] > 0) {
                itemCount += ([_searchResult.itemsByIngredientArray count] - 1); // If there is search result for any section then subtract the No Search Result cell count
            }
            break;
        case byCategories:
            if([_searchResult.itemsByCategoriesArray count] > 0) {
                itemCount += ([_searchResult.itemsByCategoriesArray count] - 1); // If there is search result for any section then subtract the No Search Result cell count
            }
            break;
    }
    return itemCount;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGRect    windowFrame    = [UIScreen mainScreen].bounds;
    NSInteger screenWidth    = CGRectGetWidth(windowFrame);
    CGSize    cellSize;
    if(indexPath.row == 0) {
        cellSize = CGSizeMake(screenWidth, 30);
    }
    else {
        BOOL isSearchResultAvailable = NO;
        switch (indexPath.section) {
            case byRecipe:
                isSearchResultAvailable = [_searchResult.itemsByRecipeArray count] > 0;
                break;
            case byIngredients:
                isSearchResultAvailable = [_searchResult.itemsByIngredientArray count] > 0;
                break;
            case byCategories:
                isSearchResultAvailable = [_searchResult.itemsByCategoriesArray count] > 0;
                break;
        }
        if(isSearchResultAvailable) {
            cellSize = CGSizeMake(144,187);
        }
        else {
           cellSize = CGSizeMake(screenWidth, 164);
        }
        
    }
    return cellSize;
}

#pragma mark collection view cell paddings
- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0); // top, left, bottom, right
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5.0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *itemCollectionCell;
    //Add header for first row
    if(indexPath.row == 0) {
        KCItemSectionHeaderCollectionViewCell *sectionHeaderCollectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifierForSectionHeader forIndexPath:indexPath];
        itemCollectionCell = sectionHeaderCollectionViewCell;
        
        //Set Collection View section title
        NSString *sectionTitle = [_sectionHeaderArray objectAtIndex:indexPath.section];
        sectionHeaderCollectionViewCell.sectionTitleLabel.font = [UIFont setRobotoFontBoldStyleWithSize:15];
        sectionHeaderCollectionViewCell.sectionTitleLabel.text = nil;
        sectionHeaderCollectionViewCell.sectionTitleLabel.text = sectionTitle;
        
    }
    else {
        BOOL isSearchResultAvailable = NO;
        switch (indexPath.section) {
            case byRecipe:
                isSearchResultAvailable = [_searchResult.itemsByRecipeArray count] > 0;
                break;
            case byIngredients:
                isSearchResultAvailable = [_searchResult.itemsByIngredientArray count] > 0;
                break;
            case byCategories:
                isSearchResultAvailable = [_searchResult.itemsByCategoriesArray count] > 0;
                break;
        }
        
        if(isSearchResultAvailable) {
            // Show the search result when available
            KCRecipeListCollectionViewCell *menuItemCollectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifierForRecipeItem forIndexPath:indexPath];
            [self setItemDataOnCollectionViewCell:menuItemCollectionCell withIndexPath:indexPath];
            itemCollectionCell = menuItemCollectionCell;
        }
        else {
            // Show no search result cell
            itemCollectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifierForNoSearchResult forIndexPath:indexPath];
        }
    }
    
    return itemCollectionCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //Get item details for selected Item
    KCItem *seletedItem = nil;
    NSInteger effectiveRow = indexPath.row -1;
    NSInteger arrayCount   = 0;
    switch (indexPath.section) {
        case byRecipe:
            arrayCount = [_searchResult.itemsByRecipeArray count];
            if(arrayCount > 0 && arrayCount > effectiveRow) {
                seletedItem = [_searchResult.itemsByRecipeArray objectAtIndex:effectiveRow];
            }
            break;
        case byIngredients:
            arrayCount = [_searchResult.itemsByIngredientArray count];
            if(arrayCount > 0 && arrayCount > effectiveRow) {
                seletedItem = [_searchResult.itemsByIngredientArray objectAtIndex:effectiveRow];
            }
            break;
        case byCategories:
            arrayCount = [_searchResult.itemsByCategoriesArray count];
            if(arrayCount > 0 && arrayCount > effectiveRow) {
                seletedItem = [_searchResult.itemsByCategoriesArray objectAtIndex:effectiveRow];
            }
            break;
    }
    if(seletedItem) {
       [self gotoItemDetailsScreenWithSelectedItem:seletedItem];
    }
    
}

#pragma mark - Gesture recognizition
- (void)rightSwipeGesurePerformed:(UIGestureRecognizer *)gestureRecognizer {
    [self popViewController];
}

#pragma mark - Button Actions

- (IBAction) backButtonTapped:(id)sender {
    [self popViewController];
}

- (IBAction)searchButtonTapped:(id)sender {
    // User search begin for items
    [self searchRecipes];
}

#pragma mark - Instance Methods

- (void)customizeUI {
    // Set background color
    self.separatorView.backgroundColor      = [UIColor separatorLineColor];
    self.searchResultLabel.backgroundColor  = [UIColor appBackgroundColor];
    self.searchResultCollectoinView.backgroundColor = [UIColor whiteColor];
    
    // Adjust font size
    self.searchResultLabel.adjustsFontSizeToFitWidth = YES;
    
    // Set layout for Collection View
    UICollectionViewLeftAlignedLayout *collectionViewLayout = [UICollectionViewLeftAlignedLayout new];
    [self.searchResultCollectoinView setCollectionViewLayout:collectionViewLayout];
    self.searchResultCollectoinView.alwaysBounceVertical = YES;
    
    // Hide Collection View until data is available
    [self toggleHiding:YES];
    
    // Set font
    self.searchResultLabel.font = [UIFont setRobotoFontBoldStyleWithSize:15];
}

- (void)setText {
    // Set text
    self.searchResultLabel.text         = [AppLabel.lblSearchResult uppercaseString];
    self.searchTextField.placeholder    = AppLabel.lblPlaceholderSearchItems;
}

- (void)popViewController {
    [self.searchTextField resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addLeftSwipeGesture {
    // Add a swipe gesture on superview to navigate back
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipeGesurePerformed:)];
    swipeGesture.direction                 = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeGesture];
}

- (void)toggleHiding:(BOOL)shouldHide {
    // Hide Unhide collectionView and search result label
    self.searchResultLabel.hidden           = shouldHide;
    self.searchResultCollectoinView.hidden  = shouldHide;
}

- (void)searchRecipes {
    NSString *searchString = [self.searchTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(searchString.length == 0) {
        [self.searchTextField becomeFirstResponder];
    }
    else if(searchString.length < 4) {  // At least 4 chars are required to begin search
        [KCUIAlert showInformationAlertWithHeader:AppLabel.errorTitle message:AppLabel.typeMoreCharactersToSearch withButtonTapHandler:^{
            
        }];
    }
    else {
        // Network request to search items
        [self.searchTextField resignFirstResponder];
        Mixpanel *mixpanel = [Mixpanel sharedInstance];
        [mixpanel track:@"recipe_list_search_submit"
             properties:@{@"search_value":searchString}];

        [self searchItemsWithText:searchString];
    }
}

- (void)searchDidCompleteWithResponse:(NSDictionary*)response {
    // Called when use search completed
    [self toggleHiding:NO]; // Unhide the labels and collection View
    
    _searchResult = [[KCSearchResult alloc] initWithResponse:response];
    
    // Parse search result into models
    [self.searchResultCollectoinView reloadData];
}

- (void)gotoItemDetailsScreenWithSelectedItem:(KCItem*)selectedItem {
    // Push item details screen with Item ID
    KCItemDetailsViewController *itemDetailViewController = [self.storyboard instantiateViewControllerWithIdentifier:itemDetailsViewController];
    itemDetailViewController.selectedItem       = selectedItem;
    [self.navigationController pushViewController:itemDetailViewController animated:YES];
}

- (void)setItemDataOnCollectionViewCell:(KCRecipeListCollectionViewCell *)recipeItemCollectionViewCell withIndexPath:(NSIndexPath*)indexPath {
    //Set Collection View Item Data
    if([_sectionHeaderArray count] > indexPath.section) {
        //Get item from collection
        NSArray  *itemsCollectionArray = nil;
        switch (indexPath.section) {
            case byRecipe:
                itemsCollectionArray = _searchResult.itemsByRecipeArray;
                break;
            case byIngredients:
                itemsCollectionArray = _searchResult.itemsByIngredientArray;
                break;
            case byCategories:
                itemsCollectionArray = _searchResult.itemsByCategoriesArray;
                break;
        }
        if([itemsCollectionArray count] > indexPath.row-1) {
            KCItem *item = [itemsCollectionArray objectAtIndex:indexPath.row-1];
            //Set Data
            recipeItemCollectionViewCell.itemTitleLabel.text = item.title;
            recipeItemCollectionViewCell.itemImageView.layer.cornerRadius  = 8.0f;
            recipeItemCollectionViewCell.itemImageView.layer.masksToBounds = YES;
            [recipeItemCollectionViewCell.itemImageView setImageWithURL:[NSURL URLWithString:item.imageURL] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        }
    }
}

#pragma mark - Server End Code

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
        [KCUIAlert showInformationAlertWithHeader:AppLabel.errorTitle message:AppLabel.internetNotAvailable withButtonTapHandler:^{
            
        }];
    }
}

@end
