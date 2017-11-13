//
//  KCOnBoardViewController.m
//  Keychn
//
//  Created by Keychn on 14/09/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import "KCOnBoardViewController.h"
#import "KCOnboardCollectionViewCell.h"

#define kOnBoardImageArray @[@"pot_big.png", @"camera_big.png", @"bulb_big.png", @"people_big.png", @"book_big.png", @"calendar_big.png"]
#define kEnTitle        @[@"COOK", @"LIVE VIDEO STREAMING", @"MASTERCLASSES", @"FRIENDS LIST", @"LEARN", @"MySCHEDULE"]
#define kSpTitle        @[@"COCINA", @"LIVE VIDEO STREAMING", @"MASTERCLASSES", @"FRIENDS LIST", @"APRENDE", @"MiCALENDARIO"]
#define kEnDescription  @[@"Share the experience \nwith others", @"Our interactions are in\nreal time", @"Learn from Experts", @"Add them and share", @"With our tutorials, recipes\nand interactions", @"Schedule an interaction,\nselect recipe, day and time"]
#define kSpDescription  @[@"Comparte la experiencia\n con otros", @"Las interacciones son \nen tiempo real", @"Aprende con Expertos", @"Añade a tus amigos y\ncomparte", @"Con nuestros tutoriales,\nrecetas e interacciones", @"Programa una interacción,\nselecciona receta, día y hora"]

#define kOnboardViewCount 6

@interface KCOnBoardViewController () <UICollectionViewDataSource> {
    NSArray *_onBoardBackgroundColorArray;
}

@property (weak, nonatomic) IBOutlet UIPageControl *onboardPageControl;
@property (weak, nonatomic) IBOutlet UICollectionView *onboardCollectionView;

@end

@implementation KCOnBoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _onBoardBackgroundColorArray = [[NSArray alloc] initWithObjects:
                                    [UIColor onboardBackgroundColor1],
                                    [UIColor onboardBackgroundColor2],
                                    [UIColor onboardBackgroundColor3],
                                    [UIColor onboardBackgroundColor4],
                                    [UIColor onboardBackgroundColor5],
                                    [UIColor onboardBackgroundColor6]
                                    , nil];
    
    // Setup page control
    self.onboardPageControl.numberOfPages                   = kOnboardViewCount;
    self.onboardPageControl.pageIndicatorTintColor          = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    self.onboardPageControl.currentPageIndicatorTintColor   = [UIColor grayColor];
    
    // Customize collection view
    self.onboardCollectionView.showsHorizontalScrollIndicator = NO;
    self.onboardCollectionView.backgroundColor                = [UIColor appBackgroundColorWithOpacity:0.5];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
     [super viewDidAppear:animated];
     [self.onboardCollectionView reloadData];
}

#pragma mark - Collection View Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return kOnboardViewCount;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.view.frame.size;
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // Set page control current page
    CGFloat pageWidth = self.onboardCollectionView.frame.size.width;
    self.onboardPageControl.currentPage = self.onboardCollectionView.contentOffset.x / pageWidth;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    KCOnboardCollectionViewCell *colletionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifierForOnboardCollection forIndexPath:indexPath];
    
    // Add black outline color
    colletionViewCell.outlineCircleView.layer.borderWidth  = 4.0f;
    colletionViewCell.outlineCircleView.layer.borderColor  = [UIColor blackColor].CGColor;
    colletionViewCell.outlineCircleView.layer.cornerRadius = 95.0f;
    
    // Set backkground color
    colletionViewCell.backgroundColor        = [_onBoardBackgroundColorArray objectAtIndex:indexPath.row];
    
    // Set images
    colletionViewCell.boardImageView.image = [UIImage imageNamed:[kOnBoardImageArray objectAtIndex:indexPath.row]];
    
    // Set text
    colletionViewCell.enTitleLabel.text         = [kEnTitle objectAtIndex:indexPath.row];
    colletionViewCell.enDescriptionLabel.text   = [kEnDescription objectAtIndex:indexPath.row];
    colletionViewCell.spTitleLabel.text         = [kSpTitle objectAtIndex:indexPath.row];
    colletionViewCell.spDescriptionLabel.text   = [kSpDescription objectAtIndex:indexPath.row];
    
    return colletionViewCell;
}

#pragma mark - Button Action

- (IBAction)skipButtonTapped:(id)sender {
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"skipped_screen"
         properties:@{ @"screen_number": [NSString stringWithFormat:@"%@",@(self.onboardPageControl.currentPage)] }];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


@end
