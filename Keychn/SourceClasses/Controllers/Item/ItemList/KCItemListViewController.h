//
//  KCItemListViewController.h
//  Keychn
//
//  Created by Keychn Experience SL on 19/01/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KCMenu;

@interface KCItemListViewController : UIViewController

@property (nonatomic,strong) KCMenu *selectedMenu;

// Friend Scheduling only
@property BOOL isSchedulingWithFriend;
@property (copy,nonatomic) NSNumber  *selectedFriendID;
@property (copy,nonatomic) NSString *friendName;

- (void)scrollToTop;

@end
