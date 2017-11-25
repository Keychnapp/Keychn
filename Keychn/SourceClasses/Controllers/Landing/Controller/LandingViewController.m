//
//  LandingViewController.m
//  Keychn
//
//  Created by Rohit Kumar on 25/11/2017.
//  Copyright © 2017 Keychn Experience. All rights reserved.
//

#import "LandingViewController.h"
#import "LandingCollectionViewCell.h"


@interface LandingViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

#define kOnboardingTextArray @[@"Cook live and share a new\nexperience with chefs", @"All our classes are interactive\nand in live video", @"Learn from experts about\n  gastronomy"]
#define kOnBoardImageArray @[@"onboarding_1", @"onboarding_2", @"onboarding_3"]

@property (weak, nonatomic) IBOutlet UICollectionView *onBoardingCollectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;



@end

@implementation LandingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return  3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LandingCollectionViewCell *onBoardingCollectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifierForOnboardCollection forIndexPath:indexPath];
    onBoardingCollectionViewCell.onboardImageView.image = [UIImage imageNamed:[kOnBoardImageArray objectAtIndex:indexPath.row]];
    onBoardingCollectionViewCell.onBoardTextLabel.text  = [kOnboardingTextArray objectAtIndex:indexPath.row];
    return  onBoardingCollectionViewCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.onBoardingCollectionView.bounds.size;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // Set page control current page
    CGFloat pageWidth = self.onBoardingCollectionView.frame.size.width;
    self.pageControl.currentPage = self.onBoardingCollectionView.contentOffset.x / pageWidth;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
