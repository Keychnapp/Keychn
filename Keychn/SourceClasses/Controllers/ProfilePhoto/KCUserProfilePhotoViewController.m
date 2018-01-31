//
//  KCUserProfilePhotoViewController.m
//  Keychn
//
//  Created by Keychn Experience SL on 29/12/15.
//  Copyright © 2015 Keychn Experience SL. All rights reserved.
//

#import "KCUserProfilePhotoViewController.h"
#import "TOCropViewController.h"
#import "KCGeoLocation.h"
#import "KCUserProfileUpdateManager.h"
#import "KCUserProfile.h"

@interface KCUserProfilePhotoViewController () <UITextFieldDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, TOCropViewControllerDelegate> {
    NSInteger _keyboardDisplacementConstant;
    TOCropViewController *_photoCropper;
    KCUserProfileUpdateManager  *_profileImageUpdateManager;
    KCUserProfile               *_userProfile;
    UIImage                     *_selectedImage;
}

@property (weak, nonatomic) IBOutlet UIView *textFieldContainerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewTopConstraint;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UILabel *addProfilePictureLabel;
@property (weak, nonatomic) IBOutlet UITextField *locationTextField;
@property (weak, nonatomic) IBOutlet UIButton *nextStepButton;
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImageView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIView *profileImageContainerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *profileImageContainerViewHeight;
@property (strong,nonatomic) KCGeoLocation        *geoLocation;;

@end

@implementation KCUserProfilePhotoViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self customizeUI]; //Customize UI
    
    //get instances
    _userProfile = [KCUserProfile sharedInstance];
    
    //get user current location from GPS and show in text field
    self.geoLocation = [[KCGeoLocation alloc] init];
    __weak KCUserProfilePhotoViewController *weakSelf = self;
    [_geoLocation getUserLocationWithCompletionHandeler:^(BOOL status) {
        if(status) {
            [weakSelf didLocationUpdate];
        }
        
    }];
    
    if([KCUtility getiOSDeviceType] == iPhone4 || iPhone5){
        [self adjustUI]; //adjust UI for smaller screens
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self registerForKeyboardNotifications]; //register Keyboard Notification
    
    //set text
    [self setTextAndImage];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self deregisterForKeyboardNotifications]; //deregister for keyborad notifications
}


#pragma mark - Text Field Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)textFieldEditingChanged:(UITextField *)sender {
    _userProfile.location = sender.text;
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"profile_edit_location"
         properties:@{@"":@""}];

}


#pragma mark - Image Picker Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
   __weak KCUserProfilePhotoViewController *weakSelf = self;
    [self dismissViewControllerAnimated:YES completion:^{
        @autoreleasepool {
            UIImage *selectedImage       = info[UIImagePickerControllerOriginalImage];
            selectedImage                = [UIImage resizeImage:selectedImage scaledToSize:CGSizeMake(600, 600)];
            _photoCropper = [[TOCropViewController alloc] initWithImage:selectedImage];
            _photoCropper.delegate = weakSelf;
            [weakSelf presentViewController:_photoCropper animated:YES completion:nil];
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


#pragma mark - PhotoCropper Delegate 

- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle {
    // the newly cropped image
    __weak id weakSelf = self;
    [self dismissViewControllerAnimated:YES completion:^{
        [weakSelf didFinishImageCroppingWithImage:image];
    }];
}

- (void)didFinishImageCroppingWithImage:(UIImage*)image {
    self.userProfileImageView.image  = image;
    self.addProfilePictureLabel.text = NSLocalizedString(@"changeProfilePicture", nil);
    _selectedImage                   = image;
}

#pragma mark - Keyboard Notifications

- (void) registerForKeyboardNotifications {
    //register for Keyboard Notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didKeyboardAppear:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didKeyboardDisappear:)
                                                 name:UIKeyboardDidHideNotification object:nil];
}


- (void) deregisterForKeyboardNotifications {
    //Remove keyboard observers
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

- (void) didKeyboardAppear:(NSNotification*)notification {
    IOSDevices deviceType = [KCUtility getiOSDeviceType];
    switch (deviceType) {
        case iPhone4:
            _keyboardDisplacementConstant = 190;
            break;
        case iPhone5:
            _keyboardDisplacementConstant = 160;
            break;
        case iPhone6:
            _keyboardDisplacementConstant = 100;
            break;
        case iPhone6Plus:
            _keyboardDisplacementConstant = 50;
        case iPhoneX:
            _keyboardDisplacementConstant = 30;
            break;
        case iPad:
            break;
    }
    [self.view layoutIfNeeded];
    self.containerViewTopConstraint.constant -= _keyboardDisplacementConstant;
    [UIView animateWithDuration:0.5
                     animations:^{
                         [self.view layoutIfNeeded]; // Called on parent view
                     }];
}

- (void) didKeyboardDisappear:(NSNotification*)notification {
    [self.view layoutIfNeeded];
    self.containerViewTopConstraint.constant += _keyboardDisplacementConstant;
    [UIView animateWithDuration:0.5
                     animations:^{
                         [self.view layoutIfNeeded]; // Called on parent view
                     }];
}

#pragma mark - Action Sheet Delegate 

- (void)openPhotoSelectionWithIndex:(ActionSheetCameraRollButtonIndex)buttonIndex {
    // Open Photos or Camera Options
    dispatch_async(dispatch_get_main_queue(), ^{
        UIImagePickerController *cameraRoll = nil;
        cameraRoll = [[UIImagePickerController alloc] init];
        cameraRoll.delegate                 = self;
        cameraRoll.navigationBar.barStyle = UIBarStyleDefault;
        switch (buttonIndex) {
            case actionSheetCameraRollGallery:
                //Get the images from gallery
                [cameraRoll setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
                [self presentViewController:cameraRoll animated:true completion:^{
                    
                }];
                break;
            case actionSheetCameraRollCamera:
                //Get the images from Camera if camera is available
                if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
                    [cameraRoll setSourceType:UIImagePickerControllerSourceTypeCamera];
                    
                    [self presentViewController:cameraRoll animated:true completion:^{
                        
                    }];
                }
                break;
        }
    });
}

#pragma mark - Button Action

- (IBAction)addProfilePhotoButtonTapped:(UIButton *)sender {
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"profile_edit_photo"
         properties:@{@"":@""}];

    [self.locationTextField resignFirstResponder];
    UIAlertController *photosAndCameraOption = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"selectAnOption", nil) message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *photosOption = [UIAlertAction actionWithTitle:NSLocalizedString(@"photos", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openPhotoSelectionWithIndex:actionSheetCameraRollGallery];
    }];
    UIAlertAction *cameraOption = [UIAlertAction actionWithTitle:NSLocalizedString(@"camera", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openPhotoSelectionWithIndex:actionSheetCameraRollCamera];
    }];
    UIAlertAction *cancelOption = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    if([KCUtility getiOSDeviceType] == iPad) {
        UIPopoverPresentationController *popPresenter = [photosAndCameraOption
                                                         popoverPresentationController];
        popPresenter.sourceView = sender;
        popPresenter.sourceRect = sender.bounds;
    }
    [photosAndCameraOption addAction:cameraOption];
    [photosAndCameraOption addAction:photosOption];
    [photosAndCameraOption addAction:cancelOption];
    [self presentViewController:photosAndCameraOption animated:YES completion:^{
        
    }];
}

- (IBAction)backButtonTapped:(id)sender {
    if(self.isEditingImage) {
        [self.locationTextField resignFirstResponder];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)nextStepButtonTapped:(id)sender {
    //upload image and location on server
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"profile_edit_location_submit | profile_edit_photo_submit"
         properties:@{@"":@""}];

    [self uploadProfilePhotoAndLocation];
}

#pragma mark - Instance Methods

- (void) adjustUI {
    //adjust UI for iPhone 4 and iPhone 5
    IOSDevices deviceType = [KCUtility getiOSDeviceType];
    NSInteger adjustmentFactor = 0;
    switch (deviceType) {
        case iPhone4:
            adjustmentFactor = 110;
            break;
        case iPhone5:
            adjustmentFactor = 60;
            break;
        default:
            break;
    }
    self.containerViewTopConstraint.constant -= adjustmentFactor;
    [self.textFieldContainerView updateConstraints];
}

- (void) customizeUI {
    //Customize UI
    [self.view bringSubviewToFront:self.textFieldContainerView];
    self.textFieldContainerView.layer.cornerRadius  = 20;
    self.textFieldContainerView.layer.masksToBounds = YES;
    self.nextStepButton.titleLabel.font = [UIFont setRobotoFontBoldStyleWithSize:14];
    self.headerLabel.font               = [UIFont setRobotoFontRegularStyleWithSize:17];
    self.addProfilePictureLabel.font    = [UIFont setRobotoFontItalicStyleWithSize:14];
    self.locationTextField.font         = [UIFont setRobotoFontRegularStyleWithSize:14];
    self.locationTextField.textColor    = [UIColor placeholderColorEmailSignUp];
    
    // Hide/Show back button
    self.backButton.hidden = !self.isEditingImage;
  
    /*
    //add a background layer
    CALayer *border = [CALayer layer];
    CGFloat borderWidth = 1;
    border.borderColor = [UIColor textFieldSeparatorColorEmailSignUp].CGColor;
    border.frame = CGRectMake(0, 29, 238, 30);
    border.borderWidth = borderWidth;
    [self.locationTextField.layer addSublayer:border];
    self.locationTextField.layer.masksToBounds = YES; */
}

- (void) setTextAndImage {
    // Set text on views
    if([NSString validateString:_userProfile.location]) {
       self.locationTextField.text         = _userProfile.location;
    }
    
    if(self.userProfileImageView.image || [NSString validateString:_userProfile.imageURL]) {
       self.addProfilePictureLabel.text    = NSLocalizedString(@"changeProfilePicture", nil);
    }
    else {
       self.addProfilePictureLabel.text    = NSLocalizedString(@"addProfilePicture", nil);
    }
    
    // Set user profile image
    if([NSString validateString:_userProfile.imageURL]) {
        [self.userProfileImageView setImageWithURL:[NSURL URLWithString:_userProfile.imageURL] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    
    
}

- (void)didLocationUpdate {
    // Location updated
    self.locationTextField.text = [[_geoLocation.city stringByAppendingString:@", "] stringByAppendingString:_geoLocation.country];
    _userProfile.location       = self.locationTextField.text;
    [_geoLocation stopLocationUpdate];
    _geoLocation                = nil;
}

- (void) pushNextViewController {
    _userProfile.selectedImage   = _selectedImage;
    if(self.isEditingImage) {
        // When editing image then go back to My Preference Screen
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        // When Siging Up, then go to Language selection viewController
        UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:selectLangugeViewController];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

#pragma mark - Server End Code 

- (void)uploadProfilePhotoAndLocation {
    if(!_profileImageUpdateManager) {
        _profileImageUpdateManager = [KCUserProfileUpdateManager new];
    }
    if(!self.userProfileImageView.image) {
        //image not selected
        [KCUIAlert showInformationAlertWithHeader:nil message:NSLocalizedString(@"profilePictureNotSelected", nil)  withButtonTapHandler:^{
            
        }];
    }
    else if(!_userProfile.location) {
        //location missing
        [KCUIAlert showInformationAlertWithHeader:nil message:NSLocalizedString(@"locationRequired", nil) withButtonTapHandler:^{
            
        }];
    }
    else if(!isNetworkReachable) {
        //internet connection not available
        [KCUIAlert showInformationAlertWithHeader:NSLocalizedString(@"networkError", nil) message:NSLocalizedString(@"tryReconnecting", nil) withButtonTapHandler:^{
            
        }];
    }
    else {
        if(!_selectedImage) {
            _selectedImage = self.userProfileImageView.image;
        }
        NSData *imageData        =  [UIImage compressImageInBytes:_selectedImage];
        NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                                _userProfile.userID,  kUserID,
                                _userProfile.location , kLocation
                                , nil];
        _userProfile.selectedImage  = _selectedImage;
        [_profileImageUpdateManager updateUserProfileWithImageData:imageData andParams:params withCompletionHandler:^(NSDictionary *userProfile) {
            //push next view controller
            [self pushNextViewController];
        } failure:^(NSString *title, NSString *message) {
            [KCUIAlert showInformationAlertWithHeader:title message:message withButtonTapHandler:^{
                
            }];
        }];
    }
}

@end
