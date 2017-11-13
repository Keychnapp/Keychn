//
//  KCUpdatePassword.h
//  Keychn
//
//  Created by Keychn Experience SL on 15/03/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KCUpdatePassword : NSObject

@property (nonatomic,copy) NSString *oldPassword;
@property (nonatomic,copy) NSString *newlyPassword;
@property (nonatomic,copy) NSString *confirmNewPassword;

@end
