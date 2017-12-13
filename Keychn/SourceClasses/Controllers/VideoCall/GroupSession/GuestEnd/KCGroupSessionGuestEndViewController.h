//
//  KCGroupSessionGuestEndViewController.h
//  Keychn
//
//  Created by Keychn Experience SL on 25/04/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KCGroupSessionGuestEndViewController : UIViewController

@property (copy,nonatomic) NSString *conferenceID;
@property (copy,nonatomic) NSString *hostName;
@property (copy, nonatomic) NSNumber *sessionID;
@property (copy, nonatomic) NSNumber *chefUserID;
@property (assign, nonatomic) NSTimeInterval startTimeInterval;

@end
