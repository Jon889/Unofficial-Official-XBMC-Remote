//
//  XBMCPlayer.m
//  XBMC Remote
//
//  Created by Jonathan on 19/09/2013.
//  Copyright (c) 2013 joethefox inc. All rights reserved.
//

#import "XBMCPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "XBMCNotificationListener.h"
#import "LockscreenMediaControls.h"
#import "XBMCMovie.h"

@interface XBMCPlayer ()
@property (nonatomic) NSInteger playerID;
@property (nonatomic) BOOL isPlaying;
@property (nonatomic) NSTimeInterval progress;
@end

@implementation XBMCPlayer
-(id)initWithServer:(XBMCServer *)server resultsDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.server = server;
        self.playerID = [dict[@"playerid"] integerValue];
        self.playerType = dict[@"type"];
        [self getIsPlaying];
        [self getPlayingItem];
        [self.server.notificationListener addTarget:self action:@selector(onPause:) forMethod:@"Player.OnPause"];
        [self.server.notificationListener addTarget:self action:@selector(onPlay:) forMethod:@"Player.OnPlay"];
        [self.server.notificationListener addTarget:self action:@selector(onStop:) forMethod:@"Player.OnStop"];
        [self.server.notificationListener addTarget:self action:@selector(onSeek:) forMethod:@"Player.OnSeek"];
    }
    return self;
}

-(void)dealloc {
    [self.server.notificationListener removeTarget:self];
}

-(void)onPause:(NSDictionary *)dict {
    self.isPlaying = NO;
    [[LockscreenMediaControls sharedInstance] pause];
}
-(void)onPlay:(NSDictionary *)dict {
    self.isPlaying = YES;
    [[LockscreenMediaControls sharedInstance] play];
    [self getPlayingItem];
}
-(void)onStop:(NSDictionary *)dict {
    self.isPlaying = NO;
    [[LockscreenMediaControls sharedInstance] stop];
    [self getPlayingItem];
}
-(void)onSeek:(NSDictionary *)dict {
    [self getPlayingItem];
}
-(NSTimeInterval)timeIntervalFromTimeDict:(NSDictionary *)time {
    return [time[@"hours"] integerValue]*60*60 + [time[@"minutes"] integerValue]*60 + [time[@"seconds"] integerValue];
}
-(void)getIsPlaying {
    [self playbackAction:@"Player.GetProperties" params:@{ @"properties" : @[ @"speed", @"time" ] } completion:^(id result) {
        if ([result[@"speed"] integerValue] == 1) {
            self.isPlaying = YES;
            [[LockscreenMediaControls sharedInstance] play];
        }
        self.progress = [self timeIntervalFromTimeDict:result[@"time"]];
    }];
}
-(void)getPlayingItem {
    NSArray *properties = @[ @"artist", @"albumlabel", @"title", @"duration", @"runtime", @"studio", @"thumbnail" ];
    [self playbackAction:@"Player.GetItem" params:@{ @"playerid" : @(self.playerID), @"properties" : properties } completion:^(NSDictionary *result){
        NSDictionary *item = result[@"item"];
        if ([item[@"type"] isEqualToString:@"movie"]) {
            XBMCMovie *movie = [[XBMCMovie alloc] initWithServer:self.server dictionary:item];
            self.playingItem = movie;
            [[LockscreenMediaControls sharedInstance] updateAllCurrentlyPlaying];
            if (self.isPlaying) {
                [[LockscreenMediaControls sharedInstance] play];
            } else {
                [[LockscreenMediaControls sharedInstance] pause];
            }
        }
    }];
}
    
    
-(void)playPause {
    [self playbackAction:@"Player.PlayPause" params:nil completion:nil];
    
}
-(void)play {
    [self setPlaySpeed:1];
}
-(void)pause {
    [self setPlaySpeed:0];
}
-(void)setPlaySpeed:(NSInteger)speed {
    //speed must be -32,-16,-8,-4,-2,-1,0,1-32
    [self playbackAction:@"Player.SetSpeed" params:@{ @"speed" : @(speed) } completion:nil];
}
-(void)previous {
    NSString *action = @"Player.GoPrevious";
    NSDictionary *params = nil;
    if (self.server.version > 11) {
        action = @"Player.GoTo";
        params = @{ @"to" : @"previous" };
    }
    [self playbackAction:action params:params completion:nil];
}
-(void)stop {
    [self playbackAction:@"Player.Stop" params:nil completion:nil];
}
-(void)next {
    NSString *action = @"Player.GoNext";
    NSDictionary *params = nil;
    if (self.server.version > 11) {
        action = @"Player.GoTo";
        params = @{ @"to" : @"next" };
        [self playbackAction:action params:params completion:nil];
    }
}
-(void)backward {
    [self playbackAction:@"Player.Seek" params:@{ @"value" : @"smallbackward" } completion:nil];
}
-(void)forward {
    [self playbackAction:@"Player.Seek" params:@{ @"value" : @"smallforward" } completion:nil];
}


-(void)playbackAction:(NSString *)action params:(NSDictionary *)parameters completion:(void(^)(id))completion {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:parameters];
    params[@"playerid"] = @(self.playerID);
    [self.server.jsonRPC callMethod:action withParameters:params onCompletion:^(NSString *methodName, NSInteger callId, id methodResult, DSJSONRPCError *methodError, NSError* error) {
        if (error == nil && methodError == nil && completion) {
            completion(methodResult);
        }
    }];
}
@end
