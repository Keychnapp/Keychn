//
//  KCMyScheduleViewController.h
//  Keychn
//
//  Created by Keychn Experience SL on 04/01/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KCMyScheduleViewController : UIViewController

/**
 @abstract This method will fetch MySchedules from server
 @param void
 @return void
 */
- (void)fetchMySchedule;

/**
 @abstract This method will refresh table data when there is a user schedule within 5 minutes.
 @param void
 @return void
 */
- (void)refreshUserSchedule;

@end
