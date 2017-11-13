//
//  KCPageControl.m
//  PageControlDemo
//
//  Created by Keychn Experience SL on 10/02/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import "KCPageControl.h"

@interface KCPageControl () {
    NSInteger _bubbleDiameter;
}

@property (nonatomic,strong) NSMutableArray *bubbleButtonsArray;

@end


@implementation KCPageControl

@synthesize selecedPageBubbleDiameter=_selecedPageBubbleDiameter;
@synthesize selectedPageBubbleColor  = _selectedPageBubbleColor;
@synthesize pageBubbleColor          = _pageBubbleColor;

#pragma mark - Designated Intializer
- (instancetype)initWithNumberOfPages:(NSInteger)numberOfPages andBubbleSize:(NSInteger)bubbleDiameter andBubbleInterSpacing:(NSInteger)interSpacing {
    //Create a customized page control
    self = [super init];
    self.bubbleButtonsArray = [[NSMutableArray alloc] init];
    if(self) {
        _bubbleDiameter = bubbleDiameter;
        for (NSInteger i=0; i<numberOfPages; i++) {
            UIButton *bubbleButton = [UIButton buttonWithType:UIButtonTypeCustom];
            NSInteger xPosition    =  i*(interSpacing+bubbleDiameter);
            bubbleButton.frame     = CGRectMake(xPosition, 15, bubbleDiameter, bubbleDiameter);
            bubbleButton.layer.cornerRadius = bubbleDiameter/2;
            bubbleButton.tag       = i;
            [self addSubview:bubbleButton];
            bubbleButton.backgroundColor    = [UIColor grayColor];
            [self.bubbleButtonsArray addObject:bubbleButton];
        }
        _selecedPageBubbleDiameter = -1;
//        //Select first page
//        [self selectAPageWithIndex:0];
        NSInteger viewSize = (bubbleDiameter+interSpacing)*numberOfPages;
        self.frame = CGRectMake(0, 20, viewSize, 30);
    }
    return self;
}

#pragma mark - Instance Methods

- (BOOL)selectAPageWithIndex:(NSInteger)index {
    if([self.bubbleButtonsArray count] > index) {
        @autoreleasepool {
            for (UIButton *bubbleButton in self.bubbleButtonsArray) {
                CGRect buttonFrame       = bubbleButton.frame;
                if(bubbleButton.tag == index) {
                    //Change seleced button size
                    bubbleButton.selected = YES;
                    //Default is 4 point increment for selected button
                    NSInteger increaseFactor = 4;
                    if(buttonFrame.size.height < _bubbleDiameter+increaseFactor) {
                        buttonFrame.size.height += increaseFactor;
                        buttonFrame.size.width  += increaseFactor;
                        buttonFrame.origin.y    -= increaseFactor/2;
                    }
                    
                    /*if(_selecedPageBubbleDiameter > 0) {
                        //Set custom size provided by developer
                        buttonFrame.size.height = _selecedPageBubbleDiameter;
                        buttonFrame.size.width  = _selecedPageBubbleDiameter;
                        buttonFrame.origin.y    = 15 -_selecedPageBubbleDiameter/2;
                    }
                    else {
                        //Default is 6 point increment for selected button
                        buttonFrame.size.height += 6;
                        buttonFrame.size.width  += 6;
                        buttonFrame.origin.y    -= 3;
                    }*/
                    if(self.selectedPageBubbleColor) {
                        bubbleButton.backgroundColor = self.selectedPageBubbleColor;
                    }
                }
                else {
                    //Reset other buttons sizes
                    buttonFrame.size.height = _bubbleDiameter;
                    buttonFrame.size.width  = _bubbleDiameter;
                    buttonFrame.origin.y    = 15;
                    bubbleButton.selected   = NO;
                    if(self.pageBubbleColor) {
                        bubbleButton.backgroundColor = self.pageBubbleColor;
                    }
                    else {
                        bubbleButton.backgroundColor = [UIColor grayColor];
                    }
                }
                bubbleButton.frame = buttonFrame;
                bubbleButton.layer.cornerRadius = CGRectGetHeight(buttonFrame)/2;
            }
        }
        return YES;
    }
    else {
        NSLog(@"Invalid page index in page control.");
        return NO;
    }
}

#pragma mark - Custom Getter and Setter

- (void)setSelecedPageBubbleDiameter:(NSInteger)diameter {
    _selecedPageBubbleDiameter = diameter;
}

- (NSInteger)selecedPageBubbleDiameter {
    return _selecedPageBubbleDiameter;
}

- (void)setSelectedPageBubbleColor:(UIColor *)color {
    //Set background color for selected button
    _selectedPageBubbleColor = color;
    @autoreleasepool {
        for (UIButton *bubbleButton in self.bubbleButtonsArray) {
            if(bubbleButton.isSelected) {
                bubbleButton.backgroundColor = self.selectedPageBubbleColor;
            }
            else  {
                if(self.pageBubbleColor) {
                    bubbleButton.backgroundColor = self.pageBubbleColor;
                }
                else {
                    bubbleButton.backgroundColor = [UIColor grayColor];
                }
            }
        }
    }
}

- (UIColor *)selectedPageBubbleColor {
   return  _selectedPageBubbleColor;
}

- (void)setPageBubbleColor:(UIColor *)color {
    //Set background color for unselected buttons
    _pageBubbleColor = color;
    @autoreleasepool {
        for (UIButton *bubbleButton in self.bubbleButtonsArray) {
            if(bubbleButton.isSelected) {
                if(self.selectedPageBubbleColor) {
                  bubbleButton.backgroundColor = self.selectedPageBubbleColor;
                }
                else {
                  bubbleButton.backgroundColor = self.pageBubbleColor;
                }
            }
            else  {
                bubbleButton.backgroundColor = self.pageBubbleColor;
            }
        }
    }
}

- (UIColor *)pageBubbleColor {
    return _pageBubbleColor;
}

@end
