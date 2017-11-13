//
//  KCCalendarView.m
//  Keychn
//
//  Created by Keychn Experience SL on 04/01/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import "KCCalendarView.h"

@implementation KCCalendarView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.dayLabel  = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), 15)];
    self.roundView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(frame)/2-3, 20, 6, 6)];
    
    
    NSInteger dateLabelSize = 32;
    NSInteger dateLabelX = (CGRectGetWidth(frame) -dateLabelSize)/2;
    
    self.dateButton = [[UIButton alloc] initWithFrame:CGRectMake(dateLabelX, 33, dateLabelSize, dateLabelSize)];
    self.dayLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.dayLabel];
    [self addSubview:self.roundView];
    [self addSubview:self.dateButton];
    [self bringSubviewToFront:self.dateButton];
    return self;
}

@end
