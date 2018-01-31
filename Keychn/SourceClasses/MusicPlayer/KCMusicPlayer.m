//
//  KCMusicPlayer.m
//  Keychn
//
//  Created by Keychn Experience SL on 15/02/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import "KCMusicPlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface KCMusicPlayer () <AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@end

@implementation KCMusicPlayer

- (void)playCallerTune {
    //Play music
    NSError *error;
    NSURL *sound_file = [NSURL URLWithString:[[NSBundle mainBundle] pathForResource:@"ring_bell" ofType:@"mp3"]];
    if(DEBUGGING) NSLog(@"Play audio file %@",sound_file);
    self.audioPlayer = [[AVAudioPlayer alloc]
                        initWithContentsOfURL:sound_file error:&error];
    if(DEBUGGING) NSLog(@"Error in initiating Audio Player %@",error.description);
    self.audioPlayer.delegate = self;
    [self.audioPlayer prepareToPlay];
    [self.audioPlayer play];
    self.audioPlayer.numberOfLoops = -1; //For Continious playing
}

- (void) stopCallerTune {
    //Stop music
    if(DEBUGGING) NSLog(@"Stop music play");
    [self.audioPlayer stop];
    self.audioPlayer = nil;
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if(DEBUGGING) NSLog(@"audioPlayerDidFinishPlaying with status %@",[NSNumber numberWithBool:flag]);
}

/* if an error occurs while decoding it will be reported to the delegate. */
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
    if(DEBUGGING) NSLog(@"audioPlayerDecodeErrorDidOccur %@",error.description);
}

@end
