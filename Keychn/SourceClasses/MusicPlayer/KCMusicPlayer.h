//
//  KCMusicPlayer.h
//  Keychn
//
//  Created by Keychn Experience SL on 15/02/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KCMusicPlayer : NSObject

/**
 @abstract This mehtod will play ringtone for incoming call
 @param No Parameter
 @return void
 */
- (void) playCallerTune;

/**
 @abstract This method will stop the ringtone music
 @param No Parameter
 @return void
 */
- (void) stopCallerTune;

@end
