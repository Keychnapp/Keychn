//
//  KCMasterclassPreview.h
//  Keychn
//
//  Created by Rohit Kumar on 30/01/2018.
//  Copyright © 2018 Keychn Experience. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KCMySchedule.h"

@interface KCMasterclassPreview : UIView

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) KCMySchedule *masterclassToJoin;


- (void)joinConferenceWithId:(NSString *)conferenceId forUser:(NSNumber *)userId;

@end
