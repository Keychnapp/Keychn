//
//  KCItemDetailsViewController.h
//  Keychn
//
//  Created by Keychn Experience SL on 19/01/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KCItem;

@interface KCItemDetailsViewController : UIViewController

@property (nonatomic,strong) KCItem *selectedItem;
@property BOOL    isRescedulingItem;
@property (nonatomic,copy) NSNumber       *scheduleID;
@property  NSTimeInterval scheduleDate;

// Friend Scheduling only
@property BOOL isSchedulingWithFriend;
@property (copy,nonatomic) NSNumber  *selectedFriendID;
@property (copy,nonatomic) NSString *friendName;

@end
