//
//  KCPageControl.h
//  PageControlDemo
//
//  Created by Keychn Experience SL on 10/02/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KCPageControl : UIView

/**
 @abstract This method will create a custom page control
 @param Number of pages, Bubble Diameter, Bubble InterSpacing
 @return Instance Type
 */
- (instancetype) initWithNumberOfPages:(NSInteger)numberOfPages andBubbleSize:(NSInteger)bubbleDiameter andBubbleInterSpacing:(NSInteger)interSpacing;

/**
 @abstract This methos will select a page and change the prefereces as customized by developer
 @param Page Index
 @return YES if page index found else NO
 */
- (BOOL) selectAPageWithIndex:(NSInteger)index;

//@property NSInteger                  *numberOfPages;
//@property CGRect                     pageBubbleSize;
@property NSInteger                  selecedPageBubbleDiameter;
@property (nonatomic,strong) UIColor *pageBubbleColor;
@property (nonatomic,strong) UIColor *selectedPageBubbleColor;
@property (nonatomic,strong) UIImage *pageBubbleImage;
@property (nonatomic,strong) UIImage *selectedPageBubbleImage;
@property NSInteger                  *pageBubbleInterSpacing;



@end
