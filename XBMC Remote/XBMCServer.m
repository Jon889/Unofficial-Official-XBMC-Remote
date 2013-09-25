//
//  XBMCServer.m
//  XBMC Remote
//
//  Created by Jonathan on 19/09/2013.
//  Copyright (c) 2013 joethefox inc. All rights reserved.
//

#import "XBMCServer.h"
#import "GlobalData.h"
#import "XBMCPlayer.h"
#import "NSURL+Builder.h"

#import "XBMCNotificationListener.h"


@interface XBMCServer ()
@property (readwrite) NSInteger version;
@property (readwrite) NSInteger minorVersion;
@property (nonatomic, strong) XBMCNotificationListener *listener;
@property (nonatomic, strong) NSTimer *heartbeatTimer;
@end

@implementation XBMCServer
static id currentServer = nil;
+(XBMCServer *)currentServer {
    return currentServer;
}
+(void)setCurrentServer:(XBMCServer *)server {
    currentServer = server;
}
-(id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.serverDescription = dict[@"serverDescription"];
        self.username = dict[@"serverUser"];
        self.password = dict[@"serverPass"];
        self.ip = dict[@"serverIP"];
        self.serverPort = dict[@"serverPort"];
        self.MACAddress = dict[@"serverMacAddress"];
        self.preferTVPosters = [dict[@"preferTVPosters"] boolValue];
        self.tcpPort = [dict[@"tcpPort"] integerValue];
        self.notificationListener = [[XBMCNotificationListener alloc] initWithServer:self];
        [self.notificationListener addTarget:self action:@selector(updateActivePlayers) forMethod:@"Player.OnPlay"];
        [self.notificationListener addTarget:self action:@selector(updateActivePlayers) forMethod:@"Player.OnStop"];
        [self updateActivePlayers];
        [self loadServerInfo];
    }
    return self;
}
-(void)dealloc {
    [self.heartbeatTimer invalidate];
}
-(DSJSONRPC *)jsonRPC {
    if (!_jsonRPC) {
        NSURL *url = [NSURL URLWithScheme:@"http"
                                 username:self.username
                                 password:self.password
                                     host:self.ip
                                     port:[self.serverPort integerValue]
                                     path:@"jsonrpc"];
        _jsonRPC = [[DSJSONRPC alloc] initWithServiceEndpoint:url];
    }
    return _jsonRPC;
}
-(void)loadServerInfo {
    [self.jsonRPC callMethod:@"Application.GetProperties"
              withParameters:@{ @"properties" : @[ @"version" ] }
                onCompletion:^(NSString *methodName, NSInteger callId, id methodResult, DSJSONRPCError *methodError, NSError* error) {
                    if (error == nil && methodError == nil && methodResult) {
                        NSDictionary *version = methodResult[@"version"];
                        self.version = [version[@"major"] integerValue];
                        self.minorVersion = [version[@"minor"] integerValue];
                    }
                }];
}
-(void)heartbeat {
    //[self updateActivePlayers];
}
-(XBMCPlayer *)activePlayer {
    return self.activePlayers[0];
}
-(void)updateActivePlayers {
    [self getActivePlayers:^(NSArray *players) {
        self.activePlayers = players;
    }];
}
-(void)getActivePlayers:(void(^)(NSArray *players))completion {
    [self.jsonRPC callMethod:@"Player.GetActivePlayers" withParameters:@{} onCompletion:^(NSString *methodName, NSInteger callId, id methodResult, DSJSONRPCError *methodError, NSError* error) {
        if (error == nil && methodError == nil && [methodResult count] > 0) {
            NSMutableArray *collector = [NSMutableArray array];
            for (NSDictionary *result in methodResult) {
                [collector addObject:[[XBMCPlayer alloc] initWithServer:self resultsDictionary:result]];
            }
            completion([NSArray arrayWithArray:collector]);
        } else {
            completion(nil);
        }
    }];
}
@end
