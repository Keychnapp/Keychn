//
//  KCMyPreferenceViewController.h
//  Keychn
//
//  Created by Keychn Experience SL on 11/03/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KCMyPreferenceViewController : UIViewController

@property BOOL isDisplayingFriendPreference;
@property (nonatomic,copy) NSString *friendName;
@property (nonatomic,copy) NSNumber *friendID;
@property (nonatomic,copy) NSString *friendImageURL;
@property (nonatomic,copy) NSString *friendLocation;
@property (nonatomic,copy) NSNumber *unreadMessageCount;

@end
