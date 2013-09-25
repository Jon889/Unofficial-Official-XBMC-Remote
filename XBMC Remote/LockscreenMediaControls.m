//
//  LockscreenMediaControls.m
//  XBMC Remote
//
//  Created by Jonathan on 19/09/2013.
//  Copyright (c) 2013 joethefox inc. All rights reserved.
//

#import "LockscreenMediaControls.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "XBMCServer.h"
#import "XBMCMovie.h"

@interface LockscreenMediaControls ()
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@end
@implementation LockscreenMediaControls
static id shared = nil;
+(instancetype)sharedInstance {
    if (!shared) {
        shared = [[LockscreenMediaControls alloc] init];
    }
    return shared;
}
-(id)init {
    if (self = [super init]) {
        NSError *myErr;
        if ([[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&myErr]) {
            [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
        }
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"music" ofType:@"mp3"]] error:&myErr];
        [self.audioPlayer setNumberOfLoops:-1];
        [self.audioPlayer prepareToPlay];
        [self updateAllCurrentlyPlaying];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(remoteControlReceivedWithEvent:) name:@"XBMCRemoteControlReceivedWithEvent" object:nil];
    }
    return self;
}
-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"XBMCRemoteControlReceivedWithEvent" object:nil];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
}
-(void)updateAllCurrentlyPlaying {

    NSMutableDictionary *songInfo = [[NSMutableDictionary alloc] init];
    XBMCMovie *currentItem = [[[XBMCServer currentServer] activePlayer] playingItem];
    if (!!currentItem) {
        [songInfo setObject:currentItem.title forKey:MPMediaItemPropertyTitle];
        [songInfo setObject:currentItem.studios[0] forKey:MPMediaItemPropertyArtist];
        //    [songInfo setObject:@"XBMC AL" forKey:MPMediaItemPropertyAlbumTitle];
        [songInfo setObject:@(currentItem.duration) forKey:MPMediaItemPropertyPlaybackDuration];
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songInfo];
    }
    
}
-(void)play {
    [self.audioPlayer play];
    [self updateAllCurrentlyPlaying];
}
-(void)pause {
    [self.audioPlayer pause];
}
-(void)stop {
    [self.audioPlayer stop];
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:@{}];
}
-(void)seekTo:(NSTimeInterval)time {
    
}
-(void)remoteControlReceivedWithEvent:(NSNotification *)note {
    UIEvent *event = [note object];
        if (event.subtype == UIEventSubtypeRemoteControlPause) {
            [[[XBMCServer currentServer] activePlayer] pause];
        } else if (event.subtype == UIEventSubtypeRemoteControlNextTrack) {
            [[[XBMCServer currentServer] activePlayer] next];
        } else if (event.subtype == UIEventSubtypeRemoteControlPreviousTrack) {
            [[[XBMCServer currentServer] activePlayer] previous];
        } else if (event.subtype == UIEventSubtypeRemoteControlPlay) {
            [[[XBMCServer currentServer] activePlayer] play];
        }
}
@end
