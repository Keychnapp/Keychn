//
//  KCItemDetailsViewController.m
//  Keychn
//
//  Created by Keychn Experience SL on 19/01/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import "KCItemDetailsViewController.h"
#import "KCItemDetailTableViewCell.h"
#import "KCItemIngredientsTableViewCell.h"
#import "KCitemIngredientCountTableViewCell.h"
#import "KCRecipeStepTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "KCItem.h"
#import "KCMenuWebManager.h"
#import "KCItemDetail.h"
#import "KCRecipeDBManager.h"
#import "KCScheduleAlert.h"
#import "KCUserScheduleWebManager.h"


@interface KCItemDetailsViewController () <UITableViewDataSource, UITableViewDelegate> {
    NSInteger           _ingredientsCount;
    NSInteger           _recipeStepsCount;
    KCUserProfile       *_userProfile;
    KCMenuWebManager    *_menuWebManager;
    KCItemDetail        *_itemDetails;
    KCRecipeDBManager   *_recipeDBManager;
    NSMutableArray      *_ingredinetSelectionArray;
    NSMutableArray      *_recipeRowHeightArray;
    IOSDevices          _deviceType;
    BOOL                    _isDisplayingAlert;
    UITapGestureRecognizer *_tapGesture;
    
}

@property (weak, nonatomic) IBOutlet UITableView *itemDetailsTableView;
@property (weak, nonatomic) IBOutlet UIButton *startCookingButton;
@property (weak, nonatomic) IBOutlet UIButton *scheduleForLaterButton;
@property (weak, nonatomic) UIButton *itemLikeButton;
@property (weak, nonatomic) UIButton *likeCounterButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *startCookingButtonHeightConstraintiPad;
@property (weak, nonatomic) IBOutlet UIImageView *startCookingImageView;
@property (weak, nonatomic) IBOutlet UIImageView *scheduleForLaterImageView;
@property (nonatomic,strong) UIImageView     *blurredImageView;
@property (nonatomic, strong) KCScheduleAlert *scheduleAlert;


//Ingredient selection label
@property (nonatomic,strong) UILabel *ingredientSelectionLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *startCookingButtonHeightConstraint;

@end

@implementation KCItemDetailsViewController

#pragma mark - Life Cycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Customize App UI
    [self customizeUI];
    
    //Get instances
    _userProfile            = [KCUserProfile sharedInstance];
    _recipeDBManager        = [KCRecipeDBManager new];
    _recipeRowHeightArray   = [[NSMutableArray alloc] init];
    
    _deviceType             = [KCUtility getiOSDeviceType];
    
    //Get ingredient selection Array
    _ingredinetSelectionArray = [[NSMutableArray alloc] initWithArray:[_recipeDBManager getItmesIngredinetsArrayForUser:_userProfile.userID forItem:self.selectedItem.itemIdentifier]];
    
    //Remove table footer view
    self.itemDetailsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    
    //Hide the button until the data loads
    self.scheduleForLaterButton.hidden  = YES;
    self.startCookingButton.hidden      = YES;
    
    //Feth item details
    [self fetchItemDetails];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //Set text on buttons and labels
    [self setText];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [NSThread cancelPreviousPerformRequestsWithTarget:self];
}

#pragma mark - Tableview Datasource and Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //Number of rows will be the sum of Recipe Steps, Ingredient Count and 2 more rows ie: 1 for Item details and 1 for Ingredient selection count
    NSInteger effectiveCount = _recipeStepsCount + _ingredientsCount;
    if(effectiveCount > 0) {
        return effectiveCount + 2;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger rowHeight = 0;
    if(indexPath.row == 0) {
        //Item details row
        if([KCUtility getiOSDeviceType] == iPad) {
            rowHeight = 681;
        }
        else {
          rowHeight = 664;
        }
        
    }
    else if (indexPath.row <= _ingredientsCount) {
        //Ingredient row
        rowHeight = 55;
    }
    else if (indexPath.row == _ingredientsCount+1) {
        //Ingredients count row
        if([KCUtility getiOSDeviceType] == iPad) {
           rowHeight = 62;
        }
        else {
            rowHeight = 55;
        }
        
    }
    else {
        //Recipe steps row
        NSInteger effectivePosition = indexPath.row - (_ingredientsCount + 2) ;
        NSInteger labelWidth  = CGRectGetWidth(self.view.frame) - 34;
        KCItemRecipeStep *recipeStep = [_itemDetails.itemRecipeStepArray objectAtIndex:effectivePosition];
        rowHeight = 395;
        NSInteger labelHeight = [NSString getHeightForText:recipeStep.recipeStep withViewWidth:labelWidth withFontSize:15];
        if(labelHeight > 60) {
            rowHeight += labelHeight-60;
            [_recipeRowHeightArray addObject:[NSNumber numberWithInteger:labelHeight]];
        }
        else {
            [_recipeRowHeightArray addObject:[NSNumber numberWithInteger:60]];
        }
    }
    return rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *tableViewCell = nil;
    if(indexPath.row == 0) {
        //Item details row
        KCItemDetailTableViewCell *itemDetailTableCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierForItemDetails forIndexPath:indexPath];
        itemDetailTableCell.itemImageView.image = nil;
        
        //Set text on labels
        [self customizeItemDetailCell:itemDetailTableCell];
        [self setDataOnItemDetailCelll:itemDetailTableCell];
        self.itemLikeButton        = itemDetailTableCell.itemLikeButton;
        self.likeCounterButton     = itemDetailTableCell.likeCounterButton;
        if(_itemDetails.isItemFavorite) {
            self.itemLikeButton.selected = YES;
        }
        else {
            self.itemLikeButton.selected = NO;
        }
        tableViewCell = itemDetailTableCell;
    }
    else if (indexPath.row <= _ingredientsCount) {
        //Ingredient row
        KCItemIngredientsTableViewCell *itemIngredientsTableCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierForItemIngredients forIndexPath:indexPath];
        itemIngredientsTableCell.ingredientLabel.font  = [UIFont setRobotoFontRegularStyleWithSize:13];
        itemIngredientsTableCell.ingredientLabel.textColor = [UIColor lightGrayColor];
        NSInteger effectivePosition = indexPath.row -1;
        if([_itemDetails.itemIngredientArray count] > effectivePosition) {
            KCItemIngredient *itemIngredient = [_itemDetails.itemIngredientArray objectAtIndex:effectivePosition];
            itemIngredientsTableCell.ingredientLabel.text = itemIngredient.ingredientTitle;
            itemIngredientsTableCell.ingredientLabel.adjustsFontSizeToFitWidth = YES;
            if([_ingredinetSelectionArray containsObject:itemIngredient.ingredientIdentifer]) {
                itemIngredientsTableCell.ingredientAvailableButton.selected = YES;
            }
            else {
                itemIngredientsTableCell.ingredientAvailableButton.selected = NO;
            }
        }
        if(indexPath.row%2 == 0) {//Chage background for ODD EVEN cell
            itemIngredientsTableCell.containerView.backgroundColor = [UIColor cellBackgroundColor];
        }
        else {
            itemIngredientsTableCell.containerView.backgroundColor = [UIColor whiteColor];
        }
        
        //Add gesture for cell selection
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesturePerformed:)];
        [itemIngredientsTableCell.containerView addGestureRecognizer:tapGesture];
        itemIngredientsTableCell.containerView.tag = indexPath.row;
        
        tableViewCell = itemIngredientsTableCell;
    }
    else if (indexPath.row == _ingredientsCount+1) {
        //Ingredients count row
        KCitemIngredientCountTableViewCell *ingrdientCountTableCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierForItemIngredientCount forIndexPath:indexPath];
        //Customize cell
        [self customizeItemIngredientCountCell:ingrdientCountTableCell];
        ingrdientCountTableCell.ingredientAvailableCount.text = [NSString stringWithFormat:@"%@/%@",[NSNumber numberWithInteger:[_ingredinetSelectionArray count]],[NSNumber numberWithInteger:_ingredientsCount]];
        ingrdientCountTableCell.ingredientAvailableCount.font = [UIFont setRobotoFontRegularStyleWithSize:14];
        self.ingredientSelectionLabel = ingrdientCountTableCell.ingredientAvailableCount;
        tableViewCell = ingrdientCountTableCell;
        
    }
    else {
        //Recipe steps row
        KCRecipeStepTableViewCell *recipeStepTableCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierForItemRecipeStep forIndexPath:indexPath];
        //Customize cell
        [self customizeRecipeStepCell:recipeStepTableCell];
        
        //Set data on cell
        NSInteger effectivePosition = indexPath.row - (_ingredientsCount + 2) ;
        if([_itemDetails.itemRecipeStepArray count] > effectivePosition) {
            KCItemRecipeStep *recipeStep = [_itemDetails.itemRecipeStepArray objectAtIndex:effectivePosition];
            
            NSMutableParagraphStyle *paragraphStyles = [[NSMutableParagraphStyle alloc] init];
            paragraphStyles.alignment = NSTextAlignmentLeft;
            paragraphStyles.firstLineHeadIndent = 1.0;
            
            NSDictionary *attributes = @{NSParagraphStyleAttributeName: paragraphStyles, NSFontAttributeName:[UIFont setRobotoFontRegularStyleWithSize:14]};
            NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString: recipeStep.recipeStep attributes: attributes];
            recipeStepTableCell.recipeProcedureLabel.attributedText = attributedString;
            
            //Set Image with Aynsc blocks
            [recipeStepTableCell.recipeStepImageDownloadActivityIndicator startAnimating];
            [recipeStepTableCell.recipeStepImageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:recipeStep.imageURL]] placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                    [recipeStepTableCell.recipeStepImageDownloadActivityIndicator stopAnimating];
                recipeStepTableCell.recipeStepImageView.image = image;
            } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                [recipeStepTableCell.recipeStepImageDownloadActivityIndicator stopAnimating];
            }];
            recipeStepTableCell.stepPositionLabel.font = [UIFont setRobotoFontItalicStyleWithSize:14];
            recipeStepTableCell.stepPositionLabel.text = [NSString stringWithFormat:@"%@ %@",AppLabel.lblStep,recipeStep.stepPosition];
            
            //Adjust label height
            NSInteger labelHeight = [[_recipeRowHeightArray objectAtIndex:effectivePosition] integerValue];
            if(labelHeight > 60) {
                recipeStepTableCell.receipeProcedureLabelHeightConstraint.constant = labelHeight;
                [recipeStepTableCell.recipeProcedureLabel updateConstraints];
            }
        }
        
        tableViewCell = recipeStepTableCell;
    }
    tableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return tableViewCell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    }

#pragma mark - Button Actions

- (IBAction)backButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)startCookingButtonTapped:(id)sender {
    
}

- (IBAction)scheduleForLaerButtonTapped:(id)sender {
    
}

- (IBAction)addItemToFavoriteButtonTapped:(UIButton*)sender {
    // Add or remove this item from favorite
    [self addRemoveItemFromFavorite];
}


#pragma mark - Animation Methods

- (void) zoomOutAnimationOnView:(UIView*)view {
    view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 2.0, 2.0);
    [UIView animateWithDuration:0.5
                     animations:^{
                         view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
                     } completion:^(BOOL finished) {
                         
                     }];
}

#pragma mark - Gesture Recoginizer

- (void) tapGesturePerformed:(UIGestureRecognizer*)gestureRecognizer {
    //If Ingredients selected then show as Yellow tick
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:gestureRecognizer.view.tag inSection:0];
    if(indexPath.row >= 1 && indexPath.row < _ingredientsCount+1) {
        KCItemIngredientsTableViewCell *itemIngredientsTableCell  = [self.itemDetailsTableView cellForRowAtIndexPath:indexPath];
        NSInteger effectivePosition = indexPath.row -1;
        if([_itemDetails.itemIngredientArray count] > effectivePosition) {
            KCItemIngredient *itemIngredient = [_itemDetails.itemIngredientArray objectAtIndex:effectivePosition];
            if(itemIngredientsTableCell.ingredientAvailableButton.isSelected) {
                [_recipeDBManager removeItemIngredientAvailability:itemIngredient.ingredientIdentifer forUser:_userProfile.userID andItem:self.selectedItem.itemIdentifier];
                [_ingredinetSelectionArray removeObject:itemIngredient.ingredientIdentifer];
            }
            else {
                [_ingredinetSelectionArray addObject:itemIngredient.ingredientIdentifer];
                [_recipeDBManager saveItemIngredientAvailability:itemIngredient.ingredientIdentifer forUser:_userProfile.userID andItem:self.selectedItem.itemIdentifier];
            }
            NSString *ingredientCount =   [NSString stringWithFormat:@"%@/%@",[NSNumber numberWithInteger:[_ingredinetSelectionArray count]],[NSNumber numberWithInteger:_ingredientsCount]];
            self.ingredientSelectionLabel.text = ingredientCount;
            
            
            Mixpanel *mixpanel = [Mixpanel sharedInstance];
            [mixpanel track:@"ingredient_tick"
                 properties:@{@"total_count":ingredientCount}];

            itemIngredientsTableCell.ingredientAvailableButton.selected = !itemIngredientsTableCell.ingredientAvailableButton.isSelected;
            [self zoomOutAnimationOnView:itemIngredientsTableCell.ingredientAvailableButton];
        }
    }
}

- (void)doubleTapGesturePerformed:(UIGestureRecognizer*)gestureRecognizer {
    // This double tap gesture will be required to like and unlike item with Gesture
    // Add or remove this item from favorite
    [self addRemoveItemFromFavorite];
}

#pragma mark - Instance Methods

- (void)addRemoveItemFromFavorite {
    // Add or remove item from favorite
    [self zoomOutAnimationOnView:self.itemLikeButton];
    
    // Toggle button selection
    self.itemLikeButton.selected = !self.itemLikeButton.isSelected;
    
    //Server request for adding/removing item to favorite
    [self shouldLikeItemWithStatus:self.itemLikeButton.isSelected];
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    NSString *favoriteStatus = self.itemLikeButton.isSelected ? @"favorite_on" : @"favorite_off";
    [mixpanel track:favoriteStatus
         properties:@{@"recipe_id":self.selectedItem.itemIdentifier}];

}

- (void) customizeItemDetailCell:(KCItemDetailTableViewCell*)itemDetailTableCell {
    //Customize Item Detail Table Cell
    
    //Set pre text on labels
    itemDetailTableCell.yummliciousLabel.text       = AppLabel.lblYummylicious;
    itemDetailTableCell.minutesTextLabel.text       = AppLabel.lblMinutes;
    itemDetailTableCell.difficultyLabel.text        = AppLabel.lblDifficulty;
    itemDetailTableCell.servingsLabel.text          = AppLabel.lblServings;
    
    itemDetailTableCell.minutesTextLabel.adjustsFontSizeToFitWidth  = YES;
    itemDetailTableCell.difficultyLabel.adjustsFontSizeToFitWidth   = YES;
    itemDetailTableCell.servingsLabel.adjustsFontSizeToFitWidth     = YES;
    
    //Set the transparent color of the view for iPad only
    if([KCUtility getiOSDeviceType] == iPad) {
      itemDetailTableCell.itemDetailContainerView.backgroundColor = [UIColor transparentWhiteColor];
        itemDetailTableCell.scrollContentImageView.hidden         = YES;
    }
    else if (_deviceType == iPhone5 || _deviceType == iPhone4) {
        itemDetailTableCell.itemImageView.contentMode = UIViewContentModeScaleAspectFit;
        itemDetailTableCell.itemImageView.clipsToBounds = YES;
    }
    
    //Set fonts
    itemDetailTableCell.yummliciousLabel.font       = [UIFont setRobotoFontRegularStyleWithSize:17];
    itemDetailTableCell.minutesTextLabel.font       = [UIFont setHeleveticaBoldObliueFontWithSize:14];
    itemDetailTableCell.difficultyLabel.font        = [UIFont setHeleveticaBoldObliueFontWithSize:14];
    itemDetailTableCell.servingsLabel.font          = [UIFont setHeleveticaBoldObliueFontWithSize:14];
    
    itemDetailTableCell.recipeMinuteLabel.font      = [UIFont setRobotoFontRegularStyleWithSize:20];
    itemDetailTableCell.recipeDifficultyLabel.font  = [UIFont setRobotoFontRegularStyleWithSize:12];
    itemDetailTableCell.recipeServingLabel.font     = [UIFont setRobotoFontRegularStyleWithSize:20];
    itemDetailTableCell.itemTitleLabel.font         = [UIFont setRobotoFontRegularStyleWithSize:17];
    itemDetailTableCell.likeCounterButton.titleLabel.font = [UIFont setRobotoFontRegularStyleWithSize:16];
    itemDetailTableCell.cookCounterButton.titleLabel.font = [UIFont setRobotoFontRegularStyleWithSize:16];
    
    // Add double tap gesture on Item Image view to like and unlike
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapGesturePerformed:)];
    tapGesture.numberOfTapsRequired    = 2;
    itemDetailTableCell.itemImageView.userInteractionEnabled = YES;
    [itemDetailTableCell.itemImageView addGestureRecognizer:tapGesture];
    
}

- (void) customizeRecipeStepCell:(KCRecipeStepTableViewCell*)recipeStepTableViewCell {
    recipeStepTableViewCell.stepPositionLabel.font    = [UIFont setRobotoFontItalicStyleWithSize:14];
    recipeStepTableViewCell.recipeProcedureLabel.font = [UIFont setRobotoFontRegularStyleWithSize:13];
    recipeStepTableViewCell.recipeProcedureLabel.textAlignment = NSTextAlignmentLeft;
    recipeStepTableViewCell.stepBackgroundView.backgroundColor = [UIColor cellBackgroundColor];
    
    if(_deviceType == iPhone5 || _deviceType == iPhone4) {
        recipeStepTableViewCell.recipeStepImageView.contentMode = UIViewContentModeScaleAspectFit;
        recipeStepTableViewCell.recipeStepImageView.clipsToBounds = YES;
    }
}

- (void) customizeItemIngredientCountCell:(KCitemIngredientCountTableViewCell*)ingrdientCountTableCell {
    //Customize Item Ingredient Count Table Cell
    ingrdientCountTableCell.ingredientAvailabelLabel.text = AppLabel.lblTotalIngredientsAvailable;
    ingrdientCountTableCell.ingredientAvailabelLabel.font = [UIFont setRobotoFontRegularStyleWithSize:14];
    ingrdientCountTableCell.ingredientAvailableCount.font = [UIFont setRobotoFontRegularStyleWithSize:14];
    ingrdientCountTableCell.ingredientAvailabelLabel.textColor = [UIColor darkGrayColor];
    ingrdientCountTableCell.ingredientAvailableCount.textColor = [UIColor darkGrayColor];
}

- (void) setDataOnItemDetailCelll:(KCItemDetailTableViewCell*)itemDetailCell {
    //Set Data on Item Detail from server response
    itemDetailCell.itemTitleLabel.text = [self.selectedItem.title uppercaseString];
    
    //Set image with async blocks
    [itemDetailCell.itemImageDownloadActivityIndicator startAnimating];
    [itemDetailCell.itemImageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_itemDetails.imageURL]] placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        itemDetailCell.itemImageView.image = image;
       [itemDetailCell.itemImageDownloadActivityIndicator stopAnimating];
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
       [itemDetailCell.itemImageDownloadActivityIndicator stopAnimating];
    }];
    
    //Set other data
    [itemDetailCell.likeCounterButton setTitle:[NSString stringWithFormat:@"%@",_itemDetails.likeCounter] forState:UIControlStateNormal];
    [itemDetailCell.cookCounterButton setTitle:[NSString stringWithFormat:@"%@",_itemDetails.cookCounter] forState:UIControlStateNormal];
    itemDetailCell.recipeMinuteLabel.text  = [NSString stringWithFormat:@"%@", _itemDetails.duration];
    itemDetailCell.recipeServingLabel.text = [NSString stringWithFormat:@"%@", _itemDetails.servings];
    itemDetailCell.recipeDifficultyLabel.text = _itemDetails.difficulty;
    
    @autoreleasepool {
        //Set rating
        for (UIImageView *imageView in itemDetailCell.ratingStarImageViewArray) {
            if(imageView.tag <= [_itemDetails.ratings integerValue]) {
                imageView.image = [UIImage imageNamed:@"select_rating_icon.png"];
            }
            else {
                imageView.image = [UIImage imageNamed:@"deselect_rating_icon.png"];
            }
        }
    }
}

- (void)itemLikedSuccessFully {
    //Item added to user favorite
     _itemDetails.isItemFavorite    = YES;
    self.itemLikeButton.selected    = YES;
    _itemDetails.likeCounter        = [NSNumber numberWithInteger:[_itemDetails.likeCounter integerValue]+1];
    [self.likeCounterButton setTitle:[NSString stringWithFormat:@"%@",_itemDetails.likeCounter] forState:UIControlStateNormal];
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Favorite Recipe"
         properties:@{ @"Liked Items": _itemDetails.title}];
}

-(void)itemDislikedSuccessfully {
    //Item added to user favorite
    _itemDetails.isItemFavorite     = NO;
    self.itemLikeButton.selected    = NO;
    _itemDetails.likeCounter        = [NSNumber numberWithInteger:[_itemDetails.likeCounter integerValue]-1];
    [self.likeCounterButton setTitle:[NSString stringWithFormat:@"%@",_itemDetails.likeCounter] forState:UIControlStateNormal];
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Favorite Recipe"
         properties:@{ @"Disliked Items": _itemDetails.title}];
}

- (void) customizeUI {
    //Customize the app UI for font and color
    self.scheduleForLaterButton.backgroundColor = [UIColor scheduleForLaterButtonBackgroundColor];
    self.startCookingButton.backgroundColor     = [UIColor appBackgroundColor];
    self.scheduleForLaterButton.titleLabel.font = [UIFont setRobotoFontBoldStyleWithSize:14];
    self.startCookingButton.titleLabel.font     = [UIFont setRobotoFontBoldStyleWithSize:14];
    
    //Add table seperator for iPhones
    if([KCUtility getiOSDeviceType] != iPad) {
        self.itemDetailsTableView.separatorStyle    = UITableViewCellSeparatorStyleSingleLine;
        self.itemDetailsTableView.separatorColor    = [UIColor separatorLineColor];
        self.itemDetailsTableView.separatorInset    = UIEdgeInsetsZero;
    }
}

- (void) setText {
    [self.scheduleForLaterButton setTitle:AppLabel.btnScheduleForLater forState:UIControlStateNormal];
    [self.startCookingButton setTitle:AppLabel.btnScheduleNow forState:UIControlStateNormal];
}

- (void)reloadDataWithResponse:(NSDictionary*)response {
    //Reload table data with server response
    _itemDetails = [KCItemDetail new];
    [_itemDetails getModelFromDictionary:response];
    _ingredientsCount = [_itemDetails.itemIngredientArray count];
    if(_itemDetails.receipeVisibility) {
      _recipeStepsCount = [_itemDetails.itemRecipeStepArray count];
    }
    else {
        _recipeStepsCount = 0;
    }
    
    [self.itemDetailsTableView reloadData];
    
    //show the button after data loads
    self.scheduleForLaterButton.hidden  = NO;
    self.startCookingButton.hidden      = NO;
    
    // Schedule a pop-up to ask if user is going too cook now
//    [self performSelector:@selector(scheduleMinuteReminder) withObject:self afterDelay:_itemDetails.popUpDuration];
}

#pragma mark  - Blur Effect

- (void)addBlurView {
    // Add a blur view
    UIImage *uiscreenSpanshot = [UIImage takeSnapshotOfView:self.navigationController.view];
    UIImage *blurredImage     = [UIImage blurWithCoreImage:uiscreenSpanshot withView:self.navigationController.view];
    if(!self.blurredImageView) {
        self.blurredImageView = [[UIImageView alloc] initWithFrame:self.navigationController.view.frame];
    }
    self.blurredImageView.image = blurredImage;
    [self.navigationController.view addSubview:self.blurredImageView];
    
    // Add tap gesture to close the pop-up on outside touch
    [self addTapGesture];
}

- (void) removeBlurView {
    [self.blurredImageView removeFromSuperview];
    // Remove tap gesture from super view
    [self removeTapGesture];
    _isDisplayingAlert         = NO;
}

#pragma mark - Schedule Pop Up

- (void)scheduleMinuteReminder {
    // User will get a Pop-Up after X minutes if they are cooking
    [self showScheduleApprovalAlertWithItemName:_itemDetails.title];
}

- (void)showScheduleApprovalAlertWithItemName:(NSString *)title {
    // Confirm user schedule
    if(!_isDisplayingAlert) {
        _isDisplayingAlert         = YES;
        NSInteger width  = 280;
        NSInteger height = 160;
        if(!_scheduleAlert) {
            _scheduleAlert = [KCScheduleAlert scheduleAlertWithFrame:CGRectMake((CGRectGetWidth(self.view.frame)-width)/2, 180, width, height)];
        }
        __weak KCItemDetailsViewController *weakSelf = self;
        [self addBlurView];
        [self.scheduleAlert showInView:self.navigationController.view withItemName:title withCompletionHandler:^(BOOL postiveButton) {
            _isDisplayingAlert = NO;
            [weakSelf removeBlurView];
            if(postiveButton) {
                // Request a user schedule for this item
                [weakSelf requestUserSchedule];
            }
            
        }];
    }
}

- (void)addTapGesture {
    // Add tap gesture to close the pop-up on outside touch
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesurePerformed:)];
    [self.navigationController.view addGestureRecognizer:_tapGesture];
}

- (void)removeTapGesture {
    // Remove tap gesture from view
    [self.navigationController.view removeGestureRecognizer:_tapGesture];
    _tapGesture = nil;
}

- (void)tapGesurePerformed:(UIGestureRecognizer*)gestureRecognizer {
    // Tap gesture performned outiside of the view
    [_scheduleAlert dismiss];
    [self removeBlurView];
}


#pragma mark - Server Actions

- (void) fetchItemDetails {
    //Fetch item details from server for the selected Item
    static BOOL isAlertOpen = NO;
    __weak id weakSelf = self;
    if(isNetworkReachable) {
        if(!_menuWebManager) {
            _menuWebManager = [KCMenuWebManager new];
        }
        [KCProgressIndicator showNonBlockingIndicator];
        NSDictionary *params = @{kUserID:_userProfile.userID, kAcessToken:_userProfile.accessToken, kLanguageID:_userProfile.languageID, kItemID:self.selectedItem.itemIdentifier};
        //Hit network request
        [_menuWebManager getItemsDetailsWithParametres:params withCompletionHandler:^(NSDictionary *itemsDetailDictionary) {
                [KCProgressIndicator hideActivityIndicator];
            //Reload data on table
            [weakSelf reloadDataWithResponse:itemsDetailDictionary];
           
        } andFailure:^(NSString *title, NSString *message) {
            [KCProgressIndicator hideActivityIndicator];
            [weakSelf fetchItemDetails];
        }];
    }
    else {
        //Show internet not available alert
        isAlertOpen = YES;
        [KCUIAlert showAlertWithButtonTitle:AppLabel.btnRetry alertHeader:AppLabel.errorTitle message:AppLabel.internetNotAvailable withButtonTapHandler:^(BOOL positiveButton){
            isAlertOpen = NO;
            if(positiveButton) {
                [weakSelf fetchItemDetails];
            }
        }];
    }
}

- (void) shouldLikeItemWithStatus:(BOOL)liked {
    if(isNetworkReachable) {
        __weak id weakSelf = self;
        __block BOOL status = liked;
        NSDictionary *params = @{kUserID:_userProfile.userID, kAcessToken:_userProfile.accessToken, kLanguageID:_userProfile.languageID, kItemID:self.selectedItem.itemIdentifier, kStatus:[NSNumber numberWithBool:liked]};
        [_menuWebManager addItemsToFavoriteWithParameters:params withCompletionHandler:^(NSDictionary *responseDictionary) {
            if(status) {
                //Item added to the favorite
                [weakSelf itemLikedSuccessFully];
            }
            else {
                // Items removed from favorite
                [weakSelf itemDislikedSuccessfully];
            }
            
            
        } andFailure:^(NSString *title, NSString *message) {
            [KCUIAlert showInformationAlertWithHeader:title message:message withButtonTapHandler:^{
                
            }];
        }];
    }
    else {
        //Show internet not available alert
        [KCUIAlert showInformationAlertWithHeader:AppLabel.errorTitle message:AppLabel.internetNotAvailable withButtonTapHandler:^{
            
        }];
    }
}

#pragma mark - Server End Code

- (void)requestUserSchedule {
    // Request a user schedule
    NSString *currentDate = [NSDate getCurrentDateInUTC];
    NSDictionary  *parameters = @{kUserID:_userProfile.userID, kLanguageID:_userProfile.languageID,kAcessToken:_userProfile.accessToken, kMenuID:_itemDetails.menuIdentifier, kCourseID:_itemDetails.courseIdentifier,kItemID:self.selectedItem.itemIdentifier, kMenuPreferences:[NSNumber numberWithBool:_itemDetails.isMenuPreferencesOn], kLanguagePreference:[NSNumber numberWithBool:_itemDetails.isLanguagePreferencesOn], kCoursePreferences:[NSNumber numberWithBool:_itemDetails.isCoursePreferencesOn], kScheduleType:kRecipeNowSchedule, kScheduleDate:currentDate, kRequestType:kNewRequest, kAPIAction:scheduleACallNowAction};
    
    //Find other users to connect with
    if(isNetworkReachable) {
        KCUserScheduleWebManager *userScheduleWebManager = [KCUserScheduleWebManager new];
        // Network request for Scheduling a call
        [userScheduleWebManager findUserForConnectionWithParameters:parameters withCompletionHandler:^(NSDictionary *responseDictionary) {
            //Request completed with response
        } andFailure:^(NSString *title, NSString *message) {
        }];
    }
}

@end
