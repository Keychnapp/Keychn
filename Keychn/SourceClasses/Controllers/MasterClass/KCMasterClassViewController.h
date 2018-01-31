//
//  KCMasterClassViewController.h
//  Keychn
//
//  Created by Keychn Experience SL on 21/03/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KCGroupSession;

@interface KCMasterClassViewController : UIViewController

@property (copy,nonatomic) NSNumber *masterClassID;
@property (assign, nonatomic) BOOL hasPurhcased;
@property (strong, nonatomic) KCGroupSession  *groupSession;

@end
